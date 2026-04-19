import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/core/services/data_service.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';

import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:nayza_vocab/features/settings/presentation/provider/settings_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings.toUpperCase()),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSettingsHeader(l10n.dataManagement),
          const SizedBox(height: 12),
          _buildSettingsCard(
            context,
            title: l10n.export,
            subtitle: l10n.exportSubtitle,
            icon: LucideIcons.download,
            onTap: () => context.pushNamed('export-selection'),
          ),
          const SizedBox(height: 16),
          _buildSettingsCard(
            context,
            title: l10n.import,
            subtitle: l10n.importSubtitle,
            icon: LucideIcons.upload,
            onTap: () => _handleImport(context),
          ),
          const SizedBox(height: 32),
          _buildSettingsHeader(l10n.notifications),
          const SizedBox(height: 12),
          _buildSettingsCard(
            context,
            title: l10n.dailyReminder,
            subtitle: settings.getReminderTimeStr() != null 
                ? l10n.reminderSubtitle(settings.getReminderTimeStr()!) 
                : l10n.reminderDefault,
            icon: LucideIcons.bell,
            onTap: () => _handleScheduleReminder(context, context.read<SettingsProvider>()),
          ),
          const SizedBox(height: 32),
          _buildSettingsHeader(l10n.language.toUpperCase()),
          const SizedBox(height: 12),
          _buildLanguageSelector(context, settings, l10n),
          const SizedBox(height: 48),
          _buildSettingsHeader(l10n.appInfo),
          const SizedBox(height: 12),
          Center(
            child: Text(
              l10n.appVersion,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textDim,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          color: AppTheme.electricGold.withValues(alpha: 0.8),
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.surfaceNavy.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.borderNavy,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.electricGold.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppTheme.electricGold, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textMain,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textDim,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              LucideIcons.chevronRight,
              color: AppTheme.textDim,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleScheduleReminder(BuildContext context, SettingsProvider provider) async {
    final l10n = AppLocalizations.of(context)!;
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
      builder: (context, child) {
        return Theme(
          data: AppTheme.darkTheme.copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.electricGold,
              onPrimary: AppTheme.surfaceNavy,
              surface: AppTheme.surfaceNavy,
              onSurface: AppTheme.textMain,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      if (!context.mounted) return;
      
      await provider.saveReminderTime(picked.hour, picked.minute);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.reminderSetSuccess(picked.format(context))),
          backgroundColor: Colors.greenAccent.withValues(alpha: 0.8),
        ),
      );
    }
  }

  Future<void> _handleImport(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context)!;
    try {
      final importedSets = await DataService.importSets(importedSuffix: l10n.importedSuffix);
      if (importedSets.isEmpty) return;

      if (!context.mounted) return;
      final provider = context.read<VocabSetProvider>();
      for (var set in importedSets) {
        await provider.addSet(set);
      }
      
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.importSuccess(importedSets.length))),
      );
    } catch (e) {
      if (!context.mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.importError(e.toString()))),
      );
    }
  }

  Widget _buildLanguageSelector(BuildContext context, SettingsProvider settings, AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceNavy.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderNavy),
      ),
      child: Column(
        children: [
          _buildLanguageOption(context, settings, 'uz', l10n.uzbek, LucideIcons.languages),
          const Divider(color: AppTheme.borderNavy, height: 1),
          _buildLanguageOption(context, settings, 'ru', l10n.russian, LucideIcons.languages),
          const Divider(color: AppTheme.borderNavy, height: 1),
          _buildLanguageOption(context, settings, 'en', l10n.english, LucideIcons.languages),
          const Divider(color: AppTheme.borderNavy, height: 1),
          _buildLanguageOption(context, settings, 'ar', l10n.arabicLang, LucideIcons.languages),
          const Divider(color: AppTheme.borderNavy, height: 1),
          _buildLanguageOption(context, settings, 'de', l10n.germanLang, LucideIcons.languages),
          const Divider(color: AppTheme.borderNavy, height: 1),
          _buildLanguageOption(context, settings, 'ko', l10n.koreanLang, LucideIcons.languages),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(BuildContext context, SettingsProvider settings, String code, String label, IconData icon) {
    final isSelected = settings.languageCode == code;
    return ListTile(
      onTap: () => settings.setLanguage(code),
      leading: Icon(icon, color: isSelected ? AppTheme.electricGold : AppTheme.textDim, size: 20),
      title: Text(label, style: TextStyle(color: isSelected ? AppTheme.electricGold : AppTheme.textMain, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      trailing: isSelected ? const Icon(LucideIcons.check, color: AppTheme.electricGold, size: 18) : null,
    );
  }
}
