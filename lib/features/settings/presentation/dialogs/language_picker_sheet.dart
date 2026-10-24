import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/features/settings/presentation/provider/settings_provider.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';

class LanguagePickerSheet extends StatelessWidget {
  final SettingsProvider settings;

  const LanguagePickerSheet({
    super.key,
    required this.settings,
  });

  static void show(BuildContext context, SettingsProvider settings) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.darkNavy,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) => LanguagePickerSheet(settings: settings),
    );
  }

  static String getLanguageName(String code, AppLocalizations l10n) {
    switch (code) {
      case 'uz':
        return '${l10n.uzbek} 🇺🇿';
      case 'ru':
        return '${l10n.russian} 🇷🇺';
      case 'en':
        return '${l10n.english} 🇬🇧';
      case 'ar':
        return '${l10n.arabicLang} 🇸🇦';
      case 'de':
        return '${l10n.germanLang} 🇩🇪';
      case 'ko':
        return '${l10n.koreanLang} 🇰🇷';
      default:
        return code;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.textDim.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.language.toUpperCase(),
            style: const TextStyle(
              color: AppTheme.electricGold,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          _buildOption(context, 'uz', '${l10n.uzbek} 🇺🇿'),
          _buildOption(context, 'ru', '${l10n.russian} 🇷🇺'),
          _buildOption(context, 'en', '${l10n.english} 🇬🇧'),
          _buildOption(context, 'ar', '${l10n.arabicLang} 🇸🇦'),
          _buildOption(context, 'de', '${l10n.germanLang} 🇩🇪'),
          _buildOption(context, 'ko', '${l10n.koreanLang} 🇰🇷'),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildOption(BuildContext context, String code, String label) {
    final isSelected = settings.languageCode == code;
    return ListTile(
      onTap: () {
        settings.setLanguage(code);
        Navigator.pop(context);
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 32),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppTheme.electricGold : AppTheme.textMain,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 18,
        ),
      ),
      trailing: isSelected
          ? const Icon(LucideIcons.check, color: AppTheme.electricGold, size: 20)
          : null,
    );
  }
}
