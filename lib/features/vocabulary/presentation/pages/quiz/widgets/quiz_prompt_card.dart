import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/core/utils/audio_helper.dart';
import 'package:nayza_vocab/features/vocabulary/domain/entities/quiz_models.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';

class QuizPromptCard extends StatelessWidget {
  final QuizQuestion question;
  final bool canPlayAudio;
  final AudioHelper audioHelper;

  const QuizPromptCard({
    super.key,
    required this.question,
    required this.canPlayAudio,
    required this.audioHelper,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final langLabel = question.isReversed
        ? l10n.uzbekLang.toUpperCase()
        : (question.word.langCode?.toUpperCase() ?? l10n.englishLang.toUpperCase());

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.surfaceNavy,
            Color(0xFF0D1B2E),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.electricGold.withValues(alpha: 0.2),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: AppTheme.electricGold.withValues(alpha: 0.04),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.cardDark.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.borderNavy,
                width: 1,
              ),
            ),
            child: Text(
              langLabel,
              style: const TextStyle(
                color: AppTheme.textDim,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              question.displayWord,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w800,
                color: AppTheme.textMain,
                letterSpacing: 0.5,
              ),
            ),
          ),
          if (canPlayAudio) ...[
            const SizedBox(height: 12),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => audioHelper.speak(
                  question.displayWord,
                  langCode: question.displayLangCode,
                ),
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppTheme.cardDark,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.electricGold.withValues(alpha: 0.4),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.electricGold.withValues(alpha: 0.15),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(
                    LucideIcons.volume2,
                    color: AppTheme.electricGold,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
