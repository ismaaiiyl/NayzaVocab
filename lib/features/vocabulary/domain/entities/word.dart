class Word {
  final String id;
  final String word;
  final String translation;
  final String? example;
  final DateTime addedAt;

  Word({
    required this.id,
    required this.word,
    required this.translation,
    this.example,
    required this.addedAt,
  });
}
