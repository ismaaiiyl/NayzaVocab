import 'package:nayza_vocab/features/vocabulary/data/models/word_model.dart';

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
