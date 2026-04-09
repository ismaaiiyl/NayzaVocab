import 'package:flutter/material.dart';
import 'package:nayza_vocab/core/widgets/nayza_widgets.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/word_model.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CreateSetScreen extends StatefulWidget {
  const CreateSetScreen({super.key});

  @override
  State<CreateSetScreen> createState() => _CreateSetScreenState();
}

class _CreateSetScreenState extends State<CreateSetScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();
  final List<WordRowControllers> _rowControllers = [];
  String _selectedLangCode = 'en-US';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Start with 3 empty rows without auto-focus
    for (int i = 0; i < 3; i++) {
      _addRow(shouldFocus: false);
    }
    
    // Focus the title field on start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _titleFocusNode.requestFocus();
    });
  }

  void _addRow({bool shouldFocus = true}) {
    setState(() {
      final newController = WordRowControllers();
      _rowControllers.add(newController);
      
      if (shouldFocus) {
        // Focus and scroll after build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          newController.focusNode.requestFocus();
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    });
  }

  void _removeRow(int index) {
    if (_rowControllers.length > 1) {
      setState(() {
        _rowControllers[index].dispose();
        _rowControllers.removeAt(index);
      });
    }
  }

  Future<void> _saveSet() async {
    if (_formKey.currentState!.validate()) {
      final List<WordModel> words = _rowControllers.where((rc) => rc.original.text.isNotEmpty).map((rc) {
        return WordModel(
          id: const Uuid().v4(),
          original: rc.original.text,
          translation: rc.translation.text,
          langCode: _selectedLangCode,
        );
      }).toList();

      if (words.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kamida bitta so\'z kiriting')),
        );
        return;
      }

      await context.read<VocabSetProvider>().createVocabSet(
            _titleController.text,
            words,
          );

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _titleFocusNode.dispose();
    _scrollController.dispose();
    for (var rc in _rowControllers) {
      rc.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YANGI TO\'PLAM'),
        actions: [
          IconButton(
            onPressed: _saveSet,
            icon: const Icon(LucideIcons.check),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: NayzaTextField(
                controller: _titleController,
                focusNode: _titleFocusNode,
                label: 'To\'plam nomi',
                hint: 'Masalan: Oila, Sayohat...',
                validator: (v) => v!.isEmpty ? 'Nom kiriting' : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: DropdownButtonFormField<String>(
                initialValue: _selectedLangCode,
                decoration: const InputDecoration(
                  labelText: 'O\'rganilayotgan til',
                  prefixIcon: Icon(LucideIcons.languages, size: 20, color: Color(0xFFFFD700)),
                ),
                dropdownColor: const Color(0xFF112240),
                items: const [
                  DropdownMenuItem(value: 'en-US', child: Text('Ingliz tili')),
                  DropdownMenuItem(value: 'ar-SA', child: Text('Arab tili')),
                  DropdownMenuItem(value: 'ru-RU', child: Text('Rus tili')),
                  DropdownMenuItem(value: 'uz-UZ', child: Text('O\'zbek tili (TTS o\'chiq)')),
                ],
                onChanged: (v) => setState(() => _selectedLangCode = v!),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _rowControllers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: NayzaTextField(
                            controller: _rowControllers[index].original,
                            focusNode: _rowControllers[index].focusNode,
                            label: 'So\'z',
                            hint: 'Word',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: NayzaTextField(
                            controller: _rowControllers[index].translation,
                            label: 'Tarjima',
                            hint: 'Translation',
                          ),
                        ),
                        IconButton(
                          onPressed: () => _removeRow(index),
                          icon: const Icon(LucideIcons.trash2, color: Colors.redAccent, size: 20),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: NayzaButton(
                text: 'QATOR QO\'SHISH',
                icon: LucideIcons.plus,
                onPressed: _addRow,
                isFullWidth: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WordRowControllers {
  final TextEditingController original = TextEditingController();
  final TextEditingController translation = TextEditingController();
  final FocusNode focusNode = FocusNode();

  void dispose() {
    original.dispose();
    translation.dispose();
    focusNode.dispose();
  }
}
