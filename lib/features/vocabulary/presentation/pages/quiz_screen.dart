import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/core/utils/audio_helper.dart';
import 'package:nayza_vocab/core/widgets/nayza_progress_bar.dart';
import 'package:nayza_vocab/features/settings/presentation/provider/settings_provider.dart';
import 'package:nayza_vocab/features/vocabulary/domain/entities/quiz_models.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/quiz/quiz_question_generator.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/quiz/widgets/quiz_choice_grid.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/quiz/widgets/quiz_input_area.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/quiz/widgets/quiz_prompt_card.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/quiz_provider.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:provider/provider.dart';

export 'package:nayza_vocab/features/vocabulary/domain/entities/quiz_models.dart';

class QuizScreen extends StatefulWidget {
  final QuizMode quizMode;
  final QuizDirection direction;
  const QuizScreen({super.key, required this.quizMode, required this.direction});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _answerController = TextEditingController();
  final AudioHelper _audioHelper = AudioHelper();

  List<QuizQuestion> _questions = [];
  int _currentIndex = 0;
  bool _isAnswered = false;
  String? _selectedAnswer;

  @override
  void initState() {
    super.initState();
    _audioHelper.isMuted = context.read<SettingsProvider>().isMuted;
    _generateQuestions();
  }

  void _generateQuestions() {
    final quizProvider = context.read<QuizProvider>();
    final vocabSetProvider = context.read<VocabSetProvider>();
    final allWords = vocabSetProvider.vocabSets.expand((s) => s.words).toList();

    _questions = QuizQuestionGenerator.generate(
      trainingList: quizProvider.trainingList,
      allWords: allWords,
      quizMode: widget.quizMode,
      direction: widget.direction,
    );
  }

  void _handleAnswer(String answer) {
    if (_isAnswered) return;

    final currentQuestion = _questions[_currentIndex];
    final correct = answer.trim().toLowerCase() == currentQuestion.correctAnswer.toLowerCase();

    setState(() {
      _isAnswered = true;
      _selectedAnswer = answer;
    });

    final quizProvider = context.read<QuizProvider>();
    final vocabProvider = context.read<VocabSetProvider>();

    if (correct) {
      quizProvider.markCorrect();
      vocabProvider.updateWordStats(currentQuestion.word, isCorrect: true);
      _audioHelper.playSuccess();
    } else {
      quizProvider.markIncorrect(currentQuestion.word);
      vocabProvider.updateWordStats(currentQuestion.word, isCorrect: false);
      _audioHelper.playError();
    }

    Future<void>.delayed(const Duration(milliseconds: 900), () {
      if (mounted) _nextQuestion();
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _isAnswered = false;
        _answerController.clear();
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      context.pushReplacementNamed('quiz-results', extra: {
        'mode': widget.quizMode,
        'direction': widget.direction,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('${_currentIndex + 1} / ${_questions.length}'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              settings.toggleMute();
              _audioHelper.isMuted = settings.isMuted;
            },
            icon: Icon(
              settings.isMuted ? LucideIcons.volumeX : LucideIcons.volume2,
              color: settings.isMuted ? AppTheme.error : AppTheme.electricGold,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: PageView.builder(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _questions.length,
          itemBuilder: (context, index) {
            final question = _questions[index];
            final canPlayAudio = !question.isReversed && !question.displayLangCode.startsWith('uz');

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Column(
                children: [
                  NayzaProgressBar(
                    current: _currentIndex + 1,
                    total: _questions.length,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    flex: 3,
                    child: QuizPromptCard(
                      question: question,
                      canPlayAudio: canPlayAudio,
                      audioHelper: _audioHelper,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    flex: 5,
                    child: widget.quizMode == QuizMode.choice
                        ? QuizChoiceGrid(
                            question: question,
                            isAnswered: _isAnswered,
                            selectedAnswer: _selectedAnswer,
                            onSelectAnswer: _handleAnswer,
                          )
                        : SingleChildScrollView(
                            child: QuizInputArea(
                              question: question,
                              controller: _answerController,
                              isAnswered: _isAnswered,
                              selectedAnswer: _selectedAnswer,
                              onSubmit: _handleAnswer,
                            ),
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _answerController.dispose();
    _audioHelper.stopAll();
    super.dispose();
  }
}
