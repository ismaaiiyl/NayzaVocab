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

  // Training Session Data
  final List<WordModel> _trainingList = [];
  final List<WordModel> _failedQueue = [];
  int _correctCount = 0;
  int _incorrectCount = 0;

  List<WordModel> get trainingList => _trainingList;
  List<WordModel> get failedQueue => _failedQueue;
  int get correctCount => _correctCount;
  int get incorrectCount => _incorrectCount;

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

  Future<void> deleteVocabSet(String setId) async {
    await _vocabSetBox.delete(setId);
    _loadVocabSets();
  }

  Future<void> updateVocabSet(VocabSetModel updatedSet) async {
    await _vocabSetBox.put(updatedSet.id, updatedSet);
    _loadVocabSets();
  }

  // --- Training Logic ---

  void prepareTrainingSession(Set<String> setIds) {
    _trainingList.clear();
    _failedQueue.clear();
    _correctCount = 0;
    _incorrectCount = 0;

    for (var setId in setIds) {
      final set = getSetById(setId);
      if (set != null) {
        _trainingList.addAll(set.words);
      }
    }
    _trainingList.shuffle();
    notifyListeners();
  }

  void markCorrect(WordModel word) {
    _correctCount++;
    notifyListeners();
  }

  void markIncorrect(WordModel word) {
    _incorrectCount++;
    if (!_failedQueue.contains(word)) {
      _failedQueue.add(word);
    }
    notifyListeners();
  }

  void retryFailedWords() {
    _trainingList.clear();
    _trainingList.addAll(_failedQueue);
    _trainingList.shuffle();
    _failedQueue.clear();
    notifyListeners();
  }
}
