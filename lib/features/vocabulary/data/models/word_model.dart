import 'package:hive/hive.dart';

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
  final bool isDifficult;

  @HiveField(5)
  final int wrongAttempts;

  @HiveField(6)
  final int correctAnswersCount;

  @HiveField(7)
  final DateTime? lastTestedAt;

  /// [HiveField 8] — Parent set ID for O(1) lookup.
  /// Enables markCorrect/markIncorrect to find the parent set directly
  /// without scanning all sets (eliminates O(N×M) loop).
  @HiveField(8)
  final String setId;

  WordModel({
    required this.id,
    required this.original,
    required this.translation,
    this.langCode = 'en',
    this.isDifficult = false,
    this.wrongAttempts = 0,
    this.correctAnswersCount = 0,
    this.lastTestedAt,
    this.setId = '',
  });

  /// A word is considered learned once correctly answered at least once AND not marked difficult.
  bool get isLearned => correctAnswersCount >= 1 && !isDifficult;

  WordModel copyWith({
    String? id,
    String? original,
    String? translation,
    String? langCode,
    bool? isDifficult,
    int? wrongAttempts,
    int? correctAnswersCount,
    DateTime? lastTestedAt,
    String? setId,
  }) {
    return WordModel(
      id: id ?? this.id,
      original: original ?? this.original,
      translation: translation ?? this.translation,
      langCode: langCode ?? this.langCode,
      isDifficult: isDifficult ?? this.isDifficult,
      wrongAttempts: wrongAttempts ?? this.wrongAttempts,
      correctAnswersCount: correctAnswersCount ?? this.correctAnswersCount,
      lastTestedAt: lastTestedAt ?? this.lastTestedAt,
      setId: setId ?? this.setId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'original': original,
      'translation': translation,
      'langCode': langCode,
      'isDifficult': isDifficult,
      'wrongAttempts': wrongAttempts,
      'correctAnswersCount': correctAnswersCount,
      'lastTestedAt': lastTestedAt?.toIso8601String(),
      'setId': setId,
    };
  }

  factory WordModel.fromMap(Map<String, dynamic> map) {
    return WordModel(
      id: map['id'] as String? ?? '',
      original: map['original'] as String? ?? '',
      translation: map['translation'] as String? ?? '',
      langCode: map['langCode'] as String? ?? 'en',
      isDifficult: map['isDifficult'] as bool? ?? false,
      wrongAttempts: map['wrongAttempts'] as int? ?? 0,
      correctAnswersCount: map['correctAnswersCount'] as int? ?? 0,
      lastTestedAt: map['lastTestedAt'] != null ? DateTime.parse(map['lastTestedAt'] as String) : null,
      setId: map['setId'] as String? ?? '',
    );
  }
}
