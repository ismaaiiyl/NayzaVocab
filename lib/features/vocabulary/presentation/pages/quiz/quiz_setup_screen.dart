import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/widgets/nayza_button.dart';
import 'package:nayza_vocab/features/vocabulary/domain/entities/quiz_models.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/quiz/widgets/quiz_direction_tile.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/quiz/widgets/quiz_mode_card.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/quiz/widgets/quiz_section_title.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';

class QuizSetupScreen extends StatefulWidget {
  final QuizMode? initialMode;
  const QuizSetupScreen({super.key, this.initialMode});

  @override
  State<QuizSetupScreen> createState() => _QuizSetupScreenState();
}

class _QuizSetupScreenState extends State<QuizSetupScreen> {
  late QuizMode _selectedMode;
  QuizDirection _selectedDirection = QuizDirection.originalToTranslation;

  @override
  void initState() {
    super.initState();
    _selectedMode = widget.initialMode ?? QuizMode.choice;
  }

  void _startTraining() {
    if (_selectedMode == QuizMode.flashcard) {
      context.pushReplacementNamed('flashcard-quiz');
    } else if (_selectedMode == QuizMode.matching) {
      context.pushReplacementNamed('matching-game');
    } else {
      context.pushReplacementNamed('quiz', extra: {
        'mode': _selectedMode,
        'direction': _selectedDirection,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.quizSetupTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.initialMode == null) ...[
              QuizSectionTitle(title: l10n.selectQuizMode, icon: LucideIcons.gamepad2),
              const SizedBox(height: 16),
              _buildModeGrid(l10n),
              const SizedBox(height: 32),
            ],
            QuizSectionTitle(title: l10n.selectDirection, icon: LucideIcons.repeat),
            const SizedBox(height: 16),
            _buildDirectionSelector(l10n),
            const SizedBox(height: 48),
            NayzaButton(
              text: l10n.start,
              icon: LucideIcons.play,
              onPressed: _startTraining,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeGrid(AppLocalizations l10n) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 0.9,
      children: [
        QuizModeCard(
          title: l10n.choiceMode,
          subtitle: l10n.choiceSubtitle,
          icon: LucideIcons.layoutGrid,
          mode: QuizMode.choice,
          isSelected: _selectedMode == QuizMode.choice,
          onTap: () => setState(() => _selectedMode = QuizMode.choice),
        ),
        QuizModeCard(
          title: l10n.inputMode,
          subtitle: l10n.inputSubtitle,
          icon: LucideIcons.pencil,
          mode: QuizMode.input,
          isSelected: _selectedMode == QuizMode.input,
          onTap: () => setState(() => _selectedMode = QuizMode.input),
        ),
        QuizModeCard(
          title: l10n.flashcardMode,
          subtitle: l10n.flashcardSubtitle,
          icon: LucideIcons.layers,
          mode: QuizMode.flashcard,
          isSelected: _selectedMode == QuizMode.flashcard,
          onTap: () => setState(() => _selectedMode = QuizMode.flashcard),
        ),
        QuizModeCard(
          title: l10n.matchingMode,
          subtitle: l10n.matchingSubtitle,
          icon: LucideIcons.layoutGrid,
          mode: QuizMode.matching,
          isSelected: _selectedMode == QuizMode.matching,
          onTap: () => setState(() => _selectedMode = QuizMode.matching),
        ),
      ],
    );
  }

  Widget _buildDirectionSelector(AppLocalizations l10n) {
    return Column(
      children: [
        QuizDirectionTile(
          title: l10n.originalToTranslation,
          subtitle: l10n.originalToTranslationSubtitle,
          direction: QuizDirection.originalToTranslation,
          isSelected: _selectedDirection == QuizDirection.originalToTranslation,
          onTap: () => setState(() => _selectedDirection = QuizDirection.originalToTranslation),
        ),
        const SizedBox(height: 12),
        QuizDirectionTile(
          title: l10n.translationToOriginal,
          subtitle: l10n.translationToOriginalSubtitle,
          direction: QuizDirection.translationToOriginal,
          isSelected: _selectedDirection == QuizDirection.translationToOriginal,
          onTap: () => setState(() => _selectedDirection = QuizDirection.translationToOriginal),
        ),
        const SizedBox(height: 12),
        QuizDirectionTile(
          title: l10n.randomDirection,
          subtitle: l10n.randomDirectionSubtitle,
          direction: QuizDirection.random,
          isSelected: _selectedDirection == QuizDirection.random,
          onTap: () => setState(() => _selectedDirection = QuizDirection.random),
        ),
      ],
    );
  }
}
