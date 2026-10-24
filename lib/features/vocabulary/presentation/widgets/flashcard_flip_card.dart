import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';

class FlashcardFlipCard extends StatelessWidget {
  final String frontText;
  final String backText;
  final Animation<double> flipAnimation;
  final VoidCallback onFlip;
  final VoidCallback? onSpeak;
  final VoidCallback? onSpeakFront;
  final VoidCallback? onSpeakBack;

  const FlashcardFlipCard({
    super.key,
    required this.frontText,
    required this.backText,
    required this.flipAnimation,
    required this.onFlip,
    this.onSpeak,
    this.onSpeakFront,
    this.onSpeakBack,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onFlip,
      child: AnimatedBuilder(
        animation: flipAnimation,
        builder: (context, child) {
          final angle = flipAnimation.value;
          final isBack = angle >= pi / 2;
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            alignment: Alignment.center,
            child: isBack
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(pi),
                    child: _buildCardBack(backText),
                  )
                : _buildCardFront(frontText),
          );
        },
      ),
    );
  }

  Widget _buildCardFront(String text) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.surfaceNavy,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppTheme.electricGold.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppTheme.textMain,
              ),
            ),
          ),
          if (onSpeakFront != null) ...[
            IconButton(
              onPressed: onSpeakFront,
              icon: const Icon(
                LucideIcons.volume2,
                color: AppTheme.electricGold,
                size: 32,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCardBack(String text) {
    final speakCb = onSpeakBack ?? onSpeak;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppTheme.electricGold, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppTheme.electricGold,
              ),
            ),
          ),
          if (speakCb != null) ...[
            IconButton(
              onPressed: speakCb,
              icon: const Icon(
                LucideIcons.volume2,
                color: AppTheme.electricGold,
                size: 32,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
