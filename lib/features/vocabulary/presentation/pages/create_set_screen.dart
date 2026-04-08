import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/word_model.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CreateSetScreen extends StatefulWidget {
  const CreateSetScreen({super.key});

  @override
  State<CreateSetScreen> createState() => _CreateSetScreenState();
}

class _CreateSetScreenState extends State<CreateSetScreen> {
  final _titleController = TextEditingController();
  final List<WordModel> _words = [];
  final List<FocusNode> _focusNodes = [];
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    // Start with one empty word field
    _addWordField();
  }

  void _addWordField() {
    setState(() {
      _words.add(WordModel(id: _uuid.v4(), original: '', translation: ''));
      _focusNodes.add(FocusNode());
      _focusNodes.add(FocusNode()); // One for original, one for translation
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _saveSet() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final validWords = _words.where((word) => word.original.trim().isNotEmpty && word.translation.trim().isNotEmpty).toList();

      if (validWords.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one valid word.')),
        );
        return;
      }

      Provider.of<VocabSetProvider>(context, listen: false).createVocabSet(_titleController.text, validWords);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Set'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.save, size: 24),
            onPressed: _saveSet,
            tooltip: 'Save Set',
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Set Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title for the set.';
                  }
                  return null;
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: _words.length,
                itemBuilder: (context, index) {
                  return _buildWordCard(index);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addWordField,
        label: const Text('Add Word'),
        icon: const Icon(LucideIcons.plusCircle),
      ),
    );
  }

  Widget _buildWordCard(int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextFormField(
              initialValue: _words[index].original,
              focusNode: _focusNodes[index * 2],
              decoration: InputDecoration(labelText: 'Original Word (e.g., English)', hintText: 'Enter word'),
              onChanged: (value) {
                _words[index] = _words[index].copyWith(original: value);
              },
               onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_focusNodes[index * 2 + 1]),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: _words[index].translation,
               focusNode: _focusNodes[index * 2 + 1],
              decoration: InputDecoration(labelText: 'Translation', hintText: 'Enter translation'),
              onChanged: (value) {
                _words[index] = _words[index].copyWith(translation: value);
              },
              onFieldSubmitted: (value) {
                if(index == _words.length -1){
                  _addWordField();
                  FocusScope.of(context).requestFocus(_focusNodes[(index+1) * 2]);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
