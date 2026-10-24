import 'package:flutter/material.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';

class SettingsHeader extends StatelessWidget {
  final String title;
  final Color? color;

  const SettingsHeader({
    super.key,
    required this.title,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
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
}
