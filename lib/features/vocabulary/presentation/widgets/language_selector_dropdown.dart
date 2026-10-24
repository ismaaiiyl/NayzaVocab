import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';

class LanguageSelectorDropdown extends StatelessWidget {
  final String selectedLangCode;
  final ValueChanged<String> onChanged;

  const LanguageSelectorDropdown({
    super.key,
    required this.selectedLangCode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DropdownButtonFormField<String>(
      initialValue: selectedLangCode,
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
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }
}
