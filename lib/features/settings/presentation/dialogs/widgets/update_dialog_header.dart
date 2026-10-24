import 'package:flutter/material.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';

class UpdateDialogHeader extends StatelessWidget {
  final String currentVersion;
  final String latestVersion;

  const UpdateDialogHeader({
    super.key,
    required this.currentVersion,
    required this.latestVersion,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.electricGold.withValues(alpha: 0.15),
            border: Border.all(color: AppTheme.electricGold, width: 1.5),
          ),
          alignment: Alignment.center,
          child: const Text('🚀', style: TextStyle(fontSize: 24)),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.updateAvailable,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: AppTheme.textMain,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _pill(currentVersion, AppTheme.textDim),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Icon(Icons.arrow_forward_rounded, color: AppTheme.electricGold, size: 16),
            ),
            _pill(latestVersion, AppTheme.electricGold, isHighlighted: true),
          ],
        ),
      ],
    );
  }

  Widget _pill(String text, Color color, {bool isHighlighted = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isHighlighted ? AppTheme.electricGold.withValues(alpha: 0.15) : AppTheme.darkNavy,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}
