import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/vocab_set_model.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/word_model.dart'; // <<< IMPORT ADDED
import 'package:uuid/uuid.dart';

class VocabSetProvider with ChangeNotifier {
  final Box<VocabSetModel> _vocabSetBox;
  List<VocabSetModel> _vocabSets = [];
  final Uuid _uuid = const Uuid();

  List<VocabSetModel> get vocabSets => _vocabSets;

  // For the Quiz/Training
  List<WordModel> _trainingList = [];
  List<WordModel> get trainingList => _trainingList;

  VocabSetProvider(this._vocabSetBox) {
    _loadVocabSets();
  }

  void _loadVocabSets() {
    _vocabSets = _vocabSetBox.values.toList();
    _vocabSets.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    notifyListeners();
  }

  // --- CRUD Operations ---

  Future<void> createVocabSet(String title, List<WordModel> words) async {
    final newSet = VocabSetModel(
      id: _uuid.v4(),
      title: title,
      words: words,
      createdAt: DateTime.now(),
    );
    await _vocabSetBox.put(newSet.id, newSet);
    _loadVocabSets();
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
      _loadVocabSets();
    }
  }

  Future<void> addWordToSet(String setId, WordModel newWord) async {
    final set = _vocabSetBox.get(setId);
    if (set != null) {
      set.words.add(newWord);
      await _vocabSetBox.put(setId, set);
      _loadVocabSets();
    }
  }

  Future<void> updateWordInSet(
      String setId, int wordIndex, WordModel updatedWord) async {
    final set = _vocabSetBox.get(setId);
    if (set != null && wordIndex >= 0 && wordIndex < set.words.length) {
      set.words[wordIndex] = updatedWord;
      await _vocabSetBox.put(setId, set);
      _loadVocabSets();
    }
  }

  // --- Quiz/Training Logic ---

  void prepareTrainingSession(Set<String> setIds) {
    _trainingList.clear();
    for (var setId in setIds) {
      final set = getSetById(setId);
      if (set != null) {
        _trainingList.addAll(set.words);
      }
    }
    _trainingList.shuffle();
    notifyListeners();
  }
}
