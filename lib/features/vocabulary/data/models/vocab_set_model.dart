import 'package:hive/hive.dart';

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

  VocabSetModel({
    required this.id,
    required this.title,
    required this.words,
    required this.createdAt,
  });
}

@HiveType(typeId: 1)
class WordModel extends HiveObject {
  @HiveField(0)
  final String original;

  @HiveField(1)
  final String translation;

  @HiveField(2)
  final String? langCode; // Made optional

  WordModel({
    required this.original,
    required this.translation,
    this.langCode = 'en', // Provide a default value
  });

  // copyWith Method for easy updates
  WordModel copyWith({
    String? original,
    String? translation,
    String? langCode,
  }) {
    return WordModel(
      original: original ?? this.original,
      translation: translation ?? this.translation,
      langCode: langCode ?? this.langCode,
    );
  }
}
