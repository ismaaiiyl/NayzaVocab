import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/vocab_set_model.dart';
import 'package:uuid/uuid.dart';

class VocabSetProvider with ChangeNotifier {
  final Box<VocabSetModel> _vocabSetBox;
  List<VocabSetModel> _vocabSets = [];
  final Uuid _uuid = const Uuid();

  List<VocabSetModel> get vocabSets => _vocabSets;

  VocabSetProvider(this._vocabSetBox) {
    _loadVocabSets();
  }

  void _loadVocabSets() {
    _vocabSets = _vocabSetBox.values.toList();
    // Optional: Sort sets by date, newest first
    _vocabSets.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    notifyListeners();
  }

  Future<void> createVocabSet(String title, List<WordModel> words) async {
    final newSet = VocabSetModel(
      id: _uuid.v4(),
      title: title,
      words: words,
      createdAt: DateTime.now(),
    );
    await _vocabSetBox.put(newSet.id, newSet);
    _loadVocabSets(); // Reload and notify
  }

  VocabSetModel? getSetById(String id) {
    try {
      return _vocabSets.firstWhere((set) => set.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteWordFromSet(String setId, int wordIndex) async {
    final set = _vocabSetBox.get(setId);
    if (set != null && wordIndex >= 0 && wordIndex < set.words.length) {
      set.words.removeAt(wordIndex);
      await _vocabSetBox.put(setId, set);
      _loadVocabSets(); // Reload and notify
    }
  }

  Future<void> addWordToSet(String setId, WordModel newWord) async {
    final set = _vocabSetBox.get(setId);
    if (set != null) {
      set.words.add(newWord);
      await _vocabSetBox.put(setId, set);
      _loadVocabSets(); // Reload and notify
    }
  }

  Future<void> updateWordInSet(
      String setId, int wordIndex, WordModel updatedWord) async {
    final set = _vocabSetBox.get(setId);
    if (set != null && wordIndex >= 0 && wordIndex < set.words.length) {
      set.words[wordIndex] = updatedWord;
      await _vocabSetBox.put(setId, set);
      _loadVocabSets(); // Reload and notify
    }
  }
}
