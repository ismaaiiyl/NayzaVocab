import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/library_provider.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';

class LibraryUnitItem extends StatelessWidget {
  final Map<String, dynamic> unit;
  final VoidCallback onDownload;

  const LibraryUnitItem({
    super.key,
    required this.unit,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<LibraryProvider, VocabSetProvider>(
      builder: (context, libraryProvider, vocabProvider, child) {
        final l10n = AppLocalizations.of(context)!;
        final unitId = unit['id'].toString();
        final isDownloading = libraryProvider.isUnitDownloading(unitId);
        final isInstalled = vocabProvider.vocabSets.any((s) => s.title == unit['title']);

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: isInstalled ? 0 : 2,
          color: isInstalled
              ? AppTheme.surfaceNavy.withValues(alpha: 0.3)
              : AppTheme.surfaceNavy,
          child: ListTile(
            leading: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isInstalled
                    ? AppTheme.success.withValues(alpha: 0.1)
                    : AppTheme.electricGold.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isInstalled
                    ? const Icon(LucideIcons.check, color: AppTheme.success, size: 16)
                    : Text(
                        '${unit['index']}',
                        style: const TextStyle(
                          color: AppTheme.electricGold,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            title: Text(
              (unit['title'] as String?) ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isInstalled ? AppTheme.textDim : AppTheme.textMain,
                fontWeight: isInstalled ? FontWeight.normal : FontWeight.w600,
              ),
            ),
            subtitle: Text(
              l10n.wordCountLabel_short((unit['wordCount'] as Object?) ?? 0),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isInstalled
                    ? AppTheme.textDim.withValues(alpha: 0.5)
                    : AppTheme.textDim,
                fontSize: 12,
              ),
            ),
            trailing: isDownloading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.electricGold),
                  )
                : isInstalled
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppTheme.success.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          l10n.installed,
                          style: const TextStyle(
                            color: AppTheme.success,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : IconButton(
                        icon: const Icon(LucideIcons.download, color: AppTheme.electricGold, size: 20),
                        constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                        onPressed: onDownload,
                      ),
          ),
        );
      },
    );
  }
}
