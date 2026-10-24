import 'package:nayza_vocab/features/vocabulary/data/models/vocab_set_model.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/word_model.dart';

class WordMasteryCalculator {
  static WordModel calculateUpdatedStats(
    WordModel oldWord, {
    required bool isCorrect,
  }) {
    bool willBeDifficult = oldWord.isDifficult;
    int newWrongCount = oldWord.wrongAttempts;
    int newCorrectCount = oldWord.correctAnswersCount;

    if (isCorrect) {
      newCorrectCount++;
      if (oldWord.isDifficult) {
        newWrongCount = (newWrongCount - 1).clamp(0, 3);
        if (newWrongCount == 0) {
          willBeDifficult = false;
        }
      }
    } else {
      newWrongCount = (newWrongCount + 1).clamp(0, 3);
      if (newWrongCount >= 2) {
        willBeDifficult = true;
      }
    }

    return oldWord.copyWith(
      correctAnswersCount: newCorrectCount,
      wrongAttempts: newWrongCount,
      isDifficult: willBeDifficult,
      lastTestedAt: DateTime.now(),
    );
  }

  static List<VocabSetModel> groupIntoVirtualSets(
    List<WordModel> words, {
    int groupSize = 15,
  }) {
    if (words.isEmpty) return [];
    final List<VocabSetModel> virtualSets = [];

    for (int i = 0; i < words.length; i += groupSize) {
      final end = (i + groupSize < words.length) ? i + groupSize : words.length;
      final group = words.sublist(i, end);
      final groupIndex = (i ~/ groupSize) + 1;

      virtualSets.add(VocabSetModel(
        id: 'difficult-group-$groupIndex',
        title: 'Group $groupIndex',
        words: group,
        createdAt: DateTime.now(),
      ));
    }

    return virtualSets;
  }
}
