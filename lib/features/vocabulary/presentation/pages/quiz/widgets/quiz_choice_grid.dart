import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/features/vocabulary/domain/entities/quiz_models.dart';

class QuizChoiceGrid extends StatelessWidget {
  final QuizQuestion question;
  final bool isAnswered;
  final String? selectedAnswer;
  final ValueChanged<String> onSelectAnswer;

  const QuizChoiceGrid({
    super.key,
    required this.question,
    required this.isAnswered,
    required this.selectedAnswer,
    required this.onSelectAnswer,
  });

  static const List<String> _letters = ['A', 'B', 'C', 'D'];

  Widget _buildCard(String opt, String letter) {
    final isCorrect = opt == question.correctAnswer;
    final isSelected = opt == selectedAnswer;

    Color cardBg = AppTheme.surfaceNavy;
    Color borderColor = AppTheme.borderNavy;
    Color textColor = AppTheme.textMain;
    Color badgeBg = AppTheme.cardDark;
    Color badgeTextColor = AppTheme.textDim;
    IconData? statusIcon;

    if (isAnswered) {
      if (isCorrect) {
        cardBg = AppTheme.success.withValues(alpha: 0.15);
        borderColor = AppTheme.success;
        textColor = AppTheme.success;
        badgeBg = AppTheme.success.withValues(alpha: 0.25);
        badgeTextColor = AppTheme.success;
        statusIcon = LucideIcons.checkCircle2;
      } else if (isSelected) {
        cardBg = AppTheme.error.withValues(alpha: 0.15);
        borderColor = AppTheme.error;
        textColor = AppTheme.error;
        badgeBg = AppTheme.error.withValues(alpha: 0.25);
        badgeTextColor = AppTheme.error;
        statusIcon = LucideIcons.xCircle;
      }
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isAnswered ? null : () => onSelectAnswer(opt),
        borderRadius: BorderRadius.circular(16),
        splashColor: AppTheme.electricGold.withValues(alpha: 0.1),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: borderColor,
              width: isAnswered && (isCorrect || isSelected) ? 2 : 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: isAnswered && isCorrect
                    ? AppTheme.success.withValues(alpha: 0.2)
                    : Colors.black.withValues(alpha: 0.15),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: badgeBg,
                  shape: BoxShape.circle,
                  border: Border.all(color: borderColor, width: 1),
                ),
                alignment: Alignment.center,
                child: Text(
                  letter,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: badgeTextColor,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  opt,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (statusIcon != null)
                Icon(statusIcon, color: borderColor, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final options = question.options;
    if (options.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        for (int i = 0; i < options.length; i++) ...[
          if (i > 0) const SizedBox(height: 10),
          Expanded(
            child: _buildCard(options[i], _letters[i]),
          ),
        ],
      ],
    );
  }
}
