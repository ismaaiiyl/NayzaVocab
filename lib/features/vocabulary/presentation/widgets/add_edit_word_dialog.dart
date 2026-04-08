import 'package:flutter/material.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/word_model.dart';
import 'package:uuid/uuid.dart';

class AddEditWordDialog extends StatefulWidget {
  final WordModel? word;

  const AddEditWordDialog({super.key, this.word});

  @override
  State<AddEditWordDialog> createState() => _AddEditWordDialogState();
}

class _AddEditWordDialogState extends State<AddEditWordDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _originalController;
  late final TextEditingController _translationController;

  @override
  void initState() {
    super.initState();
    _originalController = TextEditingController(text: widget.word?.original ?? '');
    _translationController = TextEditingController(text: widget.word?.translation ?? '');
  }

  @override
  void dispose() {
    _originalController.dispose();
    _translationController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newWord = WordModel(
        id: widget.word?.id ?? const Uuid().v4(),
        original: _originalController.text,
        translation: _translationController.text,
      );
      Navigator.of(context).pop(newWord);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.word == null ? 'Add Word' : 'Edit Word'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _originalController,
              decoration: const InputDecoration(labelText: 'Original Word'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter the original word.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _translationController,
              decoration: const InputDecoration(labelText: 'Translation'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter the translation.';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _save,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
