import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:nayza_vocab/core/services/app_update_service.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/features/settings/presentation/dialogs/app_update_dialog.dart';
import 'package:nayza_vocab/features/settings/presentation/widgets/settings_card.dart';
import 'package:nayza_vocab/features/settings/presentation/widgets/settings_header.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';

class AppInfoSection extends StatefulWidget {
  final AppUpdateService? updateService;

  const AppInfoSection({super.key, this.updateService});

  @override
  State<AppInfoSection> createState() => _AppInfoSectionState();
}

class _AppInfoSectionState extends State<AppInfoSection> {
  late final AppUpdateService _updateService;
  String _currentVersion = '1.0.1';
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    _updateService = widget.updateService ?? AppUpdateService();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (mounted) setState(() => _currentVersion = info.version);
    } catch (e, stack) {
      debugPrint('Versiyani olishda xatolik: $e\n$stack');
    }
  }

  Future<void> _handleCheckUpdate() async {
    if (_isChecking) return;
    setState(() => _isChecking = true);
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);

    final info = await _updateService.checkForUpdate();
    if (!mounted) return;
    setState(() => _isChecking = false);

    if (info == null) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.updateCheckFailed),
          backgroundColor: AppTheme.error.withValues(alpha: 0.8),
        ),
      );
      return;
    }

    if (info.hasUpdate) {
      await AppUpdateDialog.show(context, info);
    } else {
      messenger.showSnackBar(
        SnackBar(
          content: Text('${l10n.latestVersionInstalled} (v$_currentVersion)'),
          backgroundColor: AppTheme.success.withValues(alpha: 0.8),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingsHeader(title: l10n.appInfo),
        const SizedBox(height: 12),
        SettingsCard(
          title: l10n.checkForUpdates,
          subtitle: 'NayzaVocab v$_currentVersion',
          icon: LucideIcons.refreshCw,
          trailing: _isChecking
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppTheme.electricGold,
                  ),
                )
              : null,
          onTap: _handleCheckUpdate,
        ),
      ],
    );
  }
}
