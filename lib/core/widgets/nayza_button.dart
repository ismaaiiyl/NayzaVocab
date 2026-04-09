import 'package:flutter/material.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';

class NayzaButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const NayzaButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.electricGold,
        foregroundColor: AppTheme.darkNavy,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}
