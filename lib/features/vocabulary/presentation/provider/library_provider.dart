import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/vocab_set_model.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/word_model.dart';
import 'package:uuid/uuid.dart';

class LibraryProvider with ChangeNotifier {
  final _supabase = Supabase.instance.client;
  
  List<Map<String, dynamic>> _books = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  String? _selectedLang;
  String? _selectedCategory;
  
  // Yuklanayotgan unitlar ID-larini saqlaymiz
  final Set<String> _downloadingUnits = {};

  List<Map<String, dynamic>> get books => _books.where((book) {
    final matchesSearch = book['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
    final matchesLang = _selectedLang == null || book['target_lang'] == _selectedLang;
    final matchesCategory = _selectedCategory == null || book['category'] == _selectedCategory;
    return matchesSearch && matchesLang && matchesCategory;
  }).toList();

  List<String> get categories {
    final cats = _books.map((b) => b['category']?.toString()).whereType<String>().toSet().toList();
    return cats;
  }

  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  String? get selectedLang => _selectedLang;
  String? get selectedCategory => _selectedCategory;
  bool isUnitDownloading(String unitId) => _downloadingUnits.contains(unitId);

  void setSelectedCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void _setUnitDownloading(String unitId, bool value) {
    if (value) {
      _downloadingUnits.add(unitId);
    } else {
      _downloadingUnits.remove(unitId);
    }
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedLang(String? lang) {
    _selectedLang = lang;
    notifyListeners();
  }

  Future<void> fetchBooks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _supabase
          .from('books')
          .select('*, units(id)')
          .order('created_at', ascending: false);
      
      _books = List<Map<String, dynamic>>.from(response).map((book) {
        int count = 0;
        if (book['units'] != null && book['units'] is List) {
          count = (book['units'] as List).length;
        }
        return {
          ...book,
          'unitsCount': count,
        };
      }).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Kitobga tegishli unitlarni olish va so'zlar sonini hisoblash
  Future<List<Map<String, dynamic>>> fetchUnits(String bookId) async {
    try {
      // 'count' bilan birga select qilyapmiz (Relationship mavjud bo'lishi kerak)
      final response = await _supabase
          .from('units')
          .select('*, words(count)')
          .eq('book_id', bookId)
          .order('index', ascending: true);
      
      return List<Map<String, dynamic>>.from(response).map((unit) {
        // Supabase words count formatini to'g'irlaymiz
        final count = (unit['words'] as List).isNotEmpty 
            ? (unit['words'][0]['count'] ?? 0) 
            : 0;
        return {
          ...unit,
          'wordCount': count,
        };
      }).toList();
    } catch (e) {
      return [];
    }
  }

  /// Unit ichidagi so'zlarni yuklab olish va VocabSetModel-ga o'tkazish
  Future<VocabSetModel?> downloadUnitAsSet(Map<String, dynamic> unitData) async {
    final unitId = unitData['id'].toString();
    _setUnitDownloading(unitId, true);
    
    try {
      final wordsResponse = await _supabase
          .from('words')
          .select()
          .eq('unit_id', unitId);
      
      final wordsList = List<Map<String, dynamic>>.from(wordsResponse);
      final newSetId = const Uuid().v4();

      final words = wordsList.map((w) => WordModel(
        id: const Uuid().v4(),
        original: (w['original'] as String?) ?? '',
        translation: (w['translation'] as String?) ?? '',
        setId: newSetId,
        isDifficult: false,
        wrongAttempts: 0,
        correctAnswersCount: 0,
      )).toList();

      return VocabSetModel(
        id: newSetId,
        title: (unitData['title'] as String?) ?? '',
        words: words,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      debugPrint('Error downloading unit: $e');
      return null;
    } finally {
      _setUnitDownloading(unitId, false);
    }
  }
}
