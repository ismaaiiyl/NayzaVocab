import 'package:flutter_test/flutter_test.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/vocab_set_model.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/word_model.dart';
import 'package:uuid/uuid.dart';

void main() {
  group('VocabSetModel Tests', () {
    final Uuid uuid = const Uuid();
    final String setId = uuid.v4();
    
    final List<WordModel> words = [
      WordModel(id: uuid.v4(), original: 'One', translation: 'Bir', setId: setId).copyWith(correctAnswersCount: 3), // Mastered (3)
      WordModel(id: uuid.v4(), original: 'Two', translation: 'Ikki', setId: setId).copyWith(correctAnswersCount: 1), // Active (1)
      WordModel(id: uuid.v4(), original: 'Three', translation: 'Uch', setId: setId).copyWith(correctAnswersCount: 0, isDifficult: true), // Difficult (0 correct)
    ];

    final setModel = VocabSetModel(
      id: setId,
      title: 'Numbers',
      createdAt: DateTime.now(),
      words: words,
    );

    test('progressPercentage calculates correctly based on word mastery', () {
      // 2 learned words out of 3 = (2 / 3) * 100 = 66.67%
      final progress = setModel.progressPercentage;
      expect(progress, closeTo(66.7, 0.1));
    });

    test('learnedWordsCount returns correct count', () {
      expect(setModel.learnedWordsCount, 2);
    });

    test('copyWith updates fields while preserving others', () {
      final updatedSet = setModel.copyWith(title: 'New Title');
      expect(updatedSet.title, 'New Title');
      expect(updatedSet.id, setModel.id);
      expect(updatedSet.words.length, 3);
    });

    test('Serialization (toMap and fromMap)', () {
      final map = setModel.toMap();
      expect(map['title'], 'Numbers');
      expect((map['words'] as List).length, 3);

      final decoded = VocabSetModel.fromMap(map);
      expect(decoded.id, setModel.id);
      expect(decoded.title, setModel.title);
      expect(decoded.words.length, 3);
    });
  });
}
