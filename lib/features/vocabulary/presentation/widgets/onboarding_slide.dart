import 'package:flutter/material.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';

class OnboardingContent {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const OnboardingContent({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}

class OnboardingSlide extends StatelessWidget {
  final OnboardingContent content;

  const OnboardingSlide({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: content.color.withValues(alpha: 0.1),
              boxShadow: [
                BoxShadow(
                  color: content.color.withValues(alpha: 0.1),
                  blurRadius: 100,
                  spreadRadius: 20,
                ),
              ],
            ),
            child: Icon(content.icon, size: 100, color: content.color),
          ),
          const SizedBox(height: 60),
          Text(
            content.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppTheme.textMain,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            content.subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: AppTheme.textDim,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
