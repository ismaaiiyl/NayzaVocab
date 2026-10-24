import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/features/vocabulary/domain/entities/quiz_models.dart';

class QuizDirectionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final QuizDirection direction;
  final bool isSelected;
  final VoidCallback onTap;

  const QuizDirectionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.direction,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.electricGold.withValues(alpha: 0.05) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.electricGold : AppTheme.borderNavy,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.electricGold : AppTheme.borderNavy,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSelected ? LucideIcons.check : LucideIcons.arrowRight,
                color: isSelected ? AppTheme.darkNavy : AppTheme.textDim,
                size: 16,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? AppTheme.textMain : AppTheme.textDim,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: AppTheme.textDim),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
