
import 'package:hive/hive.dart';
import 'package:nayza_vocab/features/vocabulary/domain/entities/word_entity.dart';
import 'package:uuid/uuid.dart';

part 'word_model.g.dart';

@HiveType(typeId: 0)
class WordModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String original;

  @HiveField(2)
  final String translation;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  bool isLearned;

  @HiveField(5)
  int wrongAttempts;

  WordModel({
    required this.id,
    required this.original,
    required this.translation,
    required this.createdAt,
    this.isLearned = false,
    this.wrongAttempts = 0,
  });

  factory WordModel.fromEntity(WordEntity entity) {
    return WordModel(
      id: entity.id,
      original: entity.original,
      translation: entity.translation,
      createdAt: entity.createdAt,
      isLearned: entity.isLearned,
      wrongAttempts: entity.wrongAttempts,
    );
  }

  WordEntity toEntity() {
    return WordEntity(
      id: id,
      original: original,
      translation: translation,
      createdAt: createdAt,
      isLearned: isLearned,
      wrongAttempts: wrongAttempts,
    );
  }
  
    factory WordModel.create({
    required String original,
    required String translation,
  }) {
    return WordModel(
      id: const Uuid().v4(),
      original: original,
      translation: translation,
      createdAt: DateTime.now(),
    );
  }
}
