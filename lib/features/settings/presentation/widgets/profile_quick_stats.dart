import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';

class ProfileQuickStats extends StatelessWidget {
  final int totalWords;
  final int masteredWords;
  final int foldersCount;
  final int setsCount;

  const ProfileQuickStats({
    super.key,
    required this.totalWords,
    required this.masteredWords,
    required this.foldersCount,
    required this.setsCount,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final percentage = totalWords == 0 ? 0 : (masteredWords / totalWords * 100).toInt();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildCard(
                title: l10n.all,
                value: '$totalWords',
                subtitle: l10n.wordsCountLabel(totalWords),
                icon: LucideIcons.bookOpen,
                color: AppTheme.electricGold,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCard(
                title: l10n.masteredWords,
                value: '$masteredWords',
                subtitle: l10n.masteredPercentage(percentage),
                icon: LucideIcons.award,
                color: AppTheme.success,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildCard(
                title: l10n.folders,
                value: '$foldersCount',
                subtitle: l10n.setsCountLabel(foldersCount),
                icon: LucideIcons.folder,
                color: AppTheme.info,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCard(
                title: l10n.collections,
                value: '$setsCount',
                subtitle: l10n.setsCountLabel(setsCount),
                icon: LucideIcons.layers,
                color: AppTheme.warning,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceNavy,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderNavy, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppTheme.textDim, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
