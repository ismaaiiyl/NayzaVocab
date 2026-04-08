import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/word_model.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/widgets/add_edit_word_dialog.dart';
import 'package:provider/provider.dart';

class SetDetailsScreen extends StatefulWidget {
  final String setId;
  const SetDetailsScreen({super.key, required this.setId});

  @override
  State<SetDetailsScreen> createState() => _SetDetailsScreenState();
}

class _SetDetailsScreenState extends State<SetDetailsScreen> {
  void _showAddEditWordDialog({WordModel? existingWord, int? wordIndex}) async {
    final vocabSetProvider = Provider.of<VocabSetProvider>(context, listen: false);

    final newWord = await showDialog<WordModel>(
      context: context,
      builder: (context) => AddEditWordDialog(word: existingWord),
    );

    if (newWord != null) {
      if (existingWord != null && wordIndex != null) {
        // This is an edit
        vocabSetProvider.updateWordInSet(widget.setId, wordIndex, newWord);
      } else {
        // This is a new word
        vocabSetProvider.addWordToSet(widget.setId, newWord); // <<< TYPO FIX
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<VocabSetProvider>(
          builder: (context, provider, child) {
            final set = provider.getSetById(widget.setId);
            return Text(set?.title ?? 'Set Details');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.plus, size: 24),
            onPressed: () => _showAddEditWordDialog(),
            tooltip: 'Add Word',
          )
        ],
      ),
      body: Consumer<VocabSetProvider>(
        builder: (context, provider, child) {
          final set = provider.getSetById(widget.setId);
          if (set == null) {
            return const Center(child: Text('Set not found.'));
          }
          if (set.words.isEmpty) {
            return const Center(
              child: Text(
                'This set is empty. Tap the + icon to add words.',
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            itemCount: set.words.length,
            itemBuilder: (context, index) {
              final word = set.words[index];
              return ListTile(
                title: Text(word.original),
                subtitle: Text(word.translation),
                trailing: IconButton(
                  icon: const Icon(LucideIcons.trash2, color: Colors.redAccent),
                  onPressed: () => provider.deleteWordFromSet(widget.setId, index),
                ),
                onTap: () => _showAddEditWordDialog(existingWord: word, wordIndex: index),
              );
            },
          );
        },
      ),
    );
  }
}
