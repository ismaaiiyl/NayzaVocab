import 'package:flutter/material.dart';
import 'package:nayza_vocab/features/vocabulary/domain/entities/matching_item.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/quiz/widgets/matching_tile.dart';

class MatchingGrid extends StatelessWidget {
  final List<MatchingItem> items;
  final MatchingItem? correctSelection;
  final MatchingItem? secondCorrectSelection;
  final MatchingItem? wrongSelection;
  final MatchingItem? secondWrongSelection;
  final ValueChanged<MatchingItem> onTap;

  const MatchingGrid({
    super.key,
    required this.items,
    required this.correctSelection,
    required this.secondCorrectSelection,
    required this.wrongSelection,
    required this.secondWrongSelection,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return MatchingTile(
          item: item,
          isCorrect: item == correctSelection || item == secondCorrectSelection,
          isWrong: item == wrongSelection || item == secondWrongSelection,
          onTap: () => onTap(item),
        );
      },
    );
  }
}
