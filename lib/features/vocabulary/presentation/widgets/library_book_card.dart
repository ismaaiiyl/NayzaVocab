import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';

class LibraryBookCard extends StatelessWidget {
  final Map<String, dynamic> book;

  const LibraryBookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => context.pushNamed(
          'book-details',
          pathParameters: {'id': book['id'].toString()},
        ),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Hero(
                tag: 'book-cover-${book['id']}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    (book['cover_url'] as String?) ?? '',
                    width: 80,
                    height: 110,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 80,
                      height: 110,
                      color: AppTheme.surfaceNavy,
                      child: const Icon(LucideIcons.book, color: AppTheme.textDim),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.electricGold.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            (book['target_lang'] as String? ?? '').toUpperCase(),
                            style: const TextStyle(
                              color: AppTheme.electricGold,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (book['category'] != null && (book['category'] as String).isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.borderNavy,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              (book['category'] as String).toUpperCase(),
                              style: const TextStyle(
                                color: AppTheme.textDim,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      (book['title'] as String?) ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.textMain,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.setsCountLabel((book['unitsCount'] as int?) ?? 0),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppTheme.textDim, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const Icon(LucideIcons.chevronRight, color: AppTheme.textDim),
            ],
          ),
        ),
      ),
    );
  }
}
