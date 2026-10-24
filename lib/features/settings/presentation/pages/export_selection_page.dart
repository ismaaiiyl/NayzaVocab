import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/services/data_service.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/core/widgets/nayza_widgets.dart';
import 'package:nayza_vocab/features/settings/presentation/widgets/export_sets_list.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';

class ExportSelectionPage extends StatefulWidget {
  const ExportSelectionPage({super.key});

  @override
  State<ExportSelectionPage> createState() => _ExportSelectionPageState();
}

class _ExportSelectionPageState extends State<ExportSelectionPage> {
  final Set<String> _selectedSetIds = {};

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<VocabSetProvider>(context, listen: false);
    _selectedSetIds.addAll(provider.vocabSets.map((s) => s.id));
  }

  void _toggleSet(String id) {
    setState(() {
      if (_selectedSetIds.contains(id)) {
        _selectedSetIds.remove(id);
      } else {
        _selectedSetIds.add(id);
      }
    });
  }

  void _toggleAll(bool selectAll, List<String> ids) {
    setState(() {
      if (selectAll) {
        _selectedSetIds.addAll(ids);
      } else {
        _selectedSetIds.clear();
      }
    });
  }

  Future<void> _handleExport() async {
    final l10n = AppLocalizations.of(context)!;
    if (_selectedSetIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.selectAtLeastOneSet)),
      );
      return;
    }

    final provider = Provider.of<VocabSetProvider>(context, listen: false);
    final selectedSets = provider.vocabSets
        .where((s) => _selectedSetIds.contains(s.id))
        .toList();

    try {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(
          child: CircularProgressIndicator(color: AppTheme.electricGold),
        ),
      );

      if (selectedSets.length == 1) {
        final set = selectedSets.first;
        final lang = set.words.isNotEmpty
            ? (set.words.first.langCode?.toUpperCase() ?? 'N/A')
            : 'N/A';
        await DataService.shareSingleSet(
          set,
          subject: l10n.shareSubject(set.title),
          message: l10n.shareMessage(
            set.title,
            lang,
            set.words.length.toString(),
          ),
        );
      } else {
        final usedFolderIds =
            selectedSets.map((s) => s.folderId).whereType<String>().toSet();
        final selectedFolders = provider.folders
            .where((f) => usedFolderIds.contains(f.id))
            .map((f) => f.toMap())
            .toList();
        await DataService.exportSets(selectedSets, folders: selectedFolders);
      }

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(selectedSets.length == 1
                ? l10n.shareSuccess
                : l10n.exportSuccess),
            backgroundColor: AppTheme.success.withValues(alpha: 0.9),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.exportError(e.toString()))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<VocabSetProvider>(context);
    final vocabSets = provider.vocabSets;
    final folders = provider.folders;
    final l10n = AppLocalizations.of(context)!;

    final allIds = vocabSets.map((s) => s.id).toList();
    final allSelected =
        _selectedSetIds.length == vocabSets.length && vocabSets.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.selectSetsTitle)),
      body: Column(
        children: [
          if (vocabSets.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    allSelected ? l10n.deselectAll : l10n.selectAll,
                    style: const TextStyle(
                      color: AppTheme.textDim,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Checkbox(
                    value: allSelected,
                    onChanged: (val) => _toggleAll(val ?? false, allIds),
                    activeColor: AppTheme.electricGold,
                    checkColor: AppTheme.darkNavy,
                  ),
                ],
              ),
            ),
          const Divider(color: AppTheme.borderNavy),
          Expanded(
            child: ExportSetsList(
              vocabSets: vocabSets,
              folders: folders,
              provider: provider,
              selectedSetIds: _selectedSetIds,
              onToggleSet: _toggleSet,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: NayzaButton(
              text: l10n.exportAction(_selectedSetIds.length),
              icon: LucideIcons.download,
              onPressed: _handleExport,
            ),
          ),
        ],
      ),
    );
  }
}
