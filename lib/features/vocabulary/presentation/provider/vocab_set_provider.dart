import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/vocab_set_model.dart';
import 'package:uuid/uuid.dart';

class VocabSetProvider extends ChangeNotifier {
  final Box<VocabSetModel> _vocabSetBox;
  List<VocabSetModel> _vocabSets = [];

  VocabSetProvider() : _vocabSetBox = Hive.box<VocabSetModel>('vocab_sets') {
    fetchVocabSets();
  }

  List<VocabSetModel> get vocabSets => _vocabSets;

  // Add a new vocabulary set
  Future<void> addVocabSet(String title, List<WordModel> words) async {
    final newSet = VocabSetModel(
      id: const Uuid().v4(),
      title: title,
      createdAt: DateTime.now(),
      words: words,
    );
    await _vocabSetBox.put(newSet.id, newSet);
    fetchVocabSets();
  }

  // Fetch all vocabulary sets
  void fetchVocabSets() {
    _vocabSets = _vocabSetBox.values.toList();
    // Sort by most recent
    _vocabSets.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    notifyListeners();
  }

  // Get a specific set by ID
  VocabSetModel? getSetById(String id) {
    return _vocabSetBox.get(id);
  }

  // Update a vocabulary set
  Future<void> updateVocabSet(String id, String newTitle, List<WordModel> newWords) async {
    final set = _vocabSetBox.get(id);
    if (set != null) {
      set.title = newTitle;
      set.words = newWords;
      await set.save();
      fetchVocabSets();
    }
  }

  // Delete a vocabulary set
  Future<void> deleteVocabSet(String id) async {
    await _vocabSetBox.delete(id);
    fetchVocabSets();
  }

  // Add a word to an existing set
  Future<void> addWordToSet(String setId, WordModel word) async {
    final set = _vocabSetBox.get(setId);
    if (set != null) {
      set.words.add(word);
      await set.save();
      fetchVocabSets();
    }
  }

  // Update a word within a set
  Future<void> updateWordInSet(String setId, int wordIndex, WordModel updatedWord) async {
    final set = _vocabSetBox.get(setId);
    if (set != null && wordIndex < set.words.length) {
      set.words[wordIndex] = updatedWord;
      await set.save();
      fetchVocabSets();
    }
  }

  // Delete a word from a set
  Future<void> deleteWordFromSet(String setId, int wordIndex) async {
    final set = _vocabSetBox.get(setId);
    if (set != null && wordIndex < set.words.length) {
      set.words.removeAt(wordIndex);
      await set.save();
      fetchVocabSets();
    }
  }
}
