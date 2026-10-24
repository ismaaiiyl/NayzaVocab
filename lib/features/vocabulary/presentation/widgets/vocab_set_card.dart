import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/core/widgets/nayza_progress_bar.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/vocab_set_model.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/dialogs/delete_set_dialog.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/dialogs/edit_set_title_dialog.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/quiz_provider.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';

class VocabSetCard extends StatelessWidget {
  final VocabSetModel set;

  const VocabSetCard({super.key, required this.set});

  @override
  Widget build(BuildContext context) {
    final progress = set.progressPercentage;
    final l10n = AppLocalizations.of(context)!;
    final isMastered = progress >= 100;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Dismissible(
        key: Key('set-dismiss-${set.id}'),
        direction: DismissDirection.endToStart,
        confirmDismiss: (_) => DeleteSetDialog.show(context, set),
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: AppTheme.error.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(LucideIcons.trash2, color: Colors.white),
        ),
        onDismissed: (_) => context.read<VocabSetProvider>().deleteVocabSet(set.id),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => context.pushNamed('set-details', pathParameters: {'id': set.id}),
            borderRadius: BorderRadius.circular(18),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppTheme.surfaceNavy,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppTheme.borderNavy, width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: isMastered
                              ? AppTheme.success.withValues(alpha: 0.15)
                              : AppTheme.cardDark,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isMastered
                                ? AppTheme.success.withValues(alpha: 0.5)
                                : AppTheme.borderNavy,
                          ),
                        ),
                        child: Icon(
                          isMastered ? LucideIcons.award : LucideIcons.bookOpen,
                          color: isMastered ? AppTheme.success : AppTheme.electricGold,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              set.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppTheme.textMain,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  l10n.wordCountLabel(set.words.length),
                                  style: const TextStyle(color: AppTheme.textDim, fontSize: 12),
                                ),
                                const SizedBox(width: 8),
                                const Text('•', style: TextStyle(color: AppTheme.textDim, fontSize: 10)),
                                const SizedBox(width: 8),
                                Text(
                                  DateFormat.MMMd().format(set.createdAt),
                                  style: const TextStyle(color: AppTheme.textDim, fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(LucideIcons.edit2, size: 18, color: AppTheme.textDim),
                        onPressed: () => EditSetTitleDialog.show(context, set),
                        constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                      ),
                      IconButton(
                        onPressed: () {
                          if (set.words.isEmpty) return;
                          context.read<QuizProvider>().prepareSession(set.words);
                          context.pushNamed('quiz-setup');
                        },
                        icon: const Icon(LucideIcons.playCircle, color: AppTheme.electricGold, size: 28),
                        constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${set.learnedWordsCount}/${set.words.length} ${l10n.masteredWords.toLowerCase()}',
                        style: const TextStyle(color: AppTheme.textDim, fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '${progress.toInt()}%',
                        style: TextStyle(
                          color: isMastered ? AppTheme.success : AppTheme.electricGold,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  NayzaProgressBar(
                    current: progress.toInt(),
                    total: 100,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
