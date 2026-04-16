import 'package:flutter/foundation.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/word_model.dart';

class QuizProvider with ChangeNotifier {
  // Training Session State
  final List<WordModel> _trainingList = [];
  final List<WordModel> _failedQueue = [];
  int _correctCount = 0;
  int _incorrectCount = 0;

  // Getters
  List<WordModel> get trainingList => _trainingList;
  List<WordModel> get failedQueue => _failedQueue;
  int get correctCount => _correctCount;
  int get incorrectCount => _incorrectCount;

  void prepareSession(List<WordModel> words) {
    _trainingList.clear();
    _trainingList.addAll(words);
    _trainingList.shuffle();
    _failedQueue.clear();
    _correctCount = 0;
    _incorrectCount = 0;
    notifyListeners();
  }

  void prepareDifficultSession(List<WordModel> difficultWords) {
    prepareSession(difficultWords);
  }

  void startSession(List<WordModel> words) {
    prepareSession(words);
  }

  void markCorrect() {
    _correctCount++;
    notifyListeners();
  }

  void markIncorrect(WordModel word) {
    _incorrectCount++;
    if (!_failedQueue.any((w) => w.id == word.id)) {
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

  void restartFullSession() {
    _failedQueue.clear();
    _correctCount = 0;
    _incorrectCount = 0;
    _trainingList.shuffle();
    notifyListeners();
  }

  void resetSession() {
    _trainingList.clear();
    _failedQueue.clear();
    _correctCount = 0;
    _incorrectCount = 0;
    notifyListeners();
  }
}
