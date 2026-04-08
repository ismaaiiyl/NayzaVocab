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

  VocabSetModel({
    required this.id,
    required this.title,
    required this.words,
    required this.createdAt,
  });
}
