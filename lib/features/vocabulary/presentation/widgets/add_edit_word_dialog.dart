import 'package:flutter/material.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/core/widgets/nayza_widgets.dart';
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
      final newWord = WordModel(
        id: widget.word?.id ?? const Uuid().v4(),
        original: _originalController.text,
        translation: _translationController.text,
        isLearned: widget.word?.isLearned ?? false,
        wrongAttempts: widget.word?.wrongAttempts ?? 0,
      );
      Navigator.of(context).pop(newWord);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.surfaceNavy,
      title: Text(
        widget.word == null ? 'SO\'Z QO\'SHISH' : 'SO\'ZNI TAHRIRLASH',
        style: const TextStyle(color: AppTheme.electricGold),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NayzaTextField(
              controller: _originalController,
              label: 'Asl so\'z',
              hint: 'Word',
              validator: (v) => v!.isEmpty ? 'So\'z kiriting' : null,
            ),
            const SizedBox(height: 16),
            NayzaTextField(
              controller: _translationController,
              label: 'Tarjimasi',
              hint: 'Translation',
              validator: (v) => v!.isEmpty ? 'Tarjima kiriting' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('BEKOR QILISH', style: TextStyle(color: AppTheme.textDim)),
        ),
        ElevatedButton(
          onPressed: _save,
          child: const Text('SAQLASH'),
        ),
      ],
    );
  }
}
