import 'package:equatable/equatable.dart';

class WordEntity extends Equatable {
  final String id;
  final String original;
  final String translation;
  final DateTime createdAt;
  final bool isLearned;
  final int wrongAttempts;

  const WordEntity({
    required this.id,
    required this.original,
    required this.translation,
    required this.createdAt,
    this.isLearned = false,
    this.wrongAttempts = 0,
  });

  @override
  List<Object?> get props => [id, original, translation, createdAt, isLearned, wrongAttempts];
}
