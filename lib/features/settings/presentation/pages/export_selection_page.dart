import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/core/widgets/nayza_widgets.dart';
import 'package:nayza_vocab/core/services/data_service.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/vocab_set_model.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/folder_model.dart';

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
    // Pre-select all by default for convenience
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
    final selectedSets = provider.vocabSets.where((s) => _selectedSetIds.contains(s.id)).toList();

    try {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator(color: AppTheme.electricGold)),
      );

      if (selectedSets.length == 1) {
        // Smart Share for single set (CSV + Beautiful Text)
        final set = selectedSets.first;
        final lang = set.words.isNotEmpty ? (set.words.first.langCode?.toUpperCase() ?? 'N/A') : 'N/A';
        await DataService.shareSingleSet(
          set,
          subject: l10n.shareSubject(set.title),
          message: l10n.shareMessage(set.title, lang, set.words.length.toString()),
        );
      } else {
        // Regular Backup for multiple sets (JSON)
        final usedFolderIds = selectedSets.map((s) => s.folderId).whereType<String>().toSet();
        final selectedFolders = provider.folders.where((f) => usedFolderIds.contains(f.id)).map((f) => f.toMap()).toList();
        await DataService.exportSets(selectedSets, folders: selectedFolders);
      }
      
      if (mounted) {
        context.pop(); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(selectedSets.length == 1 ? l10n.shareSuccess : l10n.exportSuccess),
            backgroundColor: Colors.greenAccent.withValues(alpha: 0.8),
          ),
        );
        context.pop(); // Return to settings
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        context.pop(); // Close loading
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
    final allSelected = _selectedSetIds.length == vocabSets.length && vocabSets.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.selectSetsTitle),
      ),
      body: Column(
        children: [
          if (vocabSets.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    allSelected ? l10n.deselectAll : l10n.selectAll,
                    style: const TextStyle(color: AppTheme.textDim, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Checkbox(
                    value: allSelected,
                    onChanged: (val) => _toggleAll(val!, allIds),
                    activeColor: AppTheme.electricGold,
                    checkColor: AppTheme.darkNavy,
                  ),
                ],
              ),
            ),
          const Divider(color: AppTheme.borderNavy),
          Expanded(
            child: vocabSets.isEmpty
                ? Center(
                    child: Text(l10n.noCollections, style: const TextStyle(color: AppTheme.textDim)),
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      // 1. Folders and their sets
                      ...folders.map((folder) {
                        final setsInFolder = provider.getSetsByFolder(folder.id);
                        if (setsInFolder.isEmpty) return const SizedBox.shrink();
                        
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
                              child: Text(
                                folder.title.toUpperCase(),
                                style: const TextStyle(color: AppTheme.electricGold, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                              ),
                            ),
                            ...setsInFolder.map((set) => _buildSetCard(set, l10n)),
                            const SizedBox(height: 16),
                          ],
                        );
                      }),
                      
                      if (provider.getSetsByFolder('uncategorized').isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
                          child: Text(
                            l10n.uncategorized,
                            style: const TextStyle(color: AppTheme.textDim, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                          ),
                        ),
                        ...provider.getSetsByFolder('uncategorized').map((set) => _buildSetCard(set, l10n)),
                        const SizedBox(height: 16),
                      ],
                    ],
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

  Widget _buildSetCard(VocabSetModel set, AppLocalizations l10n) {
    final isSelected = _selectedSetIds.contains(set.id);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Card(
        color: isSelected ? AppTheme.cardDark : AppTheme.surfaceNavy,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? AppTheme.electricGold.withValues(alpha: 0.5) : Colors.transparent,
            width: 1,
          ),
        ),
        child: CheckboxListTile(
          value: isSelected,
          onChanged: (_) => _toggleSet(set.id),
          title: Text(set.title, style: TextStyle(color: isSelected ? AppTheme.electricGold : AppTheme.textMain, fontWeight: FontWeight.bold)),
          subtitle: Text(l10n.wordsCountLabel(set.words.length), style: const TextStyle(color: AppTheme.textDim, fontSize: 13)),
          activeColor: AppTheme.electricGold,
          checkColor: AppTheme.darkNavy,
          secondary: Icon(LucideIcons.library, color: isSelected ? AppTheme.electricGold : AppTheme.textDim),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        ),
      ),
    );
  }
}
