import 'package:flutter/material.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/core/widgets/nayza_widgets.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/word_model.dart';
import 'package:uuid/uuid.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AddEditWordDialog extends StatefulWidget {
  final WordModel? word;
  final String? setId;

  const AddEditWordDialog({super.key, this.word, this.setId});

  @override
  State<AddEditWordDialog> createState() => _AddEditWordDialogState();
}

class _AddEditWordDialogState extends State<AddEditWordDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _originalController;
  late final TextEditingController _translationController;
  String _selectedLangCode = 'en-US';

  @override
  void initState() {
    super.initState();
    _originalController = TextEditingController(text: widget.word?.original ?? '');
    _translationController = TextEditingController(text: widget.word?.translation ?? '');
    _selectedLangCode = widget.word?.langCode ?? 'en-US';
  }

  @override
  void dispose() {
    _originalController.dispose();
    _translationController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final existingSetId = widget.word?.setId;
    final resolvedSetId = (existingSetId != null && existingSetId.isNotEmpty)
        ? existingSetId
        : (widget.setId ?? '');

    final newWord = WordModel(
      id: widget.word?.id ?? const Uuid().v4(),
      original: _originalController.text,
      translation: _translationController.text,
      langCode: _selectedLangCode,
      isDifficult: widget.word?.isDifficult ?? false,
      wrongAttempts: widget.word?.wrongAttempts ?? 0,
      correctAnswersCount: widget.word?.correctAnswersCount ?? 0,
      lastTestedAt: widget.word?.lastTestedAt,
      setId: resolvedSetId,
    );
    Navigator.of(context).pop(newWord);
  }
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      backgroundColor: AppTheme.surfaceNavy,
      title: Text(
        widget.word == null ? l10n.addWord : l10n.editWord,
        style: const TextStyle(color: AppTheme.electricGold),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NayzaTextField(
              controller: _originalController,
              label: l10n.wordPlaceholder,
              hint: 'Word',
              validator: (v) => v!.isEmpty ? l10n.atLeastOneWordWarning : null,
            ),
            const SizedBox(height: 16),
            NayzaTextField(
              controller: _translationController,
              label: l10n.translationPlaceholder,
              hint: 'Translation',
              validator: (v) => v!.isEmpty ? l10n.atLeastOneWordWarning : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedLangCode,
              decoration: InputDecoration(
                labelText: l10n.languageLabel,
                prefixIcon: const Icon(LucideIcons.languages, size: 20, color: Color(0xFFFFD700)),
              ),
              dropdownColor: AppTheme.surfaceNavy,
              items: [
                DropdownMenuItem(value: 'en-US', child: Text(l10n.englishLang)),
                DropdownMenuItem(value: 'ar-SA', child: Text(l10n.arabicLang)),
                DropdownMenuItem(value: 'de-DE', child: Text(l10n.germanLang)),
                DropdownMenuItem(value: 'ko-KR', child: Text(l10n.koreanLang)),
                DropdownMenuItem(value: 'ru-RU', child: Text(l10n.russianLang)),
                DropdownMenuItem(value: 'uz-UZ', child: Text(l10n.uzbekLang)),
              ],
              onChanged: (v) => setState(() => _selectedLangCode = v!),
            ),
          ],
        ),
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
