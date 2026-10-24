import 'package:flutter/material.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';

class QuizSectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const QuizSectionTitle({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.electricGold, size: 20),
        const SizedBox(width: 12),
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppTheme.textDim,
            letterSpacing: 2.0,
          ),
        ),
      ],
    );
  }
}
