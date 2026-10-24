import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/services/data_service.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/vocab_set_model.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/word_model.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/dialogs/delete_set_dialog.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/dialogs/edit_set_title_dialog.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/widgets/add_edit_word_dialog.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/widgets/set_stats_header.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/widgets/set_word_tile.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';

class SetDetailsScreen extends StatefulWidget {
  final String setId;
  const SetDetailsScreen({super.key, required this.setId});

  @override
  State<SetDetailsScreen> createState() => _SetDetailsScreenState();
}

class _SetDetailsScreenState extends State<SetDetailsScreen> {
  Future<void> _showAddEditWordDialog({WordModel? existingWord, int? wordIndex}) async {
    final vocabSetProvider = Provider.of<VocabSetProvider>(context, listen: false);
    final set = vocabSetProvider.getSetById(widget.setId);
    if (set == null) return;

    final newWord = await showDialog<WordModel>(
      context: context,
      builder: (context) => AddEditWordDialog(word: existingWord, setId: widget.setId),
    );

    if (newWord == null) return;
    final updatedWords = List<WordModel>.from(set.words);
    if (wordIndex != null) {
      updatedWords[wordIndex] = newWord;
    } else {
      updatedWords.add(newWord);
    }
    await vocabSetProvider.updateVocabSet(set.copyWith(words: updatedWords));
  }

  Future<void> _handleShare(VocabSetModel set, AppLocalizations l10n) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final lang = set.words.isNotEmpty ? (set.words.first.langCode?.toUpperCase() ?? 'N/A') : 'N/A';
      await DataService.shareSingleSet(
        set,
        subject: l10n.shareSubject(set.title),
        message: l10n.shareMessage(set.title, lang, set.words.length.toString()),
      );
    } catch (e, stack) {
      debugPrint('Share error: $e\n$stack');
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.shareError(e.toString()))),
        );
      }
    }
  }

  Future<void> _handleDelete(BuildContext context, VocabSetModel set) async {
    final deleted = await DeleteSetDialog.show(context, set);
    if (deleted == true && context.mounted) {
      context.pop();
    }
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
                icon: const Icon(LucideIcons.plus, color: AppTheme.electricGold),
                onPressed: () => _showAddEditWordDialog(),
              ),
              PopupMenuButton<String>(
                icon: const Icon(LucideIcons.moreVertical, color: AppTheme.electricGold),
                color: AppTheme.surfaceNavy,
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      EditSetTitleDialog.show(context, set);
                    case 'share':
                      _handleShare(set, l10n);
                    case 'delete':
                      _handleDelete(context, set);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        const Icon(LucideIcons.edit3, color: AppTheme.electricGold, size: 20),
                        const SizedBox(width: 12),
                        Text(l10n.rename),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'share',
                    child: Row(
                      children: [
                        const Icon(LucideIcons.share2, color: AppTheme.electricGold, size: 20),
                        const SizedBox(width: 12),
                        Text(l10n.share),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        const Icon(LucideIcons.trash2, color: AppTheme.error, size: 20),
                        const SizedBox(width: 12),
                        Text(l10n.deleteSetTitle, style: const TextStyle(color: AppTheme.error)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: Column(
            children: [
              SetStatsHeader(set: set),
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
                              child: Text(
                                l10n.addWord.toUpperCase(),
                                style: const TextStyle(color: AppTheme.electricGold),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: set.words.length,
                        itemBuilder: (context, index) {
                          final word = set.words[index];
                          return SetWordTile(
                            word: word,
                            onTap: () => _showAddEditWordDialog(
                              existingWord: word,
                              wordIndex: index,
                            ),
                            onDelete: () async {
                              final updatedWords = List<WordModel>.from(set.words);
                              updatedWords.removeAt(index);
                              await provider.updateVocabSet(set.copyWith(words: updatedWords));
                            },
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
}
