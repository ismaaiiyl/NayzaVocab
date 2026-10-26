import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/features/settings/presentation/controllers/settings_actions_handler.dart';
import 'package:nayza_vocab/features/settings/presentation/dialogs/audio_speed_sheet.dart';
import 'package:nayza_vocab/features/settings/presentation/dialogs/language_picker_sheet.dart';
import 'package:nayza_vocab/features/settings/presentation/provider/settings_provider.dart';
import 'package:nayza_vocab/features/settings/presentation/widgets/app_info_section.dart';
import 'package:nayza_vocab/features/settings/presentation/widgets/settings_card.dart';
import 'package:nayza_vocab/features/settings/presentation/widgets/settings_header.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
          SettingsHeader(title: l10n.language.toUpperCase()),
          const SizedBox(height: 12),
          SettingsCard(
            title: l10n.language,
            subtitle: LanguagePickerSheet.getLanguageName(settings.languageCode, l10n),
            icon: LucideIcons.languages,
            onTap: () => LanguagePickerSheet.show(context, settings),
          ),
          const SizedBox(height: 12),
          SettingsCard(
            title: l10n.audioSpeed,
            subtitle: AudioSpeedSheet.getSpeedLabel(settings.speechRate, l10n),
            icon: LucideIcons.gauge,
            onTap: () => AudioSpeedSheet.show(context, settings),
          ),
          const SizedBox(height: 28),
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
            onTap: () => SettingsActionsHandler.handleScheduleReminder(
              context,
              context.read<SettingsProvider>(),
            ),
          ),
          const SizedBox(height: 28),
          SettingsHeader(title: l10n.dataManagement),
          const SizedBox(height: 12),
          SettingsCard(
            title: l10n.export,
            subtitle: l10n.exportSubtitle,
            icon: LucideIcons.download,
            onTap: () => context.pushNamed('export-selection'),
          ),
          const SizedBox(height: 12),
          SettingsCard(
            title: l10n.import,
            subtitle: l10n.importSubtitle,
            icon: LucideIcons.upload,
            onTap: () => SettingsActionsHandler.handleImport(context),
          ),
          const SizedBox(height: 28),
          SettingsHeader(title: l10n.communityAndUpdates),
          const SizedBox(height: 12),
          SettingsCard(
            title: l10n.telegramChannel,
            subtitle: l10n.telegramSubtitle,
            icon: LucideIcons.send,
            iconColor: const Color(0xFF2AABEE),
            onTap: () => SettingsActionsHandler.launchURL('https://t.me/nayza_vocab'),
          ),
          const SizedBox(height: 28),
          const AppInfoSection(),
          const SizedBox(height: 28),
          SettingsHeader(title: l10n.dangerZone, color: AppTheme.error),
          const SizedBox(height: 12),
          SettingsCard(
            title: l10n.resetAllData,
            subtitle: l10n.resetAllDataConfirm,
            icon: LucideIcons.trash2,
            iconColor: AppTheme.error,
            onTap: () => SettingsActionsHandler.handleResetAllData(context),
          ),
        ],
      ),
    );
  }
}
