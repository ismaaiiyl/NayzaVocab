import 'package:flutter/material.dart';
import 'package:nayza_vocab/core/widgets/nayza_widgets.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/word_model.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';

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
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.atLeastOneWordWarning)),
        );
        return;
      }

      await context.read<VocabSetProvider>().createVocabSet(
            _titleController.text,
            words,
          );

      if (mounted) {
        context.pop();
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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.createSetTitle),
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
                label: l10n.collectionNameLabel,
                hint: l10n.collectionNameHint,
                validator: (v) => v!.isEmpty ? l10n.nameRequiredError : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: DropdownButtonFormField<String>(
                initialValue: _selectedLangCode,
                decoration: InputDecoration(
                  labelText: l10n.languageLabel,
                  prefixIcon: const Icon(LucideIcons.languages, size: 20, color: Color(0xFFFFD700)),
                ),
                dropdownColor: AppTheme.surfaceNavy,
                items: [
                  DropdownMenuItem(value: 'en-US', child: Text(l10n.englishLang)),
                  DropdownMenuItem(value: 'ar-SA', child: Text(l10n.arabicLang)),
                  DropdownMenuItem(value: 'ru-RU', child: Text(l10n.russianLang)),
                  DropdownMenuItem(value: 'uz-UZ', child: Text(l10n.uzbekLang)),
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
                            label: l10n.wordPlaceholder,
                            hint: 'Word',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: NayzaTextField(
                            controller: _rowControllers[index].translation,
                            label: l10n.translationPlaceholder,
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
                text: l10n.addRowButton,
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
