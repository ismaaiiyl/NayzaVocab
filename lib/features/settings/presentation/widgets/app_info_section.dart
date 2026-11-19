import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:nayza_vocab/features/settings/presentation/widgets/settings_card.dart';
import 'package:nayza_vocab/features/settings/presentation/widgets/settings_header.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';

class AppInfoSection extends StatefulWidget {
  const AppInfoSection({super.key});

  @override
  State<AppInfoSection> createState() => _AppInfoSectionState();
}

class _AppInfoSectionState extends State<AppInfoSection> {
  String _currentVersion = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() => _currentVersion = info.version);
      }
    } catch (e, stack) {
      debugPrint('Versiyani olishda xatolik: $e\n$stack');
    }
  }

  Future<void> _openPlayStore() async {
    final marketUri = Uri.parse('market://details?id=uz.nayza.vocab');
    final webUri =
        Uri.parse('https://play.google.com/store/apps/details?id=uz.nayza.vocab');
    try {
      if (await canLaunchUrl(marketUri)) {
        await launchUrl(marketUri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      try {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      } catch (e, stack) {
        debugPrint('Play Store ochishda xatolik: $e\n$stack');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final versionText = _currentVersion.isNotEmpty
        ? l10n.appVersion(_currentVersion)
        : '...';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingsHeader(title: l10n.appInfo),
        const SizedBox(height: 12),
        SettingsCard(
          title: l10n.appTitle,
          subtitle: '$versionText • Google Play',
          icon: LucideIcons.info,
          onTap: _openPlayStore,
        ),
      ],
    );
  }
}
