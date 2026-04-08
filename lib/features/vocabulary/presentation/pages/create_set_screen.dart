import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/vocab_set_model.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:provider/provider.dart';

class CreateSetScreen extends StatefulWidget {
  const CreateSetScreen({super.key});

  @override
  State<CreateSetScreen> createState() => _CreateSetScreenState();
}

class _CreateSetScreenState extends State<CreateSetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final List<WordModel> _words = [];
  final List<Map<String, TextEditingController>> _wordControllers = [];

  @override
  void initState() {
    super.initState();
    _addWordField(); // Start with one word field
  }

  void _addWordField() {
    setState(() {
      final originalController = TextEditingController();
      final translationController = TextEditingController();
      _wordControllers.add({
        'original': originalController,
        'translation': translationController,
      });
    });
  }

  void _removeWordField(int index) {
    setState(() {
      _wordControllers[index]['original']!.dispose();
      _wordControllers[index]['translation']!.dispose();
      _wordControllers.removeAt(index);
    });
  }

  void _saveSet() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final provider = Provider.of<VocabSetProvider>(context, listen: false);
      provider.createVocabSet(_titleController.text.trim(), _words);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    for (var controllers in _wordControllers) {
      controllers['original']!.dispose();
      controllers['translation']!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Set'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Set Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title for your set.';
                  }
                  return null;
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _wordControllers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _wordControllers[index]['original'],
                            decoration: const InputDecoration(labelText: 'Original'),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              if (_words.length <= index) {
                                _words.add(WordModel(original: value!, translation: ''));
                              } else {
                                _words[index] = _words[index].copyWith(original: value);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: _wordControllers[index]['translation'],
                            decoration: const InputDecoration(labelText: 'Translation'),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                            onSaved: (value) {
                               _words[index] = _words[index].copyWith(translation: value);
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(LucideIcons.x, color: Colors.redAccent),
                          onPressed: () => _removeWordField(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(LucideIcons.plusCircle),
                      label: const Text('Add Word'),
                      onPressed: _addWordField,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(LucideIcons.save),
                      label: const Text('Save Set'),
                      onPressed: _saveSet,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
