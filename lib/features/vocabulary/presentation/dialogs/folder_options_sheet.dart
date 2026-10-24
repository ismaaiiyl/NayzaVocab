import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/folder_model.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';

class FolderOptionsSheet extends StatelessWidget {
  final FolderModel folder;
  final VoidCallback onRename;
  final VoidCallback onDelete;

  const FolderOptionsSheet({
    super.key,
    required this.folder,
    required this.onRename,
    required this.onDelete,
  });

  static void show({
    required BuildContext context,
    required FolderModel folder,
    required VoidCallback onRename,
    required VoidCallback onDelete,
  }) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppTheme.surfaceNavy,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => FolderOptionsSheet(
        folder: folder,
        onRename: () {
          Navigator.pop(ctx);
          onRename();
        },
        onDelete: () {
          Navigator.pop(ctx);
          onDelete();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: AppTheme.borderNavy,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        ListTile(
          leading: const Icon(LucideIcons.edit, color: AppTheme.electricGold),
          title: Text(l10n.rename, style: const TextStyle(color: AppTheme.textMain)),
          onTap: onRename,
        ),
        ListTile(
          leading: const Icon(LucideIcons.trash2, color: AppTheme.error),
          title: Text(
            l10n.delete,
            style: const TextStyle(color: AppTheme.error, fontWeight: FontWeight.bold),
          ),
          onTap: onDelete,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
