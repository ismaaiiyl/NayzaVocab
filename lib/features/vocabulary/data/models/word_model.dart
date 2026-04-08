import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'word_model.g.dart';

@HiveType(typeId: 1)
class WordModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String original;

  @HiveField(2)
  final String translation;

  @HiveField(3)
  final String? langCode;

  @HiveField(4)
  final bool isLearned;

  @HiveField(5)
  final int wrongAttempts;

  WordModel({
    required this.id,
    required this.original,
    required this.translation,
    this.langCode = 'en',
    this.isLearned = false,
    this.wrongAttempts = 0,
  });

  WordModel copyWith({
    String? id,
    String? original,
    String? translation,
    String? langCode,
    bool? isLearned,
    int? wrongAttempts,
  }) {
    return WordModel(
      id: id ?? this.id,
      original: original ?? this.original,
      translation: translation ?? this.translation,
      langCode: langCode ?? this.langCode,
      isLearned: isLearned ?? this.isLearned,
      wrongAttempts: wrongAttempts ?? this.wrongAttempts,
    );
  }
}
