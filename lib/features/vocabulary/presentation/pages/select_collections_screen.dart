import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';

import 'package:nayza_vocab/features/vocabulary/data/models/folder_model.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/vocab_set_model.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/quiz_provider.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/quiz_screen.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/core/widgets/nayza_widgets.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SelectCollectionsScreen extends StatefulWidget {
  final QuizMode? initialMode;
  const SelectCollectionsScreen({super.key, this.initialMode});

  @override
  State<SelectCollectionsScreen> createState() => _SelectCollectionsScreenState();
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

  Widget _buildFolderSection(BuildContext context, String folderId, String title, List<VocabSetModel> sets) {
    if (sets.isEmpty) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Icon(
                folderId == 'difficult' ? LucideIcons.flame : LucideIcons.folder, 
                size: 18, 
                color: folderId == 'difficult' ? Colors.redAccent : AppTheme.electricGold
              ),
              const SizedBox(width: 8),
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  color: folderId == 'difficult' ? Colors.redAccent : AppTheme.textDim,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
        ),
        ...sets.map((set) {
          final isSelected = _selectedSetIds.contains(set.id);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Card(
              color: isSelected ? AppTheme.cardDark : AppTheme.surfaceNavy,
              child: ListTile(
                onTap: () => _toggleSetSelection(set.id),
                title: Text(
                  set.title,
                  style: TextStyle(
                    color: isSelected ? AppTheme.electricGold : AppTheme.textMain,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(l10n.wordCountLabel(set.words.length), style: const TextStyle(color: AppTheme.textDim, fontSize: 12)),
                trailing: Checkbox(
                  value: isSelected,
                  onChanged: (value) => _toggleSetSelection(set.id),
                  activeColor: AppTheme.electricGold,
                  checkColor: AppTheme.darkNavy,
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final vocabSetProvider = context.watch<VocabSetProvider>();
    final l10n = AppLocalizations.of(context)!;
    
    // Grouping
    final difficultSets = vocabSetProvider.getDifficultVirtualSets();
    final uncategorizedSets = vocabSetProvider.getSetsByFolder(null);
    final userFolders = vocabSetProvider.folders;

    final allSetsCount = vocabSetProvider.vocabSets.length + difficultSets.length;
    final allSetIds = [
      ...vocabSetProvider.vocabSets.map((s) => s.id),
      ...difficultSets.map((s) => s.id)
    ];
    final allSelected = _selectedSetIds.length == allSetIds.length && allSetIds.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.selectCollectionsTitle),
      ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Text(
                        allSelected ? l10n.deselectAll : l10n.selectAll,
                        style: const TextStyle(color: AppTheme.textDim, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Checkbox(
                        value: allSelected,
                        onChanged: (value) => _toggleSelectAll(value!, allSetIds),
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
                      _buildFolderSection(context, 'difficult', l10n.difficultCollectionsHeader, difficultSets),
                      _buildFolderSection(context, 'uncategorized', l10n.noFolder, uncategorizedSets),
                      ...userFolders.map((folder) => _buildFolderSection(
                        context, 
                        folder.id, 
                        folder.title, 
                        vocabSetProvider.getSetsByFolder(folder.id)
                      )),
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
                        onPressed: () {
                          // Merge real sets and difficult virtual sets for selection
                          final allAvailableSets = [
                            ...vocabSetProvider.vocabSets,
                            ...vocabSetProvider.getDifficultVirtualSets()
                          ];

                          final selectedSets = allAvailableSets
                              .where((s) => _selectedSetIds.contains(s.id))
                              .toList();
                          
                          final allWords = selectedSets.expand((s) => s.words).toList();

                          if (allWords.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.emptySelectionWarning)),
                            );
                            return;
                          }
                          
                          context.read<QuizProvider>().prepareSession(allWords);

                          if (widget.initialMode == QuizMode.matching) {
                            context.pushReplacementNamed('matching-game');
                          } else {
                            context.pushNamed('quiz-setup');
                          }
                        },
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
