import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/core/widgets/nayza_widgets.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/quiz_screen.dart';
import 'package:go_router/go_router.dart';
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
              _SectionTitle(title: l10n.selectQuizMode, icon: LucideIcons.gamepad2),
              const SizedBox(height: 16),
              _buildModeGrid(l10n),
              const SizedBox(height: 32),
            ],
            _SectionTitle(title: l10n.selectDirection, icon: LucideIcons.repeat),
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
        _ModeCard(
          title: l10n.choiceMode,
          subtitle: l10n.choiceSubtitle,
          icon: LucideIcons.layoutGrid,
          mode: QuizMode.choice,
          isSelected: _selectedMode == QuizMode.choice,
          onTap: () => setState(() => _selectedMode = QuizMode.choice),
        ),
        _ModeCard(
          title: l10n.inputMode,
          subtitle: l10n.inputSubtitle,
          icon: LucideIcons.pencil,
          mode: QuizMode.input,
          isSelected: _selectedMode == QuizMode.input,
          onTap: () => setState(() => _selectedMode = QuizMode.input),
        ),
        _ModeCard(
          title: l10n.flashcardMode,
          subtitle: l10n.flashcardSubtitle,
          icon: LucideIcons.layers,
          mode: QuizMode.flashcard,
          isSelected: _selectedMode == QuizMode.flashcard,
          onTap: () => setState(() => _selectedMode = QuizMode.flashcard),
        ),
        _ModeCard(
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
        _DirectionTile(
          title: l10n.originalToTranslation,
          subtitle: l10n.originalToTranslationSubtitle,
          direction: QuizDirection.originalToTranslation,
          isSelected: _selectedDirection == QuizDirection.originalToTranslation,
          onTap: () => setState(() => _selectedDirection = QuizDirection.originalToTranslation),
        ),
        const SizedBox(height: 12),
        _DirectionTile(
          title: l10n.translationToOriginal,
          subtitle: l10n.translationToOriginalSubtitle,
          direction: QuizDirection.translationToOriginal,
          isSelected: _selectedDirection == QuizDirection.translationToOriginal,
          onTap: () => setState(() => _selectedDirection = QuizDirection.translationToOriginal),
        ),
        const SizedBox(height: 12),
        _DirectionTile(
          title: l10n.randomDirection,
          subtitle: l10n.randomDirectionSubtitle,
          direction: QuizDirection.random,
          isSelected: _selectedDirection == QuizDirection.random,
          onTap: () => setState(() => _selectedDirection = QuizDirection.random),
        ),
      ],
    );
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
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionTitle({required this.title, required this.icon});

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

class _ModeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final QuizMode mode;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.mode,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.electricGold.withValues(alpha: 0.1) : AppTheme.surfaceNavy,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.electricGold : AppTheme.borderNavy,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? AppTheme.electricGold : AppTheme.textDim, size: 36),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppTheme.electricGold : AppTheme.textMain,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, color: AppTheme.textDim),
            ),
          ],
        ),
      ),
    );
  }
}

class _DirectionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final QuizDirection direction;
  final bool isSelected;
  final VoidCallback onTap;

  const _DirectionTile({
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
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? AppTheme.textMain : AppTheme.textDim)),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: AppTheme.textDim)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
