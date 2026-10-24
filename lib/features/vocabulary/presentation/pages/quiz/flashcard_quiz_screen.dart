import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/core/utils/audio_helper.dart';
import 'package:nayza_vocab/core/widgets/nayza_widgets.dart';
import 'package:nayza_vocab/features/settings/presentation/provider/settings_provider.dart';
import 'package:nayza_vocab/features/vocabulary/domain/entities/quiz_models.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/quiz_provider.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/widgets/flashcard_action_buttons.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/widgets/flashcard_flip_card.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';

class FlashcardQuizScreen extends StatefulWidget {
  final QuizDirection direction;
  const FlashcardQuizScreen({super.key, required this.direction});

  @override
  State<FlashcardQuizScreen> createState() => _FlashcardQuizScreenState();
}

class _FlashcardQuizScreenState extends State<FlashcardQuizScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  int _currentIndex = 0;
  bool _isFlipped = false;
  final AudioHelper _audioHelper = AudioHelper();

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _flipAnimation = Tween<double>(begin: 0, end: pi).animate(_flipController);
  }

  void _flipCard() {
    if (_isFlipped) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
    setState(() => _isFlipped = !_isFlipped);
  }

  Future<void> _handleMastery(bool known) async {
    final quizProvider = context.read<QuizProvider>();
    final word = quizProvider.trainingList[_currentIndex];

    if (known) {
      quizProvider.markCorrect();
      context.read<VocabSetProvider>().updateWordStats(word, isCorrect: true);
      _audioHelper.playSuccess();
    } else {
      quizProvider.markIncorrect(word);
      context.read<VocabSetProvider>().updateWordStats(word, isCorrect: false);
      _audioHelper.playError();
    }

    if (_isFlipped) {
      _flipCard();
      await Future<void>.delayed(const Duration(milliseconds: 300));
    }

    if (_currentIndex < quizProvider.trainingList.length - 1) {
      if (mounted) setState(() => _currentIndex++);
    } else {
      _showSummary();
    }
  }

  void _showSummary() {
    context.pushReplacementNamed('quiz-results', extra: {
      'mode': QuizMode.flashcard,
      'direction': widget.direction,
    });
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = context.watch<QuizProvider>();
    final settingsProvider = context.watch<SettingsProvider>();
    final l10n = AppLocalizations.of(context)!;

    final trainingList = quizProvider.trainingList;
    if (trainingList.isEmpty) {
      return Scaffold(body: Center(child: Text(l10n.emptyCollectionsWarning)));
    }

    final word = trainingList[_currentIndex];
    bool isReversed = widget.direction == QuizDirection.translationToOriginal;
    if (widget.direction == QuizDirection.random) {
      isReversed = (_currentIndex % 2 != 0);
    }

    final frontText = isReversed ? word.translation : word.original;
    final backText = isReversed ? word.original : word.translation;
    final String speakText = word.original;
    final String speakLang = word.langCode ?? 'en-US';

    return Scaffold(
      appBar: AppBar(
        title: Text('${_currentIndex + 1} / ${trainingList.length}'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              settingsProvider.toggleMute();
              _audioHelper.isMuted = settingsProvider.isMuted;
            },
            icon: Icon(
              settingsProvider.isMuted
                  ? LucideIcons.volumeX
                  : LucideIcons.volume2,
              color: settingsProvider.isMuted
                  ? AppTheme.error
                  : AppTheme.electricGold,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Text(
              l10n.flashcardLabel,
              style: const TextStyle(
                color: AppTheme.textDim,
                letterSpacing: 4,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Hero(
              tag: 'quiz_progress_bar',
              child: NayzaProgressBar(
                current: _currentIndex + 1,
                total: trainingList.length,
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: KeyedSubtree(
                  key: ValueKey(_currentIndex),
                  child: FlashcardFlipCard(
                    frontText: frontText,
                    backText: backText,
                    flipAnimation: _flipAnimation,
                    onFlip: _flipCard,
                    onSpeakFront: !isReversed && !speakLang.startsWith('uz')
                        ? () => _audioHelper.speak(speakText, langCode: speakLang)
                        : null,
                    onSpeakBack: isReversed && !speakLang.startsWith('uz')
                        ? () => _audioHelper.speak(speakText, langCode: speakLang)
                        : null,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 48),
            FlashcardActionButtons(onMastery: _handleMastery),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    _audioHelper.stopAll();
    super.dispose();
  }
}
