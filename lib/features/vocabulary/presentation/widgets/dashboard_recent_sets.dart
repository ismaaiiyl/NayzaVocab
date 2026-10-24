import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/vocab_set_model.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';

class DashboardRecentSets extends StatelessWidget {
  final VocabSetProvider provider;

  const DashboardRecentSets({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final sets = provider.vocabSets;
    if (sets.isEmpty) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;
    final recentSets = sets.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.collections.toUpperCase(),
                style: const TextStyle(
                  color: AppTheme.textDim,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontSize: 13,
                ),
              ),
              Text(
                '${sets.length}',
                style: const TextStyle(
                  color: AppTheme.electricGold,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: recentSets.length,
            itemBuilder: (context, index) {
              final set = recentSets[index];
              return _RecentSetChip(set: set);
            },
          ),
        ),
      ],
    );
  }
}

class _RecentSetChip extends StatelessWidget {
  final VocabSetModel set;

  const _RecentSetChip({required this.set});

  @override
  Widget build(BuildContext context) {
    final progress = set.progressPercentage;

    return Container(
      width: 170,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Material(
        color: AppTheme.surfaceNavy,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.pushNamed('set-details', pathParameters: {'id': set.id}),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.borderNavy),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                    const Icon(LucideIcons.chevronRight, size: 16, color: AppTheme.textDim),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${set.words.length} words',
                      style: const TextStyle(color: AppTheme.textDim, fontSize: 12),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: progress == 100
                            ? AppTheme.success.withValues(alpha: 0.15)
                            : AppTheme.electricGold.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$progress%',
                        style: TextStyle(
                          color: progress == 100 ? AppTheme.success : AppTheme.electricGold,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
