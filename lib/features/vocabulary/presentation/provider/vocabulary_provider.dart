import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/word_model.dart';
import 'package:nayza_vocab/features/vocabulary/domain/entities/word_entity.dart';
import 'dart:math';

class VocabularyProvider extends ChangeNotifier {
  final Box<WordModel> _wordBox;
  Map<DateTime, List<WordEntity>> _history = {};

  List<WordEntity> _trainingList = [];
  List<WordEntity> _missedWords = [];

  VocabularyProvider() : _wordBox = Hive.box<WordModel>('words') {
    fetchHistory();
  }

  Map<DateTime, List<WordEntity>> get history => _history;
  List<WordEntity> get trainingList => _trainingList;
  List<WordEntity> get missedWords => _missedWords;

  // Function to add a new word
  Future<void> addWord(String original, String translation) async {
    final newWord = WordModel.create(original: original, translation: translation);
    await _wordBox.put(newWord.id, newWord);
    fetchHistory(); // Refresh history after adding
  }

  // Function to fetch and group words by date
  void fetchHistory() {
    final allWords = _wordBox.values.map((model) => model.toEntity()).toList();
    allWords.sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Sort by most recent

    final Map<DateTime, List<WordEntity>> grouped = {};
    for (var word in allWords) {
      final dateKey = DateTime(word.createdAt.year, word.createdAt.month, word.createdAt.day);
      if (grouped[dateKey] == null) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(word);
    }
    _history = grouped;
    notifyListeners();
  }

  // Function to get a random list of words for training
  void getTrainingList(int count) {
    final allWords = _wordBox.values.toList();
    allWords.shuffle();
    _trainingList = allWords.take(min(count, allWords.length)).map((m) => m.toEntity()).toList();
    _missedWords = []; // Reset missed words for new session
    notifyListeners();
  }

    void retryMissedWords() {
    _trainingList = List<WordEntity>.from(_missedWords);
    _missedWords = [];
    notifyListeners();
  }


  // Function to update word progress after a training answer
  Future<void> updateProgress(String id, bool isCorrect) async {
    final wordModel = _wordBox.get(id);
    if (wordModel != null) {
      if (!isCorrect) {
        wordModel.wrongAttempts++;
        // Add to missed words only if it's not already there
        if (!_missedWords.any((element) => element.id == id)) {
          _missedWords.add(wordModel.toEntity());
        }
      } else {
        wordModel.isLearned = true; 
      }
      await wordModel.save();
      notifyListeners();
    }
  }
}
