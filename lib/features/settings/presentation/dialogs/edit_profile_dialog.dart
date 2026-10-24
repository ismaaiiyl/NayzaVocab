import 'package:flutter/material.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/core/widgets/nayza_button.dart';
import 'package:nayza_vocab/core/widgets/nayza_text_field.dart';
import 'package:nayza_vocab/features/settings/presentation/provider/settings_provider.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';

class EditProfileDialog extends StatefulWidget {
  final SettingsProvider settings;

  const EditProfileDialog({super.key, required this.settings});

  static Future<void> show(BuildContext context, SettingsProvider settings) {
    return showDialog(
      context: context,
      builder: (ctx) => EditProfileDialog(settings: settings),
    );
  }

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  late String _selectedTargetLang;

  static const List<String> _languages = [
    'English',
    'Russian',
    'German',
    'Korean',
    'Arabic',
    'Spanish',
    'French',
    'Turkish',
    'Chinese',
    'Japanese',
    'Uzbek',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.settings.userName);
    _ageController = TextEditingController(text: widget.settings.userAge.toString());
    _selectedTargetLang = _languages.contains(widget.settings.targetLanguage)
        ? widget.settings.targetLanguage
        : 'English';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final age = int.tryParse(_ageController.text.trim()) ?? 20;
    await widget.settings.updateProfile(
      name: _nameController.text,
      age: age,
      targetLanguage: _selectedTargetLang,
    );

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      backgroundColor: AppTheme.surfaceNavy,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppTheme.borderNavy),
      ),
      title: Text(
        l10n.editProfile,
        style: const TextStyle(color: AppTheme.electricGold, fontWeight: FontWeight.bold),
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              NayzaTextField(
                controller: _nameController,
                label: l10n.userName,
                hint: l10n.userNameHint,
                validator: (v) => v!.trim().isEmpty ? l10n.nameRequiredError : null,
              ),
              const SizedBox(height: 16),
              NayzaTextField(
                controller: _ageController,
                label: l10n.userAge,
                hint: '20',
                keyboardType: TextInputType.number,
                validator: (v) {
                  final n = int.tryParse(v!.trim());
                  if (n == null || n <= 0 || n > 120) return l10n.invalidAgeError;
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedTargetLang,
                decoration: InputDecoration(
                  labelText: l10n.targetLanguage,
                  filled: true,
                  fillColor: AppTheme.cardDark,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                dropdownColor: AppTheme.surfaceNavy,
                items: _languages.map((lang) {
                  return DropdownMenuItem(value: lang, child: Text(lang));
                }).toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _selectedTargetLang = v);
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel, style: const TextStyle(color: AppTheme.textDim)),
        ),
        NayzaButton(
          text: l10n.save,
          onPressed: _handleSave,
        ),
      ],
    );
  }
}
