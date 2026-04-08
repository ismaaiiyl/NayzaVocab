import 'package:flutter/material.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/vocab_set_model.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:provider/provider.dart';

class CreateSetScreen extends StatefulWidget {
  const CreateSetScreen({super.key});

  @override
  State<CreateSetScreen> createState() => _CreateSetScreenState();
}

class _CreateSetScreenState extends State<CreateSetScreen> {
  final _titleController = TextEditingController();
  final List<TextEditingController> _originalControllers = [];
  final List<TextEditingController> _translationControllers = [];
  final List<String> _langCodes = [];

  @override
  void initState() {
    super.initState();
    _addNewRow();
  }

  void _addNewRow() {
    setState(() {
      _originalControllers.add(TextEditingController());
      _translationControllers.add(TextEditingController());
      _langCodes.add('en-US'); // Default language
    });
  }

  void _saveSet() {
    if (_titleController.text.isEmpty) {
      // Show error
      return;
    }

    final List<WordModel> words = [];
    for (int i = 0; i < _originalControllers.length; i++) {
      final original = _originalControllers[i].text;
      final translation = _translationControllers[i].text;
      if (original.isNotEmpty && translation.isNotEmpty) {
        words.add(WordModel(
          original: original,
          translation: translation,
          langCode: _langCodes[i],
        ));
      }
    }

    if (words.isNotEmpty) {
      Provider.of<VocabSetProvider>(context, listen: false)
          .addVocabSet(_titleController.text, words);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a New Set'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveSet,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Set Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _originalControllers.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: _originalControllers[index],
                            decoration: const InputDecoration(labelText: 'Original Word'),
                          ),
                          TextField(
                            controller: _translationControllers[index],
                            decoration: const InputDecoration(labelText: 'Translation'),
                          ),
                          DropdownButton<String>(
                            value: _langCodes[index],
                            onChanged: (String? newValue) {
                              setState(() {
                                _langCodes[index] = newValue!;
                              });
                            },
                            items: <String>['en-US', 'ru-RU', 'ar-SA', 'de-DE']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewRow,
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFFFFD700), // Electric Gold
      ),
    );
  }
}
