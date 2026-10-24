import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/services/data_service.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/features/settings/presentation/dialogs/language_picker_sheet.dart';
import 'package:nayza_vocab/features/settings/presentation/dialogs/reset_confirm_dialog.dart';
import 'package:nayza_vocab/features/settings/presentation/provider/settings_provider.dart';
import 'package:nayza_vocab/features/settings/presentation/widgets/settings_card.dart';
import 'package:nayza_vocab/features/settings/presentation/widgets/settings_header.dart';
import 'package:nayza_vocab/features/settings/presentation/widgets/app_info_section.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/vocab_set_model.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings.toUpperCase()),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          SettingsHeader(title: l10n.dataManagement),
          const SizedBox(height: 12),
          SettingsCard(
            title: l10n.export,
            subtitle: l10n.exportSubtitle,
            icon: LucideIcons.download,
            onTap: () => context.pushNamed('export-selection'),
          ),
          const SizedBox(height: 16),
          SettingsCard(
            title: l10n.import,
            subtitle: l10n.importSubtitle,
            icon: LucideIcons.upload,
            onTap: () => _handleImport(context),
          ),
          const SizedBox(height: 32),
          SettingsHeader(title: l10n.notifications),
          const SizedBox(height: 12),
          SettingsCard(
            title: l10n.dailyReminder,
            subtitle: settings.getReminderTimeStr() != null
                ? l10n.reminderSubtitle(settings.getReminderTimeStr()!)
                : l10n.reminderDefault,
            icon: LucideIcons.bell,
            trailing: settings.getReminderTimeStr() != null
                ? IconButton(
                    icon: const Icon(LucideIcons.bellOff, color: AppTheme.error, size: 20),
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
          SettingsHeader(title: l10n.language.toUpperCase()),
          const SizedBox(height: 12),
          SettingsCard(
            title: l10n.language,
            subtitle: LanguagePickerSheet.getLanguageName(settings.languageCode, l10n),
            icon: LucideIcons.languages,
            onTap: () => LanguagePickerSheet.show(context, settings),
          ),
          const SizedBox(height: 32),
          SettingsHeader(title: l10n.communityAndUpdates),
          const SizedBox(height: 12),
          SettingsCard(
            title: l10n.telegramChannel,
            subtitle: l10n.telegramSubtitle,
            icon: LucideIcons.send,
            onTap: () => _launchURL('https://t.me/nayza_vocab'),
          ),
          const SizedBox(height: 16),
          SettingsCard(
            title: l10n.checkForUpdates,
            subtitle: l10n.checkForUpdatesSubtitle,
            icon: LucideIcons.refreshCw,
            onTap: () => _launchURL('https://t.me/nayza_vocab'),
          ),
          const SizedBox(height: 32),
          SettingsHeader(title: l10n.dangerZone, color: AppTheme.error),
          const SizedBox(height: 12),
          SettingsCard(
            title: l10n.resetAllData,
            subtitle: l10n.resetAllDataConfirm,
            icon: LucideIcons.trash2,
            iconColor: AppTheme.error,
            onTap: () => _handleResetAllData(context),
          ),
          const SizedBox(height: 48),
          const AppInfoSection(),
        ],
      ),
    );
  }

  Future<void> _handleScheduleReminder(BuildContext context, SettingsProvider provider) async {
    final l10n = AppLocalizations.of(context)!;
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
      builder: (context, child) => Theme(
        data: AppTheme.darkTheme.copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppTheme.electricGold,
            surface: AppTheme.surfaceNavy,
          ),
        ),
        child: child!,
      ),
    );

    if (picked == null || !context.mounted) return;
    await provider.saveReminderTime(picked.hour, picked.minute);
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.reminderSetSuccess(picked.format(context))),
        backgroundColor: AppTheme.success.withValues(alpha: 0.8),
      ),
    );
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
    } catch (e, stack) {
      debugPrint('Import error: $e\n$stack');
      if (!context.mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.importError(e.toString())),
          backgroundColor: AppTheme.error.withValues(alpha: 0.8),
        ),
      );
    }
  }

  Future<void> _handleResetAllData(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await ResetConfirmDialog.show(context);
    if (confirmed != true || !context.mounted) return;

    await context.read<VocabSetProvider>().clearAllData();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.allDataCleared)),
    );
  }
}
