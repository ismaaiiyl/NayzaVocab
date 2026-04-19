import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/vocab_set_model.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/word_model.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/widgets/add_edit_word_dialog.dart';
import 'package:provider/provider.dart';
import 'package:nayza_vocab/core/widgets/nayza_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';
import 'package:nayza_vocab/core/services/data_service.dart';

class SetDetailsScreen extends StatefulWidget {
  final String setId;
  const SetDetailsScreen({super.key, required this.setId});

  @override
  State<SetDetailsScreen> createState() => _SetDetailsScreenState();
}

class _SetDetailsScreenState extends State<SetDetailsScreen> {
  void _showAddEditWordDialog({WordModel? existingWord, int? wordIndex}) async {
    final vocabSetProvider = Provider.of<VocabSetProvider>(context, listen: false);
    final set = vocabSetProvider.getSetById(widget.setId);
    if (set == null) return;

    final newWord = await showDialog<WordModel>(
      context: context,
      builder: (context) => AddEditWordDialog(word: existingWord, setId: widget.setId),
    );

    if (newWord != null) {
      // Senior fix: NEVER mutate Hive list directly — create new immutable list
      final updatedWords = List<WordModel>.from(set.words);
      if (wordIndex != null) {
        updatedWords[wordIndex] = newWord;
      } else {
        updatedWords.add(newWord);
      }
      await vocabSetProvider.updateVocabSet(set.copyWith(words: updatedWords));
    }
  }

  void _showEditTitleDialog(VocabSetModel set) {
    final l10n = AppLocalizations.of(context)!;
    final titleController = TextEditingController(text: set.title);
    
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceNavy,
        title: Text(l10n.editWord, style: const TextStyle(color: AppTheme.electricGold)),
        content: TextField(
          controller: titleController,
          decoration: InputDecoration(labelText: l10n.collectionNameLabel),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel, style: const TextStyle(color: AppTheme.textDim)),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.trim().isNotEmpty) {
                final provider = context.read<VocabSetProvider>();
                provider.updateVocabSet(set.copyWith(title: titleController.text.trim()));
                Navigator.pop(ctx);
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Consumer<VocabSetProvider>(
      builder: (context, provider, child) {
        final set = provider.getSetById(widget.setId);
        if (set == null) {
          return Scaffold(body: Center(child: Text(l10n.setNotFound)));
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(set.title.toUpperCase()),
            actions: [
              IconButton(
                icon: const Icon(LucideIcons.edit3, color: AppTheme.electricGold, size: 20),
                onPressed: () => _showEditTitleDialog(set),
              ),
              IconButton(
                icon: const Icon(LucideIcons.share2, color: AppTheme.electricGold, size: 20),
                onPressed: () async {
                  try {
                    final lang = set.words.isNotEmpty ? (set.words.first.langCode?.toUpperCase() ?? 'N/A') : 'N/A';
                    await DataService.shareSingleSet(
                      set,
                      subject: l10n.shareSubject(set.title),
                      message: l10n.shareMessage(set.title, lang, set.words.length.toString()),
                    );
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Ulashishda xatolik: $e')),
                      );
                    }
                  }
                },
              ),
              IconButton(
                icon: const Icon(LucideIcons.plus, color: AppTheme.electricGold),
                onPressed: () => _showAddEditWordDialog(),
              ),
              IconButton(
                icon: const Icon(LucideIcons.trash2, color: Colors.redAccent, size: 20),
                onPressed: () => _showDeleteSetDialog(context, provider, set, l10n),
              ),
            ],
          ),
          body: Column(
            children: [
              _buildStatsHeader(set, l10n),
              const Divider(color: AppTheme.borderNavy, height: 1),
              Expanded(
                child: set.words.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(LucideIcons.plusCircle, size: 48, color: AppTheme.textDim),
                            const SizedBox(height: 16),
                            Text(l10n.emptySetWarning, style: const TextStyle(color: AppTheme.textDim)),
                            TextButton(
                              onPressed: () => _showAddEditWordDialog(),
                              child: Text(l10n.addWord.toUpperCase(), style: const TextStyle(color: AppTheme.electricGold)),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: set.words.length,
                        itemBuilder: (context, index) {
                          final word = set.words[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Card(
                              child: ListTile(
                                onTap: () => _showAddEditWordDialog(existingWord: word, wordIndex: index),
                                leading: _buildWordStatusIndicator(word),
                                title: Text(word.original, style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(
                                  word.translation,
                                  style: const TextStyle(color: AppTheme.textDim, fontSize: 13),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(LucideIcons.trash2, size: 18, color: Colors.redAccent),
                                  onPressed: () async {
                                    // Senior fix: immutable removal — never mutate live Hive list
                                    final updatedWords = List<WordModel>.from(set.words);
                                    updatedWords.removeAt(index);
                                    await provider.updateVocabSet(set.copyWith(words: updatedWords));
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsHeader(VocabSetModel set, AppLocalizations l10n) {
    final double progress = set.progressPercentage / 100;

    return Container(
      padding: const EdgeInsets.all(24),
      color: AppTheme.surfaceNavy,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.wordsFoundCount(set.words.length),
                  style: const TextStyle(color: AppTheme.textDim, fontSize: 13),
                ),
                const SizedBox(height: 8),
                NayzaProgressBar(
                  current: (progress * 100).toInt(),
                  total: 100,
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Column(
            children: [
              Text(
                '${(progress * 100).toInt()}%',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.electricGold),
              ),
              Text(l10n.progressLabel.toUpperCase(), style: const TextStyle(fontSize: 10, color: AppTheme.textDim)),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteSetDialog(BuildContext context, VocabSetProvider provider, VocabSetModel set, AppLocalizations l10n) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceNavy,
        title: Text(l10n.deleteSetTitle, style: const TextStyle(color: Colors.redAccent)),
        content: Text(l10n.deleteSetConfirmation(set.title)),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(l10n.cancel, style: const TextStyle(color: AppTheme.textDim)),
          ),
          ElevatedButton(
            onPressed: () {
              provider.deleteVocabSet(set.id);
              context.pop();
              context.pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            child: Text(l10n.delete.toUpperCase()),
          ),
        ],
      ),
    );
  }

  Widget _buildWordStatusIndicator(WordModel word) {
    // Priority: Learned (Green) > Errors (Red) > Untested (Grey)
    if (word.isLearned) {
      return Container(
        width: 12, height: 12,
        decoration: const BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle),
      );
    }
    
    if (word.wrongAttempts > 0) {
      return Container(
        width: 12, height: 12,
        decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
      );
    }

    return Icon(LucideIcons.circle, size: 12, color: AppTheme.textDim.withValues(alpha: 0.3));
  }
}
