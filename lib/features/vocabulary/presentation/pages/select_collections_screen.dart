import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/core/widgets/nayza_widgets.dart';
import 'package:nayza_vocab/features/vocabulary/domain/entities/quiz_models.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/quiz_provider.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/widgets/select_collection_folder_section.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';

class SelectCollectionsScreen extends StatefulWidget {
  final QuizMode? initialMode;
  const SelectCollectionsScreen({super.key, this.initialMode});

  @override
  State<SelectCollectionsScreen> createState() =>
      _SelectCollectionsScreenState();
}

class _SelectCollectionsScreenState extends State<SelectCollectionsScreen> {
  final Set<String> _selectedSetIds = {};

  void _toggleSetSelection(String setId) {
    setState(() {
      if (_selectedSetIds.contains(setId)) {
        _selectedSetIds.remove(setId);
      } else {
        _selectedSetIds.add(setId);
      }
    });
  }

  void _toggleSelectAll(bool selectAll, List<String> allSetIds) {
    setState(() {
      if (selectAll) {
        _selectedSetIds.addAll(allSetIds);
      } else {
        _selectedSetIds.clear();
      }
    });
  }

  void _handleStartTraining(
    BuildContext context,
    VocabSetProvider vocabSetProvider,
    AppLocalizations l10n,
  ) {
    final allAvailableSets = [
      ...vocabSetProvider.vocabSets,
      ...vocabSetProvider.getDifficultVirtualSets()
    ];

    final selectedSets =
        allAvailableSets.where((s) => _selectedSetIds.contains(s.id)).toList();
    final allWords = selectedSets.expand((s) => s.words).toList();
    final uniqueWords = {for (var w in allWords) w.id: w}.values.toList();

    if (uniqueWords.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.emptySelectionWarning)),
      );
      return;
    }

    context.read<QuizProvider>().prepareSession(uniqueWords);

    if (widget.initialMode == QuizMode.matching) {
      context.pushReplacementNamed('matching-game');
    } else {
      context.pushNamed('quiz-setup');
    }
  }

  @override
  Widget build(BuildContext context) {
    final vocabSetProvider = context.watch<VocabSetProvider>();
    final l10n = AppLocalizations.of(context)!;

    final difficultSets = vocabSetProvider.getDifficultVirtualSets();
    final uncategorizedSets = vocabSetProvider.getSetsByFolder(null);
    final userFolders = vocabSetProvider.folders;

    final allSetIds = [
      ...vocabSetProvider.vocabSets.map((s) => s.id),
      ...difficultSets.map((s) => s.id)
    ];
    final allSelected =
        _selectedSetIds.length == allSetIds.length && allSetIds.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.selectCollectionsTitle)),
      body: allSetIds.isEmpty
          ? Center(
              child: Text(
                l10n.emptyCollectionsWarning,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppTheme.textDim),
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
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
                        onChanged: (value) =>
                            _toggleSelectAll(value ?? false, allSetIds),
                        activeColor: AppTheme.electricGold,
                        checkColor: AppTheme.darkNavy,
                      ),
                    ],
                  ),
                ),
                const Divider(color: AppTheme.borderNavy),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    children: [
                      SelectCollectionFolderSection(
                        folderId: 'difficult',
                        title: l10n.difficultCollectionsHeader,
                        sets: difficultSets,
                        selectedSetIds: _selectedSetIds,
                        onToggleSet: _toggleSetSelection,
                      ),
                      SelectCollectionFolderSection(
                        folderId: 'uncategorized',
                        title: l10n.noFolder,
                        sets: uncategorizedSets,
                        selectedSetIds: _selectedSetIds,
                        onToggleSet: _toggleSetSelection,
                      ),
                      ...userFolders.map(
                        (folder) => SelectCollectionFolderSection(
                          folderId: folder.id,
                          title: folder.title,
                          sets: vocabSetProvider.getSetsByFolder(folder.id),
                          selectedSetIds: _selectedSetIds,
                          onToggleSet: _toggleSetSelection,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_selectedSetIds.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Hero(
                      tag: 'start-training-btn',
                      child: NayzaButton(
                        text: l10n.startTest,
                        icon: LucideIcons.play,
                        onPressed: () => _handleStartTraining(
                          context,
                          vocabSetProvider,
                          l10n,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
