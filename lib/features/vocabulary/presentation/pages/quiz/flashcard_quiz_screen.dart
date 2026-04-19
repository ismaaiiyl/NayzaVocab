import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/core/widgets/nayza_widgets.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/quiz_provider.dart';
import 'package:nayza_vocab/features/settings/presentation/provider/settings_provider.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/quiz_screen.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:go_router/go_router.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';
import 'package:nayza_vocab/core/utils/audio_helper.dart';

class FlashcardQuizScreen extends StatefulWidget {
  final QuizDirection direction;
  const FlashcardQuizScreen({super.key, required this.direction});

  @override
  State<FlashcardQuizScreen> createState() => _FlashcardQuizScreenState();
}

class _FlashcardQuizScreenState extends State<FlashcardQuizScreen> with SingleTickerProviderStateMixin {
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

  void _handleMastery(bool known) async {
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

    // Senior logic: Wait for card to flip back if it was flipped
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
    if (trainingList.isEmpty) return Scaffold(body: Center(child: Text(l10n.emptyCollectionsWarning)));

    final word = trainingList[_currentIndex];
    
    // Determine what's on front and back
    bool isReversed = widget.direction == QuizDirection.translationToOriginal;
    if (widget.direction == QuizDirection.random) {
      isReversed = (_currentIndex % 2 != 0);
    }
    
    final frontText = isReversed ? word.translation : word.original;
    final backText = isReversed ? word.original : word.translation;
    
    // Audio logic: We almost always want to hear the original (English) word
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
              settingsProvider.isMuted ? LucideIcons.volumeX : LucideIcons.volume2,
              color: settingsProvider.isMuted ? Colors.redAccent : AppTheme.electricGold,
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
              style: const TextStyle(color: AppTheme.textDim, letterSpacing: 4, fontWeight: FontWeight.bold),
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
                child: GestureDetector(
                  key: ValueKey(_currentIndex),
                  onTap: _flipCard,
                  child: AnimatedBuilder(
                    animation: _flipAnimation,
                    builder: (context, child) {
                      final angle = _flipAnimation.value;
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
                              child: _buildCardBack(backText, speakText, speakLang),
                            )
                          : _buildCardFront(frontText),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 48),
            Row(
              children: [
                Expanded(
                  child: NayzaButton(
                    text: l10n.dontKnowWord.toUpperCase(),
                    icon: LucideIcons.xCircle,
                    onPressed: () => _handleMastery(false),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: NayzaButton(
                    text: l10n.knowWord.toUpperCase(),
                    icon: LucideIcons.checkCircle,
                    onPressed: () => _handleMastery(true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardFront(String text) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.surfaceNavy,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppTheme.electricGold.withValues(alpha: 0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: AppTheme.electricGold.withValues(alpha: 0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.textMain),
          ),
        ),
      ),
    );
  }

  Widget _buildCardBack(String text, String speakText, String lang) {
     return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppTheme.electricGold, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.electricGold),
            ),
          ),
          IconButton(
            onPressed: () => _audioHelper.speak(speakText, langCode: lang),
            icon: const Icon(LucideIcons.volume2, color: AppTheme.electricGold, size: 40),
          ),
        ],
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
