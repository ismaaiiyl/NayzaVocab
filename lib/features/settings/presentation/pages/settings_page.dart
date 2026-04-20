import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/core/services/data_service.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/vocab_set_model.dart';
import 'package:nayza_vocab/features/settings/presentation/provider/settings_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings.toUpperCase()),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
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
            trailing: settings.getReminderTimeStr() != null 
              ? IconButton(
                  icon: const Icon(LucideIcons.bellOff, color: Colors.redAccent, size: 20),
                  onPressed: () {
                    context.read<SettingsProvider>().cancelReminder();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.cancelReminder)),
                    );
                  },
                )
              : null,
            onTap: () => _handleScheduleReminder(context, context.read<SettingsProvider>()),
          ),
          const SizedBox(height: 32),
          _buildSettingsHeader(l10n.language.toUpperCase()),
          const SizedBox(height: 12),
          _buildSettingsCard(
            context,
            title: l10n.language,
            subtitle: _getLanguageName(settings.languageCode, l10n),
            icon: LucideIcons.languages,
            onTap: () => _showLanguagePicker(context, settings, l10n),
          ),
          const SizedBox(height: 32),
          _buildSettingsHeader(l10n.communityAndUpdates),
          const SizedBox(height: 12),
          _buildSettingsCard(
            context,
            title: l10n.telegramChannel,
            subtitle: l10n.telegramSubtitle,
            icon: LucideIcons.send,
            onTap: () => _launchURL('https://t.me/nayza_vocab'),
          ),
          const SizedBox(height: 16),
          _buildSettingsCard(
            context,
            title: l10n.checkForUpdates,
            subtitle: l10n.checkForUpdatesSubtitle,
            icon: LucideIcons.refreshCw,
            onTap: () => _launchURL('https://t.me/nayza_vocab'),
          ),
          const SizedBox(height: 32),
          _buildSettingsHeader(l10n.dangerZone, color: Colors.redAccent),
          const SizedBox(height: 12),
          _buildSettingsCard(
            context,
            title: l10n.resetAllData,
            subtitle: l10n.resetAllDataConfirm,
            icon: LucideIcons.trash2,
            iconColor: Colors.redAccent,
            onTap: () => _handleResetAllData(context),
          ),
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

  Widget _buildSettingsHeader(String title, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          color: (color ?? AppTheme.electricGold).withValues(alpha: 0.8),
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
    Color? iconColor,
    Widget? trailing,
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
                color: (iconColor ?? AppTheme.electricGold).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor ?? AppTheme.electricGold, size: 24),
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
            if (trailing != null) ...[
              const SizedBox(width: 8),
              trailing,
            ],
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
      final data = await DataService.importData(importedSuffix: l10n.importedSuffix);
      if (data.isEmpty) return;

      final List<VocabSetModel> sets = data['sets'] as List<VocabSetModel>;
      final List<dynamic> folders = data['folders'] as List<dynamic>;

      if (!context.mounted) return;
      await context.read<VocabSetProvider>().importData(sets, folders);
      
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.importSuccess(sets.length))),
      );
    } catch (e) {
      if (!context.mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.importError(e.toString())),
          backgroundColor: Colors.redAccent.withValues(alpha: 0.8),
        ),
      );
    }
  }

  Future<void> _handleResetAllData(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceNavy,
        title: Text(l10n.resetAllData, style: const TextStyle(color: Colors.redAccent)),
        content: Text(l10n.resetAllDataConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel, style: const TextStyle(color: AppTheme.textDim)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.resetAllData),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (!context.mounted) return;
      await context.read<VocabSetProvider>().clearAllData();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All data cleared!')),
      );
    }
  }

  String _getLanguageName(String code, AppLocalizations l10n) {
    switch (code) {
      case 'uz': return '${l10n.uzbek} 🇺🇿';
      case 'ru': return '${l10n.russian} 🇷🇺';
      case 'en': return '${l10n.english} 🇬🇧';
      case 'ar': return '${l10n.arabicLang} 🇸🇦';
      case 'de': return '${l10n.germanLang} 🇩🇪';
      case 'ko': return '${l10n.koreanLang} 🇰🇷';
      default: return code;
    }
  }

  void _showLanguagePicker(BuildContext context, SettingsProvider settings, AppLocalizations l10n) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.darkNavy,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              // Sexy Handle
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
              _buildLanguageOption(context, settings, 'uz', '${l10n.uzbek} 🇺🇿'),
              _buildLanguageOption(context, settings, 'ru', '${l10n.russian} 🇷🇺'),
              _buildLanguageOption(context, settings, 'en', '${l10n.english} 🇬🇧'),
              _buildLanguageOption(context, settings, 'ar', '${l10n.arabicLang} 🇸🇦'),
              _buildLanguageOption(context, settings, 'de', '${l10n.germanLang} 🇩🇪'),
              _buildLanguageOption(context, settings, 'ko', '${l10n.koreanLang} 🇰🇷'),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(BuildContext context, SettingsProvider settings, String code, String label) {
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
        )
      ),
      trailing: isSelected 
          ? const Icon(LucideIcons.check, color: AppTheme.electricGold, size: 20) 
          : null,
    );
  }
}
