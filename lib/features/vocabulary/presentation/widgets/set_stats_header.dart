import 'package:flutter/material.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/core/widgets/nayza_progress_bar.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/vocab_set_model.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';

class SetStatsHeader extends StatelessWidget {
  final VocabSetModel set;

  const SetStatsHeader({super.key, required this.set});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.electricGold,
                ),
              ),
              Text(
                l10n.progressLabel.toUpperCase(),
                style: const TextStyle(fontSize: 10, color: AppTheme.textDim),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
