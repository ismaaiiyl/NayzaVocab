import 'package:hive/hive.dart';

part 'vocab_set_model.g.dart';

@HiveType(typeId: 1)
class VocabSetModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late DateTime createdAt;

  @HiveField(3)
  late List<WordModel> words;

  VocabSetModel({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.words,
  });
}

@HiveType(typeId: 2)
class WordModel extends HiveObject {
  @HiveField(0)
  late String original;

  @HiveField(1)
  late String translation;

  @HiveField(2)
  late String langCode;

  @HiveField(3)
  bool isLearned;

  @HiveField(4)
  int wrongAttempts;

  WordModel({
    required this.original,
    required this.translation,
    required this.langCode,
    this.isLearned = false,
    this.wrongAttempts = 0,
  });
}
