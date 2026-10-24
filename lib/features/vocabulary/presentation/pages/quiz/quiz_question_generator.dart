import 'dart:math' as math;
import 'package:nayza_vocab/features/vocabulary/data/models/word_model.dart';
import 'package:nayza_vocab/features/vocabulary/domain/entities/quiz_models.dart';

class QuizQuestionGenerator {
  static List<QuizQuestion> generate({
    required List<WordModel> trainingList,
    required List<WordModel> allWords,
    required QuizMode quizMode,
    required QuizDirection direction,
  }) {
    final List<String> globalOriginals = allWords.map((w) => w.original).toList()..shuffle();
    final List<String> globalTranslations = allWords.map((w) => w.translation).toList()..shuffle();

    return trainingList.asMap().entries.map((entry) {
      final word = entry.value;

      final bool isReversed;
      if (direction == QuizDirection.random) {
        isReversed = math.Random().nextBool();
      } else {
        isReversed = direction == QuizDirection.translationToOriginal;
      }

      final displayWord = isReversed ? word.translation : word.original;
      final correctAnswer = isReversed ? word.original : word.translation;
      final displayLangCode = isReversed ? 'uz-UZ' : (word.langCode ?? 'en-US');

      final options = _generateOptionsForWord(
        word: word,
        isReversed: isReversed,
        trainingWords: trainingList,
        pool: isReversed ? globalOriginals : globalTranslations,
        isChoiceMode: quizMode == QuizMode.choice,
      );

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

  static List<String> _generateOptionsForWord({
    required WordModel word,
    required bool isReversed,
    required List<WordModel> trainingWords,
    required List<String> pool,
    required bool isChoiceMode,
  }) {
    if (!isChoiceMode) return const [];

    final String correctVal = (isReversed ? word.original : word.translation).trim();
    final String correctLower = correctVal.toLowerCase();

    final Set<String> uniqueOptions = {correctVal};
    final Set<String> normalizedSet = {correctLower};

    void addUnique(String t) {
      final trimmed = t.trim();
      final lowered = trimmed.toLowerCase();
      if (trimmed.isNotEmpty && !normalizedSet.contains(lowered)) {
        uniqueOptions.add(trimmed);
        normalizedSet.add(lowered);
      }
    }

    for (final w in trainingWords) {
      if (uniqueOptions.length >= 4) break;
      addUnique(isReversed ? w.original : w.translation);
    }

    if (uniqueOptions.length < 4) {
      for (final t in pool) {
        if (uniqueOptions.length >= 4) break;
        addUnique(t);
      }
    }

    return uniqueOptions.toList()..shuffle();
  }
}
