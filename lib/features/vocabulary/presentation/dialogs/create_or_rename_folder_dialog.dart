import 'package:flutter/material.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';

class CreateOrRenameFolderDialog extends StatefulWidget {
  final String? folderId;
  final String? initialTitle;

  const CreateOrRenameFolderDialog({
    super.key,
    this.folderId,
    this.initialTitle,
  });

  static Future<void> show(
    BuildContext context, {
    String? folderId,
    String? initialTitle,
  }) {
    return showDialog<void>(
      context: context,
      builder: (ctx) => CreateOrRenameFolderDialog(
        folderId: folderId,
        initialTitle: initialTitle,
      ),
    );
  }

  @override
  State<CreateOrRenameFolderDialog> createState() => _CreateOrRenameFolderDialogState();
}

class _CreateOrRenameFolderDialogState extends State<CreateOrRenameFolderDialog> {
  late final TextEditingController _controller;

  bool get _isEditing => widget.folderId != null;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialTitle ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final title = _controller.text.trim();
    if (title.isEmpty) return;

    final provider = context.read<VocabSetProvider>();
    if (_isEditing) {
      provider.renameFolder(widget.folderId!, title);
    } else {
      provider.createFolder(title);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dialogTitle = _isEditing ? l10n.rename : l10n.createFolder;
    final actionButtonText = _isEditing ? l10n.save : l10n.create;

    return AlertDialog(
      backgroundColor: AppTheme.surfaceNavy,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        dialogTitle,
        style: const TextStyle(color: AppTheme.electricGold, fontWeight: FontWeight.bold),
      ),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _handleSubmit(),
        decoration: InputDecoration(hintText: l10n.enterFolderName),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel, style: const TextStyle(color: AppTheme.textDim)),
        ),
        ElevatedButton(
          onPressed: _handleSubmit,
          child: Text(actionButtonText),
        ),
      ],
    );
  }
}
