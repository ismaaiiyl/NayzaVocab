import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/vocab_set_model.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/word_model.dart';
import 'package:uuid/uuid.dart';

import 'package:nayza_vocab/features/vocabulary/data/models/folder_model.dart';

/// Senior-level VocabSetProvider (Data Repository).
///
/// Handles persistent storage operations and provides a clean interface
/// for managing vocab sets, folders and words.
class VocabSetProvider with ChangeNotifier {
  final Box<VocabSetModel> _vocabSetBox;
  final Box<FolderModel> _folderBox;
  
  List<VocabSetModel> _vocabSets = [];
  List<FolderModel> _folders = [];
  
  final Uuid _uuid = const Uuid();

  // Senior: Cache for performance to avoid O(N) calculations in build methods
  List<WordModel>? _cachedDifficultWords;
  List<VocabSetModel>? _cachedDifficultVirtualSets;

  VocabSetProvider(this._vocabSetBox, this._folderBox) {
    _loadData();
  }

  // ─── Getters ───────────────────────────────────────────────────────────────

  List<VocabSetModel> get vocabSets => _vocabSets;
  List<FolderModel> get folders => _folders;

  void _loadData() {
    _vocabSets = _vocabSetBox.values.toList();
    _vocabSets.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    _folders = _folderBox.values.toList();
    _folders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    _clearCache();
    notifyListeners();
  }

  void _clearCache() {
    _cachedDifficultWords = null;
    _cachedDifficultVirtualSets = null;
  }

  // ─── CRUD Operations ───────────────────────────────────────────────────────

  VocabSetModel? getSetById(String id) {
    try {
      return _vocabSets.firstWhere((set) => set.id == id);
    } catch (_) {
      return null;
    }
  }

  List<VocabSetModel> getSetsByFolder(String? folderId) {
    if (folderId == 'difficult') {
      return getDifficultVirtualSets();
    }
    if (folderId == 'uncategorized') {
      return _vocabSets.where((set) => set.folderId == null).toList();
    }
    return _vocabSets.where((set) => set.folderId == folderId).toList();
  }

  FolderModel? getFolderById(String id) {
    try {
      return _folders.firstWhere((f) => f.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> createVocabSet(String title, List<WordModel> words, {String? folderId}) async {
    final newSetId = _uuid.v4();
    final stamped = words.map((w) => w.copyWith(setId: newSetId)).toList();
    final newSet = VocabSetModel(
      id: newSetId,
      title: title,
      words: stamped,
      createdAt: DateTime.now(),
      folderId: folderId,
    );
    await _vocabSetBox.put(newSet.id, newSet);
    _loadData();
  }

  Future<void> createFolder(String title) async {
    final folder = FolderModel(
      id: _uuid.v4(),
      title: title,
      createdAt: DateTime.now(),
    );
    await _folderBox.put(folder.id, folder);
    _loadData();
  }

  Future<void> renameFolder(String id, String newTitle) async {
    final folder = getFolderById(id);
    if (folder != null) {
      folder.title = newTitle;
      await folder.save();
      _loadData();
    }
  }

  Future<void> deleteFolder(String id) async {
    // Senior: User specifically wants to delete EVERYTHING inside the folder
    final setsInFolder = getSetsByFolder(id);
    for (var set in setsInFolder) {
      await _vocabSetBox.delete(set.id);
    }
    await _folderBox.delete(id);
    _loadData();
  }

  Future<void> addSet(VocabSetModel set) async {
    final stamped = set.words.map((w) => w.copyWith(setId: set.id)).toList();
    final stampedSet = set.copyWith(words: stamped);
    await _vocabSetBox.put(stampedSet.id, stampedSet);
    await _vocabSetBox.put(stampedSet.id, stampedSet);
    _loadData();
  }

  Future<void> deleteVocabSet(String setId) async {
    await _vocabSetBox.delete(setId);
    _loadData();
  }

  Future<void> updateVocabSet(VocabSetModel updatedSet) async {
    await _vocabSetBox.put(updatedSet.id, updatedSet);
    _loadData();
  }

  // ─── Optimized Word Updates ────────────────────────────────────────────────

  Future<void> updateWordStats(WordModel word, {bool isCorrect = true}) async {
    final setId = word.setId;
    if (setId.isEmpty) return;

    final set = getSetById(setId);
    if (set == null) return;

    final index = set.words.indexWhere((w) => w.id == word.id);
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
    
    final updatedSet = set.copyWith(words: updatedWords);
    await _vocabSetBox.put(updatedSet.id, updatedSet);
    
    // O(1) in-memory update instead of _loadVocabSets() full rebuild
    final setIndex = _vocabSets.indexWhere((s) => s.id == updatedSet.id);
    if (setIndex != -1) {
      _vocabSets[setIndex] = updatedSet;
    }
    _clearCache();
    notifyListeners();
  }

  Future<void> resetWordDifficultStatus(WordModel word) async {
    await updateWordStats(word, isCorrect: true);
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
    return _cachedDifficultWords ??= _vocabSets
        .expand((s) => s.words)
        .where((w) => w.isDifficult)
        .toList();
  }

  /// Groups all difficult words into virtual sets of 15 words each.
  List<VocabSetModel> getDifficultVirtualSets() {
    if (_cachedDifficultVirtualSets != null) return _cachedDifficultVirtualSets!;

    final allDifficult = getDifficultWords();
    if (allDifficult.isEmpty) return [];

    final List<VocabSetModel> virtualSets = [];
    const int groupSize = 15;

    for (int i = 0; i < allDifficult.length; i += groupSize) {
      final end = (i + groupSize < allDifficult.length) ? i + groupSize : allDifficult.length;
      final group = allDifficult.sublist(i, end);
      
      virtualSets.add(VocabSetModel(
        id: 'difficult-group-${i ~/ groupSize}',
        title: '', 
        words: group,
        createdAt: DateTime.now(),
      ));
    }

    return _cachedDifficultVirtualSets = virtualSets;
  }

  Future<void> importData(List<VocabSetModel> sets, List<dynamic> foldersJson) async {
    // 1. Save folders
    for (var fJson in foldersJson) {
      final Map<String, dynamic> fMap = Map<String, dynamic>.from(fJson as Map<dynamic, dynamic>);
      final folder = FolderModel.fromMap(fMap);
      await _folderBox.put(folder.id, folder);
    }

    // 2. Save sets
    for (var set in sets) {
      await _vocabSetBox.put(set.id, set);
    }

    _loadData();
  }

  Future<void> clearAllData() async {
    await _vocabSetBox.clear();
    await _folderBox.clear();
    _loadData();
  }
}
