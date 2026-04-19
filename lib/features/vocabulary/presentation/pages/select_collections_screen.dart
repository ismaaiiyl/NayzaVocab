import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';

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

  @override
  Widget build(BuildContext context) {
    final vocabSetProvider = context.watch<VocabSetProvider>();
    final l10n = AppLocalizations.of(context)!;
    final allSets = vocabSetProvider.vocabSets;
    final allSetIds = allSets.map((set) => set.id).toList();
    final allSelected = _selectedSetIds.length == allSets.length && allSets.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.selectCollectionsTitle),
      ),
      body: allSets.isEmpty
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
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: allSets.length,
                    itemBuilder: (context, index) {
                      final set = allSets[index];
                      final isSelected = _selectedSetIds.contains(set.id);
                      final double titleFontSize = set.title.length > 25 ? 14 : 16;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Card(
                          color: isSelected ? AppTheme.cardDark : AppTheme.surfaceNavy,
                          child: ListTile(
                            onTap: () => _toggleSetSelection(set.id),
                            title: Text(
                              set.title, 
                              style: TextStyle(
                                color: isSelected ? AppTheme.electricGold : AppTheme.textMain, 
                                fontWeight: FontWeight.bold,
                                fontSize: titleFontSize,
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
                    },
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
                          final vocabSets = vocabSetProvider.vocabSets
                              .where((s) => _selectedSetIds.contains(s.id))
                              .toList();
                          
                          final allWords = vocabSets.expand((s) => s.words).toList();

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
