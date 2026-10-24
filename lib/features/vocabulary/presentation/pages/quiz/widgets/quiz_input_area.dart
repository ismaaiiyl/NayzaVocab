import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/core/widgets/nayza_button.dart';
import 'package:nayza_vocab/features/vocabulary/domain/entities/quiz_models.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';

class QuizInputArea extends StatelessWidget {
  final QuizQuestion question;
  final TextEditingController controller;
  final bool isAnswered;
  final String? selectedAnswer;
  final ValueChanged<String> onSubmit;

  const QuizInputArea({
    super.key,
    required this.question,
    required this.controller,
    required this.isAnswered,
    required this.selectedAnswer,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isCorrect =
        selectedAnswer?.trim().toLowerCase() == question.correctAnswer.toLowerCase();

    return Column(
      children: [
        TextField(
          controller: controller,
          enabled: !isAnswered,
          decoration: InputDecoration(
            hintText: l10n.typeTranslationHint,
            filled: true,
            fillColor: AppTheme.surfaceNavy,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            suffixIcon: isAnswered
                ? Icon(
                    isCorrect ? LucideIcons.checkCircle : LucideIcons.xCircle,
                    color: isCorrect ? AppTheme.success : AppTheme.error,
                  )
                : null,
          ),
          onSubmitted: onSubmit,
        ),
        if (isAnswered) ...[
          const SizedBox(height: 16),
          Text(
            l10n.correctAnswerLabel(question.correctAnswer),
            style: const TextStyle(
              color: AppTheme.success,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ] else ...[
          const SizedBox(height: 24),
          NayzaButton(
            text: l10n.submitAnswer,
            onPressed: () => onSubmit(controller.text),
          ),
        ],
      ],
    );
  }
}
