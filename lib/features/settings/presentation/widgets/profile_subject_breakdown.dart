import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/core/widgets/nayza_progress_bar.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/vocab_set_model.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';

class ProfileSubjectBreakdown extends StatefulWidget {
  final VocabSetProvider provider;

  const ProfileSubjectBreakdown({super.key, required this.provider});

  @override
  State<ProfileSubjectBreakdown> createState() => _ProfileSubjectBreakdownState();
}

class _ProfileSubjectBreakdownState extends State<ProfileSubjectBreakdown> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final allSets = widget.provider.vocabSets;

    if (allSets.isEmpty) return const SizedBox.shrink();

    final displayedSets = _showAll ? allSets : allSets.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.subjectBreakdown,
              style: const TextStyle(
                color: AppTheme.textDim,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            if (allSets.length > 5)
              GestureDetector(
                onTap: () => setState(() => _showAll = !_showAll),
                child: Text(
                  _showAll ? l10n.showLess : l10n.showAllWithCount(allSets.length),
                  style: const TextStyle(
                    color: AppTheme.electricGold,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        ...displayedSets.map((set) => _buildSetItem(set, l10n)),
      ],
    );
  }

  Widget _buildSetItem(VocabSetModel set, AppLocalizations l10n) {
    final total = set.words.length;
    final learned = set.learnedWordsCount;
    final progress = total == 0 ? 0 : (learned / total * 100).toInt();

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceNavy,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.borderNavy, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.book, size: 14, color: AppTheme.electricGold),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  set.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppTheme.textMain,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.cardDark,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  l10n.wordCountLabel(total),
                  style: const TextStyle(color: AppTheme.textDim, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$learned / $total ${l10n.masteredWords.toLowerCase()}',
                style: const TextStyle(color: AppTheme.textDim, fontSize: 11),
              ),
              Text(
                '$progress%',
                style: TextStyle(
                  color: progress == 100 ? AppTheme.success : AppTheme.electricGold,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          NayzaProgressBar(
            current: learned,
            total: total == 0 ? 1 : total,
          ),
        ],
      ),
    );
  }
}
