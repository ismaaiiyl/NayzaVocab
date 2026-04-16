import 'package:flutter/material.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/quiz_provider.dart';
import 'package:nayza_vocab/features/settings/presentation/provider/settings_provider.dart';
import 'package:nayza_vocab/core/widgets/nayza_widgets.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/word_model.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';
import 'package:nayza_vocab/core/utils/audio_helper.dart';

enum QuizMode { choice, input, flashcard, matching }

enum QuizDirection { originalToTranslation, translationToOriginal, random }

class QuizQuestion {
  final WordModel word;
  final String displayWord;
  final String correctAnswer;
  final String displayLangCode;
  final List<String> options;
  final bool isReversed;

  QuizQuestion({
    required this.word,
    required this.displayWord,
    required this.correctAnswer,
    required this.displayLangCode,
    required this.options,
    required this.isReversed,
  });
}

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
    final settings = context.read<SettingsProvider>();
    _audioHelper.isMuted = settings.isMuted;
    _generateQuestions();
  }

  void _generateQuestions() {
    final quizProvider = context.read<QuizProvider>();
    final vocabSetProvider = context.read<VocabSetProvider>();
    final trainingList = quizProvider.trainingList;
    final allWords = vocabSetProvider.vocabSets.expand((s) => s.words).toList();

    _questions = trainingList.asMap().entries.map((entry) {
       final index = entry.key;
       final word = entry.value;

       final bool isReversed;
       if (widget.direction == QuizDirection.random) {
         isReversed = (index % 2 == 0);
       } else {
         isReversed = widget.direction == QuizDirection.translationToOriginal;
       }

       final displayWord = isReversed ? word.translation : word.original;
       final correctAnswer = isReversed ? word.original : word.translation;
       final displayLangCode = isReversed ? 'uz-UZ' : (word.langCode ?? 'en-US');

       final options = _generateOptionsForWord(word, isReversed, trainingList, allWords);

       return QuizQuestion(
         word: word,
         displayWord: displayWord,
         correctAnswer: correctAnswer,
         displayLangCode: displayLangCode,
         options: options,
         isReversed: isReversed,
       );
    }).toList();
  }

  List<String> _generateOptionsForWord(WordModel currentWord, bool isReversed, List<WordModel> trainingWords, List<WordModel> globalWords) {
    if (widget.quizMode != QuizMode.choice) return [];

    final String correctVal = (isReversed ? currentWord.original : currentWord.translation).trim();
    final String correctLower = correctVal.toLowerCase();

    final Set<String> uniqueOptions = {correctVal};
    final Set<String> normalizedSet = {correctLower};

    void addUnique(String t) {
      final trimmed = t.trim();
      final lowered = trimmed.toLowerCase();
      if (!normalizedSet.contains(lowered)) {
        uniqueOptions.add(trimmed);
        normalizedSet.add(lowered);
      }
    }

    final pool = trainingWords.map((w) => isReversed ? w.original : w.translation).toList()..shuffle();
    for (var t in pool) {
      if (uniqueOptions.length >= 4) break;
      addUnique(t);
    }

    if (uniqueOptions.length < 4) {
      final globalPool = globalWords.map((w) => isReversed ? w.original : w.translation).toList()..shuffle();
      for (var t in globalPool) {
        if (uniqueOptions.length >= 4) break;
        addUnique(t);
      }
    }

    return uniqueOptions.toList()..shuffle();
  }

  void _handleAnswer(String answer) {
    if (_isAnswered) return;
    
    final currentQuestion = _questions[_currentIndex];
    
    final correct = answer.trim().toLowerCase() == currentQuestion.correctAnswer.toLowerCase();
    
    setState(() {
      _isAnswered = true;
      _selectedAnswer = answer;
    });

    if (correct) {
      context.read<QuizProvider>().markCorrect();
      context.read<VocabSetProvider>().updateWordStats(currentQuestion.word.id, isCorrect: true);
      _audioHelper.playSuccess();
    } else {
      context.read<QuizProvider>().markIncorrect(currentQuestion.word);
      context.read<VocabSetProvider>().updateWordStats(currentQuestion.word.id, isCorrect: false);
      _audioHelper.playError();
    }

    Future<void>.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _nextQuestion();
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _isAnswered = false;
        _answerController.clear();
      });
      _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    } else {
      _showSummary();
    }
  }

  void _showSummary() {
    context.pushReplacementNamed('quiz-results', extra: {
      'mode': widget.quizMode,
      'direction': widget.direction,
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final settings = context.watch<SettingsProvider>();
    final l10n = AppLocalizations.of(context)!;

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
              color: settings.isMuted ? Colors.redAccent : AppTheme.electricGold,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _questions.length,
        itemBuilder: (context, index) {
          final question = _questions[index];
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Hero(
                  tag: 'quiz_progress_bar',
                  child: NayzaProgressBar(
                    current: _currentIndex + 1,
                    total: _questions.length,
                  ),
                ),
                const Spacer(),
                Text(
                  question.displayWord,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                IconButton(
                  onPressed: () => _audioHelper.speak(question.displayWord, langCode: question.displayLangCode),
                  icon: const Icon(LucideIcons.volume2, color: AppTheme.electricGold, size: 32),
                ),
                const SizedBox(height: 48),
                _buildResponseArea(question, l10n),
                const Spacer(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildResponseArea(QuizQuestion question, AppLocalizations l10n) {
    if (widget.quizMode == QuizMode.choice) {
      return GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
        children: question.options.map((opt) {
          Color cardColor = AppTheme.surfaceNavy;
          Color borderColor = AppTheme.borderNavy;
          
          if (_isAnswered) {
            if (opt == question.correctAnswer) {
              cardColor = Colors.greenAccent.withValues(alpha: 0.4);
              borderColor = Colors.greenAccent;
            } else if (opt == _selectedAnswer) {
              cardColor = Colors.redAccent.withValues(alpha: 0.3);
              borderColor = Colors.redAccent;
            }
          }

          return GestureDetector(
            onTap: () => _handleAnswer(opt),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor, width: 2),
                boxShadow: _isAnswered && opt == question.correctAnswer ? [
                  BoxShadow(color: Colors.greenAccent.withValues(alpha: 0.3), blurRadius: 15)
                ] : [],
              ),
              child: Center(
                child: Text(
                  opt,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: _isAnswered && opt == question.correctAnswer ? Colors.greenAccent : AppTheme.textMain,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      );
    } else {
      return Column(
        children: [
          TextField(
            controller: _answerController,
            enabled: !_isAnswered,
            decoration: InputDecoration(
              hintText: l10n.typeTranslationHint,
              filled: true,
              fillColor: AppTheme.surfaceNavy,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              suffixIcon: _isAnswered 
                ? Icon(
                    _selectedAnswer?.trim().toLowerCase() == question.correctAnswer.toLowerCase() 
                      ? LucideIcons.checkCircle 
                      : LucideIcons.xCircle,
                    color: _selectedAnswer?.trim().toLowerCase() == question.correctAnswer.toLowerCase() 
                      ? Colors.greenAccent 
                      : Colors.redAccent,
                  ) 
                : null,
            ),
            onSubmitted: (val) => _handleAnswer(val),
          ),
          if (_isAnswered) ...[
            const SizedBox(height: 16),
            Text(
              l10n.correctAnswerLabel(question.correctAnswer),
              style: const TextStyle(color: Colors.greenAccent, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ],
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _answerController.dispose();
    _audioHelper.stopAll();
    super.dispose();
  }
}
