import 'package:flutter_test/flutter_test.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/word_model.dart';
import 'package:uuid/uuid.dart';

void main() {
  group('WordModel Tests', () {
    final Uuid uuid = const Uuid();
    final String setId = uuid.v4();
    final WordModel word = WordModel(
      id: uuid.v4(),
      original: 'Apple',
      translation: 'Olma',
      setId: setId,
    );

    test('Initial properties should be correct', () {
      expect(word.original, 'Apple');
      expect(word.translation, 'Olma');
      expect(word.isDifficult, false);
      expect(word.wrongAttempts, 0);
      expect(word.correctAnswersCount, 0);
      expect(word.setId, setId);
    });

    test('isLearned correctly identifies mastered words', () {
      final unmastered = word.copyWith(correctAnswersCount: 0);
      expect(unmastered.isLearned, false);

      final mastered = word.copyWith(correctAnswersCount: 1);
      expect(mastered.isLearned, true);

      final difficult = word.copyWith(correctAnswersCount: 2, isDifficult: true);
      expect(difficult.isLearned, false);
    });

    test('copyWith works correctly', () {
      final copied = word.copyWith(
        original: 'Banana',
        translation: 'Banan',
        isDifficult: true,
      );
      
      expect(copied.original, 'Banana');
      expect(copied.translation, 'Banan');
      expect(copied.isDifficult, true);
      expect(copied.id, word.id);
      expect(copied.setId, word.setId);
    });

    test('Serialization (toMap and fromMap)', () {
      final map = word.toMap();
      expect(map['original'], 'Apple');
      expect(map['translation'], 'Olma');
      expect(map['setId'], setId);

      final decoded = WordModel.fromMap(map);
      expect(decoded.id, word.id);
      expect(decoded.original, word.original);
      expect(decoded.setId, word.setId);
    });
  });
}
