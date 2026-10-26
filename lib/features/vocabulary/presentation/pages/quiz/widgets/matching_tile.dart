import 'package:flutter/material.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/features/vocabulary/domain/entities/matching_item.dart';

class MatchingTile extends StatelessWidget {
  final MatchingItem item;
  final bool isCorrect;
  final bool isWrong;
  final VoidCallback onTap;

  const MatchingTile({
    super.key,
    required this.item,
    required this.isCorrect,
    required this.isWrong,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = item.isSelected;
    final bool isMatched = item.isMatched;

    Color tileColor = AppTheme.surfaceNavy;
    Color borderColor = AppTheme.borderNavy;
    Color textColor = AppTheme.textMain;

    if (isCorrect) {
      tileColor = AppTheme.success.withValues(alpha: 0.2);
      borderColor = AppTheme.success;
      textColor = AppTheme.success;
    } else if (isWrong) {
      tileColor = AppTheme.error.withValues(alpha: 0.2);
      borderColor = AppTheme.error;
      textColor = AppTheme.error;
    } else if (isSelected) {
      tileColor = AppTheme.electricGold.withValues(alpha: 0.15);
      borderColor = AppTheme.electricGold;
      textColor = AppTheme.electricGold;
    }

    return AnimatedScale(
      scale: isMatched ? 0.0 : (isSelected ? 1.05 : 1.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isMatched ? 0.0 : 1.0,
        child: GestureDetector(
          onTap: isMatched ? null : onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: tileColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: borderColor,
                width: isSelected ? 3 : 1.5,
              ),
              boxShadow: isSelected && !isMatched
                  ? [
                      BoxShadow(
                        color: borderColor.withValues(alpha: 0.3),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    item.text,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: textColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
