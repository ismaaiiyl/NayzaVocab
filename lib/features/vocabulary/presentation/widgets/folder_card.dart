import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/folder_model.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';

class FolderCard extends StatelessWidget {
  final FolderModel folder;
  final VoidCallback? onLongPress;

  const FolderCard({
    super.key,
    required this.folder,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final setsCount = context.select<VocabSetProvider, int>(
      (provider) => provider.getSetsByFolder(folder.id).length,
    );

    final isDifficult = folder.id == 'difficult';
    final iconColor = isDifficult ? AppTheme.error : AppTheme.electricGold;
    final iconData = isDifficult ? LucideIcons.flame : LucideIcons.folder;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (isDifficult) {
              context.pushNamed('difficult-words');
              return;
            }
            context.pushNamed('folder-details', pathParameters: {'id': folder.id});
          },
          onLongPress: isDifficult ? null : onLongPress,
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
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: iconColor.withValues(alpha: 0.3)),
                  ),
                  child: Icon(iconData, color: iconColor, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        folder.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppTheme.textMain,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.setsCountLabel(setsCount),
                        style: const TextStyle(color: AppTheme.textDim, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const Icon(LucideIcons.chevronRight, color: AppTheme.textDim, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
