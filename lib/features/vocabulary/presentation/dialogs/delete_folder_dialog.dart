import 'package:flutter/material.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/folder_model.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';

class DeleteFolderDialog extends StatelessWidget {
  final FolderModel folder;

  const DeleteFolderDialog({
    super.key,
    required this.folder,
  });

  static Future<void> show(BuildContext context, FolderModel folder) {
    return showDialog<void>(
      context: context,
      builder: (ctx) => DeleteFolderDialog(folder: folder),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      backgroundColor: AppTheme.surfaceNavy,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        l10n.dangerZone,
        style: const TextStyle(color: AppTheme.error, fontWeight: FontWeight.bold),
      ),
      content: Text(
        l10n.deleteFolderConfirm,
        style: const TextStyle(color: AppTheme.textMain),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel, style: const TextStyle(color: AppTheme.textDim)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
          onPressed: () {
            context.read<VocabSetProvider>().deleteFolder(folder.id);
            Navigator.pop(context);
          },
          child: Text(l10n.delete),
        ),
      ],
    );
  }
}
