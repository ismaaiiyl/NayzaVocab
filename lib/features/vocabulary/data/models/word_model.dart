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

  WordModel({
    required this.id,
    required this.original,
    required this.translation,
    this.langCode = 'en',
  });

  WordModel copyWith({
    String? id,
    String? original,
    String? translation,
    String? langCode,
  }) {
    return WordModel(
      id: id ?? this.id,
      original: original ?? this.original,
      translation: translation ?? this.translation,
      langCode: langCode ?? this.langCode,
    );
  }
}
