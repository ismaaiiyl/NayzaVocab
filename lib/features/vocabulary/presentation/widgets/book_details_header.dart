import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';

class BookDetailsHeader extends StatelessWidget {
  final Map<String, dynamic> book;
  final int unitsCount;
  final VoidCallback onDownloadAll;

  const BookDetailsHeader({
    super.key,
    required this.book,
    required this.unitsCount,
    required this.onDownloadAll,
  });

  Widget _buildInfoBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceNavy.withValues(alpha: 0.5),
        border: const Border(bottom: BorderSide(color: AppTheme.borderNavy)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: 'book-cover-${book['id']}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                (book['cover_url'] as String?) ?? '',
                width: 100,
                height: 140,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 100,
                  height: 140,
                  color: AppTheme.darkNavy,
                  child: const Icon(LucideIcons.book, color: AppTheme.textDim, size: 40),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (book['title'] as String?) ?? '',
                  style: const TextStyle(
                    color: AppTheme.textMain,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildInfoBadge(
                      book['target_lang'].toString().toUpperCase(),
                      AppTheme.electricGold,
                    ),
                    const SizedBox(width: 8),
                    _buildInfoBadge('$unitsCount UNITS', AppTheme.textDim),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  (book['description'] as String?) ?? '',
                  style: const TextStyle(color: AppTheme.textDim, fontSize: 14, height: 1.4),
                ),
                const SizedBox(height: 16),
                if (unitsCount > 0)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onDownloadAll,
                      icon: const Icon(LucideIcons.downloadCloud, size: 18),
                      label: Text(l10n.downloadAll),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.electricGold.withValues(alpha: 0.1),
                        foregroundColor: AppTheme.electricGold,
                        side: const BorderSide(color: AppTheme.electricGold),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
