import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:nayza_vocab/features/vocabulary/domain/entities/word_entity.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocabulary_provider.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: Consumer<VocabularyProvider>(
        builder: (context, provider, child) {
          final allWords = provider.history.values.expand((x) => x).toList();
          if (allWords.isEmpty) {
            return const Center(child: Text('No words added yet.'));
          }
          return GroupedListView<WordEntity, DateTime>(
            elements: allWords,
            groupBy: (word) => DateTime(word.createdAt.year, word.createdAt.month, word.createdAt.day),
            groupSeparatorBuilder: (DateTime date) => Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                DateFormat.yMMMMd().format(date), // e.g., April 8, 2026
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Theme.of(context).colorScheme.secondary),
              ),
            ),
            itemBuilder: (context, word) {
              return Card(
                child: ListTile(
                  title: Text(word.original, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(word.translation),
                  trailing: Text('Mistakes: ${word.wrongAttempts}', style: TextStyle(color: word.wrongAttempts > 0 ? Colors.redAccent : Colors.green)),
                ),
              );
            },
            order: GroupedListOrder.DESC,
          );
        },
      ),
    );
  }
}
