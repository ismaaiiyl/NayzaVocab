import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<VocabSetProvider>(context);
    final vocabSet = provider.getSetById(widget.setId);

    if (vocabSet == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Set not found!')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(vocabSet.title),
        actions: [
          IconButton(
            icon: Icon(_isEditMode ? Icons.done : Icons.edit),
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
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(word.original),
              subtitle: Text(word.translation),
              trailing: _isEditMode
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            // TODO: Implement edit word logic
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // TODO: Implement delete word logic
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
        onPressed: () {
          // TODO: Implement add new word to set logic
        },
        backgroundColor: const Color(0xFFFFD700), // Electric Gold
        child: const Icon(Icons.add),
        tooltip: 'Add a new word',
      ),
    );
  }
}
