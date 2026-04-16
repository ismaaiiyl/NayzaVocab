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
      // 1 mastered (3 pts), 1 active with 1 pts, 1 difficult with 0 pt.
      // Total possible points: 3 words * 3 = 9.
      // Current points: 3 + 1 + 0 = 4.
      // Expected progress: (4 / 9) * 100 = 44.444... => 44.4% roughly.
      // VocabSetModel.progressPercentage => double
      
      final progress = setModel.progressPercentage;
      expect(progress, closeTo(44.4, 0.1));
    });

    test('learnedWordsCount returns correct count', () {
      expect(setModel.learnedWordsCount, 1);
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
