import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/vocab_set_model.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:provider/provider.dart';

class SetDetailsScreen extends StatefulWidget {
  final String setId;
  const SetDetailsScreen({super.key, required this.setId});

  @override
  State<SetDetailsScreen> createState() => _SetDetailsScreenState();
}

class _SetDetailsScreenState extends State<SetDetailsScreen> {
  bool _isEditMode = false;

  // --- UNIVERSAL DIALOG FOR ADDING/EDITING WORDS ---
  Future<void> _showEditOrAddWordDialog({
    WordModel? existingWord,
    int? wordIndex,
  }) async {
    final originalController = TextEditingController(text: existingWord?.original);
    final translationController =
        TextEditingController(text: existingWord?.translation);
    final formKey = GlobalKey<FormState>();
    final bool isEditing = existingWord != null;

    final newWord = await showDialog<WordModel>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Word' : 'Add New Word'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: originalController,
                  decoration: const InputDecoration(labelText: 'Original Word'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the original word.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: translationController,
                  decoration: const InputDecoration(labelText: 'Translation'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the translation.';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final word = WordModel(
                    original: originalController.text.trim(),
                    translation: translationController.text.trim(),
                  );
                  Navigator.of(context).pop(word);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (newWord != null) {
      final provider = Provider.of<VocabSetProvider>(context, listen: false);
      if (isEditing && wordIndex != null) {
        provider.updateWordInSet(widget.setId, wordIndex, newWord);
      } else {
        provider.addWordToSet(widget.setId, newWord);
      }
    }
  }

  // --- Helper method to show a confirmation dialog ---
  Future<bool> _showDeleteConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm Deletion'),
            content: const Text('Are you sure you want to delete this word?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false; // Return false if dialog is dismissed
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VocabSetProvider>(
      builder: (context, provider, child) {
        final vocabSet = provider.getSetById(widget.setId);

        if (vocabSet == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: const Center(child: Text('Set not found!')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(vocabSet.title, style: Theme.of(context).textTheme.headlineLarge),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(_isEditMode ? LucideIcons.check : LucideIcons.edit3),
                tooltip: 'Toggle edit mode',
                onPressed: () {
                  setState(() {
                    _isEditMode = !_isEditMode;
                  });
                },
              )
            ],
          ),
          body: ListView.builder(
            itemCount: vocabSet.words.length,
            itemBuilder: (context, index) {
              final word = vocabSet.words[index];
              return Card(
                child: ListTile(
                  title: Text(word.original, style: Theme.of(context).textTheme.titleLarge),
                  subtitle: Text(word.translation, style: Theme.of(context).textTheme.bodyMedium),
                  trailing: _isEditMode
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(LucideIcons.pencil, color: Colors.blueAccent, size: 20),
                              tooltip: 'Edit word',
                              onPressed: () => _showEditOrAddWordDialog(
                                existingWord: word,
                                wordIndex: index,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(LucideIcons.trash2, color: Colors.redAccent, size: 20),
                              tooltip: 'Delete word',
                              onPressed: () async {
                                final shouldDelete = await _showDeleteConfirmationDialog();
                                if (shouldDelete) {
                                  provider.deleteWordFromSet(widget.setId, index);
                                }
                              },
                            ),
                          ],
                        )
                      : null,
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showEditOrAddWordDialog(), // Call the same dialog for adding
            child: const Icon(LucideIcons.plus, size: 28),
            tooltip: 'Add a new word',
          ),
        );
      },
    );
  }
}
