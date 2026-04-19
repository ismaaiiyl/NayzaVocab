import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      final controllers = _rowControllers[index];
      setState(() {
        _rowControllers.removeAt(index);
      });
      // Senior fix: Dispose after the frame to avoid FocusNode disposed error during rebuild
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controllers.dispose();
      });
    }
  }

  Future<void> _handleBulkPaste() async {
    final l10n = AppLocalizations.of(context)!;
    final textController = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceNavy,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppTheme.borderNavy),
          ),
          title: Text(
            'Smart Paste',
            style: const TextStyle(color: AppTheme.electricGold, fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: TextField(
              controller: textController,
              maxLines: 10,
              style: const TextStyle(color: AppTheme.textMain),
              decoration: InputDecoration(
                hintText: "word - translation\nanother word = another translation",
                hintStyle: const TextStyle(color: AppTheme.textDim),
                filled: true,
                fillColor: AppTheme.surfaceNavy.withValues(alpha: 0.5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.borderNavy),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.borderNavy),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.electricGold),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel, style: const TextStyle(color: AppTheme.textDim)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.electricGold,
                foregroundColor: AppTheme.surfaceNavy,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => Navigator.pop(context, textController.text),
              child: Text(l10n.addWord),
            ),
          ],
        );
      },
    );

    if (result == null || result.trim().isEmpty) return;

    final lines = result.split('\n');
    int addedCount = 0;
    
    // Yig'ish uchun vaqtinchalik list (ekranni birdaniga yangilash uchun)
    final newRows = <WordRowControllers>[];

    for (final line in lines) {
      final cleanLine = line.trim();
      if (cleanLine.isEmpty) continue;

      final separators = [
        ' - ', ' – ', ' — ', ' = ', ' : ', 
        '-', '–', '—', '=', ':', ';'
      ];
      
      String? original;
      String? translation;

      for (final sep in separators) {
        if (cleanLine.contains(sep)) {
          final parts = cleanLine.split(sep);
          if (parts.length >= 2) {
            original = parts.first.trim();
            translation = parts.sublist(1).join(sep).trim();
            break;
          }
        }
      }

      if (original != null && translation != null && original.isNotEmpty && translation.isNotEmpty) {
        final newController = WordRowControllers();
        newController.original.text = original;
        newController.translation.text = translation;
        newRows.add(newController);
        addedCount++;
      }
    }

    if (addedCount > 0) {
      // Bitta bo'sh qator qolib ketgan bo'lsa uni o'chiramiz, 
      // lekin FocusNode muammosi chiqmasligi uchun ehtiyot bo'lamiz
      final emptyControllersToDispose = <WordRowControllers>[];
      
      setState(() {
        for (var rc in _rowControllers.toList()) {
          if (rc.original.text.isEmpty && rc.translation.text.isEmpty) {
            _rowControllers.remove(rc);
            emptyControllersToDispose.add(rc);
          }
        }
        _rowControllers.addAll(newRows);
      });

      // Disposelarni keyingi freymga qoldiramiz (FocusNode disposed errorni oldini oladi)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        for (var rc in emptyControllersToDispose) {
          rc.dispose();
        }
        
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pasted $addedCount words!'),
            backgroundColor: Colors.greenAccent.withValues(alpha: 0.8),
          ),
        );
      }
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
                  DropdownMenuItem(value: 'de-DE', child: Text(l10n.germanLang)),
                  DropdownMenuItem(value: 'ko-KR', child: Text(l10n.koreanLang)),
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
              child: Row(
                children: [
                  Expanded(
                    child: NayzaButton(
                      text: l10n.addRowButton,
                      icon: LucideIcons.plus,
                      onPressed: _addRow,
                      isFullWidth: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceNavy,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.borderNavy),
                    ),
                    child: IconButton(
                      icon: const Icon(LucideIcons.clipboardPaste, color: AppTheme.electricGold),
                      onPressed: _handleBulkPaste,
                      tooltip: 'Paste from clipboard',
                      padding: const EdgeInsets.all(14),
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
