import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/folder_model.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/vocab_set_model.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/word_model.dart';
import 'package:nayza_vocab/features/vocabulary/domain/services/word_mastery_calculator.dart';
import 'package:uuid/uuid.dart';

class VocabSetProvider with ChangeNotifier {
  final Box<VocabSetModel> _vocabSetBox;
  final Box<FolderModel> _folderBox;

  List<VocabSetModel> _vocabSets = [];
  List<FolderModel> _folders = [];

  final Uuid _uuid = const Uuid();

  List<WordModel>? _cachedDifficultWords;
  List<VocabSetModel>? _cachedDifficultVirtualSets;

  VocabSetProvider(this._vocabSetBox, this._folderBox) {
    _loadData();
  }

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

  VocabSetModel? getSetById(String id) {
    try {
      return _vocabSets.firstWhere((set) => set.id == id);
    } catch (_) {
      return null;
    }
  }

  List<VocabSetModel> getSetsByFolder(String? folderId) {
    if (folderId == 'difficult') return getDifficultVirtualSets();
    if (folderId == 'uncategorized') return _vocabSets.where((s) => s.folderId == null).toList();
    return _vocabSets.where((s) => s.folderId == folderId).toList();
  }

  FolderModel? getFolderById(String id) {
    return _folders.where((f) => f.id == id).firstOrNull;
  }

  Future<void> createVocabSet(
    String title,
    List<WordModel> words, {
    String? folderId,
  }) async {
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
    if (folder == null) return;
    folder.title = newTitle;
    await folder.save();
    _loadData();
  }

  Future<void> deleteFolder(String id) async {
    for (var set in getSetsByFolder(id)) {
      await _vocabSetBox.delete(set.id);
    }
    await _folderBox.delete(id);
    _loadData();
  }

  Future<void> addSet(VocabSetModel set) async {
    final stamped = set.words.map((w) => w.copyWith(setId: set.id)).toList();
    await _vocabSetBox.put(set.id, set.copyWith(words: stamped));
    _loadData();
  }

  Future<void> deleteVocabSet(String setId) async {
    await _vocabSetBox.delete(setId);
    _loadData();
  }

  Future<void> updateVocabSet(VocabSetModel updatedSet) async {
    await _vocabSetBox.put(updatedSet.id, updatedSet);
    final setIndex = _vocabSets.indexWhere((s) => s.id == updatedSet.id);
    if (setIndex != -1) _vocabSets[setIndex] = updatedSet;
    _clearCache();
    notifyListeners();
  }

  Future<void> updateWordStats(WordModel word, {bool isCorrect = true}) async {
    final set = getSetById(word.setId);
    if (set == null) return;
    final index = set.words.indexWhere((w) => w.id == word.id);
    if (index == -1) return;

    final updatedWords = List<WordModel>.from(set.words);
    updatedWords[index] = WordMasteryCalculator.calculateUpdatedStats(
      set.words[index],
      isCorrect: isCorrect,
    );
    await updateVocabSet(set.copyWith(words: updatedWords));
  }

  Future<void> resetWordDifficultStatus(WordModel word) async {
    final set = getSetById(word.setId);
    if (set == null) return;
    final index = set.words.indexWhere((w) => w.id == word.id);
    if (index == -1) return;

    final updatedWords = List<WordModel>.from(set.words);
    updatedWords[index] = set.words[index].copyWith(
      isDifficult: false,
      wrongAttempts: 0,
      lastTestedAt: DateTime.now(),
    );
    await updateVocabSet(set.copyWith(words: updatedWords));
  }

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

  List<VocabSetModel> getDifficultVirtualSets() {
    if (_cachedDifficultVirtualSets != null) {
      return _cachedDifficultVirtualSets!;
    }
    final allDifficult = getDifficultWords();
    return _cachedDifficultVirtualSets =
        WordMasteryCalculator.groupIntoVirtualSets(allDifficult);
  }

  Future<void> importData(List<VocabSetModel> sets, List<dynamic> foldersJson) async {
    for (var f in foldersJson) {
      await _folderBox.put(f['id'], FolderModel.fromMap(Map<String, dynamic>.from(f as Map)));
    }
    for (var s in sets) {
      await _vocabSetBox.put(s.id, s);
    }
    _loadData();
  }

  Future<void> clearAllData() async {
    await _vocabSetBox.clear();
    await _folderBox.clear();
    _loadData();
  }
}
