import 'package:flutter/material.dart';
import 'package:nayza_vocab/core/services/data_service.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/features/settings/presentation/dialogs/reset_confirm_dialog.dart';
import 'package:nayza_vocab/features/settings/presentation/provider/settings_provider.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/vocab_set_model.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsActionsHandler {
  const SettingsActionsHandler._();

  static Future<void> launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  static Future<void> handleScheduleReminder(BuildContext context, SettingsProvider provider) async {
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

  static Future<void> handleImport(BuildContext context) async {
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

  static Future<void> handleResetAllData(BuildContext context) async {
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
