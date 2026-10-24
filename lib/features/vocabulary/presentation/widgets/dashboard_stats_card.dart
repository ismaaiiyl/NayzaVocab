import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/core/widgets/nayza_progress_bar.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/vocab_set_model.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/word_model.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';

class DashboardStatsCard extends StatelessWidget {
  final VocabSetProvider provider;

  const DashboardStatsCard({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final totalSets = provider.vocabSets.length;
    final totalWords = provider.vocabSets.fold<int>(
      0,
      (int sum, VocabSetModel set) => sum + set.words.length,
    );
    final learnedWords = provider.vocabSets.fold<int>(
      0,
      (int sum, VocabSetModel set) =>
          sum + set.words.where((WordModel w) => w.isLearned).length,
    );
    final overallProgress = totalWords > 0
        ? ((learnedWords / totalWords) * 100).toInt()
        : 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceNavy,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.borderNavy),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.homeTitle,
                style: const TextStyle(
                  color: AppTheme.electricGold,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  letterSpacing: 1.2,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.electricGold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.electricGold.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  '$overallProgress%',
                  style: const TextStyle(
                    color: AppTheme.electricGold,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          NayzaProgressBar(current: learnedWords, total: totalWords),
          const SizedBox(height: 16),
          Row(
            children: [
              _StatItem(
                icon: LucideIcons.layers,
                value: '$totalSets',
                label: l10n.collections,
                color: AppTheme.electricGold,
              ),
              const SizedBox(width: 16),
              _StatItem(
                icon: LucideIcons.bookOpen,
                value: '$totalWords',
                label: l10n.wordsCountLabel(totalWords),
                color: AppTheme.info,
              ),
              const SizedBox(width: 16),
              _StatItem(
                icon: LucideIcons.checkCircle2,
                value: '$learnedWords',
                label: l10n.installed,
                color: AppTheme.success,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
