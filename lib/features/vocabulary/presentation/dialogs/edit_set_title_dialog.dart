import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/vocab_set_model.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';

class EditSetTitleDialog extends StatefulWidget {
  final VocabSetModel set;

  const EditSetTitleDialog({super.key, required this.set});

  static Future<void> show(BuildContext context, VocabSetModel set) {
    return showDialog<void>(
      context: context,
      builder: (ctx) => EditSetTitleDialog(set: set),
    );
  }

  @override
  State<EditSetTitleDialog> createState() => _EditSetTitleDialogState();
}

class _EditSetTitleDialogState extends State<EditSetTitleDialog> {
  late final TextEditingController _titleController;
  String? _selectedFolderId;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.set.title);
    _selectedFolderId = widget.set.folderId;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _save() {
    final newTitle = _titleController.text.trim();
    if (newTitle.isEmpty) return;

    context.read<VocabSetProvider>().updateVocabSet(
          widget.set.copyWith(
            title: newTitle,
            folderId: _selectedFolderId,
          ),
        );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      backgroundColor: AppTheme.surfaceNavy,
      title: Text(
        l10n.editSetTitle,
        style: const TextStyle(color: AppTheme.electricGold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            autofocus: true,
            decoration: InputDecoration(labelText: l10n.collectionNameLabel),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          Consumer<VocabSetProvider>(
            builder: (context, provider, child) {
              return DropdownButtonFormField<String?>(
                initialValue: _selectedFolderId,
                decoration: InputDecoration(
                  labelText: l10n.folderName,
                  prefixIcon: const Icon(LucideIcons.folder, size: 20, color: AppTheme.electricGold),
                ),
                dropdownColor: AppTheme.surfaceNavy,
                items: [
                  DropdownMenuItem(value: null, child: Text(l10n.noFolder)),
                  ...provider.folders.map((f) => DropdownMenuItem(value: f.id, child: Text(f.title))),
                ],
                onChanged: (v) => setState(() => _selectedFolderId = v),
              );
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel, style: const TextStyle(color: AppTheme.textDim)),
        ),
        ElevatedButton(
          onPressed: _save,
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
