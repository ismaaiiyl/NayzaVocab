import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/vocab_set_model.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/word_model.dart';
import 'package:uuid/uuid.dart';

/// Senior-level VocabSetProvider (Data Repository).
///
/// Handles persistent storage operations and provides a clean interface
/// for managing vocab sets and words.
class VocabSetProvider with ChangeNotifier {
  final Box<VocabSetModel> _vocabSetBox;
  List<VocabSetModel> _vocabSets = [];
  final Uuid _uuid = const Uuid();

  // O(1) lookup: wordId → setId
  // Maintains a global index for constant-time updates across the app.
  final Map<String, String> _wordSetIndex = {};

  VocabSetProvider(this._vocabSetBox) {
    _loadVocabSets();
  }

  // ─── Getters ───────────────────────────────────────────────────────────────

  List<VocabSetModel> get vocabSets => _vocabSets;

  void _loadVocabSets() {
    _vocabSets = _vocabSetBox.values.toList();
    _vocabSets.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    _rebuildWordSetIndex();
    notifyListeners();
  }

  void _rebuildWordSetIndex() {
    _wordSetIndex.clear();
    for (var set in _vocabSets) {
      for (var word in set.words) {
        _wordSetIndex[word.id] = set.id;
      }
    }
  }

  // ─── CRUD Operations ───────────────────────────────────────────────────────

  VocabSetModel? getSetById(String id) {
    try {
      return _vocabSets.firstWhere((set) => set.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> createVocabSet(String title, List<WordModel> words) async {
    final newSetId = _uuid.v4();
    final stamped = words.map((w) => w.copyWith(setId: newSetId)).toList();
    final newSet = VocabSetModel(
      id: newSetId,
      title: title,
      words: stamped,
      createdAt: DateTime.now(),
    );
    await _vocabSetBox.put(newSet.id, newSet);
    _loadVocabSets();
  }

  Future<void> addSet(VocabSetModel set) async {
    final stamped = set.words.map((w) => w.copyWith(setId: set.id)).toList();
    final stampedSet = set.copyWith(words: stamped);
    await _vocabSetBox.put(stampedSet.id, stampedSet);
    _loadVocabSets();
  }

  Future<void> deleteVocabSet(String setId) async {
    await _vocabSetBox.delete(setId);
    _loadVocabSets();
  }

  Future<void> updateVocabSet(VocabSetModel updatedSet) async {
    await _vocabSetBox.put(updatedSet.id, updatedSet);
    _loadVocabSets();
  }

  // ─── Optimized Word Updates ────────────────────────────────────────────────

  Future<void> updateWordStats(String wordId, {bool isCorrect = true}) async {
    final setId = _wordSetIndex[wordId];
    if (setId == null) return;

    final set = getSetById(setId);
    if (set == null) return;

    final index = set.words.indexWhere((w) => w.id == wordId);
    if (index == -1) return;

    final oldWord = set.words[index];
    bool willBeDifficult = oldWord.isDifficult;
    
    if (isCorrect) {
      // Automatic Exit Logic: mastered after 5 total correct answers
      final newCorrectCount = oldWord.correctAnswersCount + 1;
      if (newCorrectCount >= 5) {
        willBeDifficult = false;
      }
    } else {
      // Entry Logic: becomes difficult after at least 2 mistakes
      final newWrongCount = oldWord.wrongAttempts + 1;
      if (newWrongCount >= 2) {
        willBeDifficult = true;
      }
    }

    final updatedWord = oldWord.copyWith(
      correctAnswersCount: isCorrect ? oldWord.correctAnswersCount + 1 : oldWord.correctAnswersCount,
      wrongAttempts: isCorrect ? oldWord.wrongAttempts : oldWord.wrongAttempts + 1,
      isDifficult: willBeDifficult,
      lastTestedAt: DateTime.now(),
    );

    final updatedWords = List<WordModel>.from(set.words);
    updatedWords[index] = updatedWord;
    await updateVocabSet(set.copyWith(words: updatedWords));
  }

  Future<void> resetWordDifficultStatus(String wordId) async {
    await updateWordStats(wordId, isCorrect: true);
  }

  // ─── Query Helpers ─────────────────────────────────────────────────────────

  List<String> getAllTranslations() {
    return _vocabSets
        .expand((s) => s.words)
        .map((w) => w.translation.trim())
        .toSet()
        .toList();
  }

  List<WordModel> getDifficultWords() {
    return _vocabSets
        .expand((s) => s.words)
        .where((w) => w.isDifficult)
        .toList();
  }

  /// Groups all difficult words into virtual sets of 15 words each.
  List<VocabSetModel> getDifficultVirtualSets() {
    final allDifficult = getDifficultWords();
    if (allDifficult.isEmpty) return [];

    final List<VocabSetModel> virtualSets = [];
    const int groupSize = 15;

    for (int i = 0; i < allDifficult.length; i += groupSize) {
      final end = (i + groupSize < allDifficult.length) ? i + groupSize : allDifficult.length;
      final group = allDifficult.sublist(i, end);
      
      virtualSets.add(VocabSetModel(
        id: 'difficult-group-${i ~/ groupSize}',
        title: 'Difficult Words #${(i ~/ groupSize) + 1}',
        words: group,
        createdAt: DateTime.now(),
      ));
    }

    return virtualSets;
  }
}
