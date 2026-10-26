import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/features/settings/presentation/provider/settings_provider.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';

class AudioSpeedSheet extends StatelessWidget {
  final SettingsProvider settings;

  const AudioSpeedSheet({
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
      builder: (context) => AudioSpeedSheet(settings: settings),
    );
  }

  static String getSpeedLabel(double rate, AppLocalizations l10n) {
    if (rate <= 0.4) return l10n.speedSlow;
    if (rate >= 0.6) return l10n.speedFast;
    return l10n.speedNormal;
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
            l10n.audioSpeed.toUpperCase(),
            style: const TextStyle(
              color: AppTheme.electricGold,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          _buildOption(context, 0.35, l10n.speedSlow),
          _buildOption(context, 0.50, l10n.speedNormal),
          _buildOption(context, 0.65, l10n.speedFast),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildOption(BuildContext context, double rate, String label) {
    final isSelected = (settings.speechRate - rate).abs() < 0.05;
    return ListTile(
      onTap: () {
        settings.setSpeechRate(rate);
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
