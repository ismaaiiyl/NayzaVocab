class MatchingItem {
  final String text;
  final String pairId;
  final bool isOriginal;
  bool isMatched;
  bool isSelected;

  MatchingItem({
    required this.text,
    required this.pairId,
    required this.isOriginal,
    this.isMatched = false,
    this.isSelected = false,
  });
}
