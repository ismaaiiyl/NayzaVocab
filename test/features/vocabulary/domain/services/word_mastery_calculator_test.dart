import 'package:flutter_test/flutter_test.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/word_model.dart';
import 'package:nayza_vocab/features/vocabulary/domain/services/word_mastery_calculator.dart';

void main() {
  group('WordMasteryCalculator Tests', () {
    final baseWord = WordModel(
      id: 'w1',
      original: 'Hello',
      translation: 'Salom',
      setId: 's1',
    );

    test('Single wrong answer increases wrongAttempts but does not make difficult', () {
      final updated = WordMasteryCalculator.calculateUpdatedStats(baseWord, isCorrect: false);
      expect(updated.wrongAttempts, 1);
      expect(updated.isDifficult, false);
      expect(updated.isLearned, false);
    });

    test('Two wrong answers mark word as difficult and not learned', () {
      final oneWrong = baseWord.copyWith(wrongAttempts: 1);
      final twoWrong = WordMasteryCalculator.calculateUpdatedStats(oneWrong, isCorrect: false);
      expect(twoWrong.wrongAttempts, 2);
      expect(twoWrong.isDifficult, true);
      expect(twoWrong.isLearned, false);
    });

    test('Difficult word requires 2 correct answers to graduate', () {
      final difficultWord = baseWord.copyWith(
        wrongAttempts: 2,
        isDifficult: true,
        correctAnswersCount: 5, // Had previous correct answers
      );

      // First correct answer: wrongAttempts drops to 1, still difficult
      final step1 = WordMasteryCalculator.calculateUpdatedStats(difficultWord, isCorrect: true);
      expect(step1.wrongAttempts, 1);
      expect(step1.isDifficult, true);
      expect(step1.isLearned, false);

      // Second correct answer: wrongAttempts drops to 0, graduates from difficult!
      final step2 = WordMasteryCalculator.calculateUpdatedStats(step1, isCorrect: true);
      expect(step2.wrongAttempts, 0);
      expect(step2.isDifficult, false);
      expect(step2.isLearned, true);
    });

    test('groupIntoVirtualSets groups words in chunks of 15 with valid titles', () {
      final words = List.generate(
        35,
        (i) => WordModel(id: 'w$i', original: 'Word $i', translation: 'Tarjima $i', setId: 's1'),
      );

      final sets = WordMasteryCalculator.groupIntoVirtualSets(words);
      expect(sets.length, 3);
      expect(sets[0].words.length, 15);
      expect(sets[0].title, 'Group 1');
      expect(sets[1].words.length, 15);
      expect(sets[1].title, 'Group 2');
      expect(sets[2].words.length, 5);
      expect(sets[2].title, 'Group 3');
    });
  });
}
