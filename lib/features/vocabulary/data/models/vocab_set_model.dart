import 'package:hive/hive.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/word_model.dart';

part 'vocab_set_model.g.dart';

@HiveType(typeId: 0)
class VocabSetModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  final List<WordModel> words;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final String? folderId;

  VocabSetModel({
    required this.id,
    required this.title,
    required this.words,
    required this.createdAt,
    this.folderId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'words': words.map((w) => w.toMap()).toList(),
      'folderId': folderId,
    };
  }

  VocabSetModel copyWith({
    String? id,
    String? title,
    List<WordModel>? words,
    DateTime? createdAt,
    String? folderId,
  }) {
    return VocabSetModel(
      id: id ?? this.id,
      title: title ?? this.title,
      words: words ?? this.words,
      createdAt: createdAt ?? this.createdAt,
      folderId: folderId ?? this.folderId,
    );
  }

  factory VocabSetModel.fromMap(Map<String, dynamic> map) {
    return VocabSetModel(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? 'Untitled Set',
      folderId: map['folderId'] as String?,
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt'] as String) 
          : DateTime.now(),
      words: (map['words'] as List? ?? [])
          .map((dynamic w) => WordModel.fromMap(w as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Senior-level logic: Number of words considered "Mastered" (Learned)
  int get learnedWordsCount => words.where((w) => w.isLearned).length;

  /// Progress: 100% when all words have been answered correctly at least once.
  double get progressPercentage {
    if (words.isEmpty) return 0.0;
    final learnedCount = words.where((w) => w.isLearned).length;
    return (learnedCount / words.length) * 100;
  }
}
