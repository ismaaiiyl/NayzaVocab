import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/core/widgets/nayza_text_field.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/word_model.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/dialogs/smart_paste_dialog.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/widgets/create_set_action_bar.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/widgets/folder_selector_dropdown.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/widgets/language_selector_dropdown.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/widgets/word_row_controllers.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/widgets/word_row_item.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CreateSetScreen extends StatefulWidget {
  final String? folderId;
  const CreateSetScreen({super.key, this.folderId});

  @override
  State<CreateSetScreen> createState() => _CreateSetScreenState();
}

class _CreateSetScreenState extends State<CreateSetScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();
  final List<WordRowControllers> _rowControllers = [];
  String _selectedLangCode = 'en-US';
  String? _selectedFolderId;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _selectedFolderId = widget.folderId;
    for (int i = 0; i < 3; i++) {
      _addRow(shouldFocus: false);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _titleFocusNode.requestFocus());
  }

  void _addRow({bool shouldFocus = true}) {
    setState(() {
      final newController = WordRowControllers();
      _rowControllers.add(newController);
      if (!shouldFocus) return;
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
    });
  }

  void _removeRow(int index) {
    if (_rowControllers.length <= 1) return;
    final controllers = _rowControllers[index];
    setState(() => _rowControllers.removeAt(index));
    WidgetsBinding.instance.addPostFrameCallback((_) => controllers.dispose());
  }

  Future<void> _handleBulkPaste() async {
    final pairs = await SmartPasteDialog.show(context);
    if (pairs.isEmpty || !mounted) return;

    final newRows = pairs.map((p) {
      final r = WordRowControllers();
      r.original.text = p.key;
      r.translation.text = p.value;
      return r;
    }).toList();

    setState(() {
      _rowControllers.removeWhere((rc) {
        final isEmpty = rc.original.text.isEmpty && rc.translation.text.isEmpty;
        if (isEmpty) rc.dispose();
        return isEmpty;
      });
      _rowControllers.addAll(newRows);
    });

    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.wordCountLabel(pairs.length)),
        backgroundColor: AppTheme.success,
      ),
    );
  }

  Future<void> _saveSet() async {
    if (!_formKey.currentState!.validate()) return;

    final words = _rowControllers
        .where((rc) => rc.original.text.isNotEmpty)
        .map((rc) => WordModel(
              id: const Uuid().v4(),
              original: rc.original.text,
              translation: rc.translation.text,
              langCode: _selectedLangCode,
            ))
        .toList();

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
          folderId: _selectedFolderId,
        );

    if (mounted) context.pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _titleFocusNode.dispose();
    _scrollController.dispose();
    for (final rc in _rowControllers) {
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
              child: LanguageSelectorDropdown(
                selectedLangCode: _selectedLangCode,
                onChanged: (v) => setState(() => _selectedLangCode = v),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: FolderSelectorDropdown(
                selectedFolderId: _selectedFolderId,
                onChanged: (v) => setState(() => _selectedFolderId = v),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _rowControllers.length,
                itemBuilder: (context, index) {
                  return WordRowItem(
                    controllers: _rowControllers[index],
                    onRemove: () => _removeRow(index),
                  );
                },
              ),
            ),
            CreateSetActionBar(
              onAddRow: _addRow,
              onBulkPaste: _handleBulkPaste,
            ),
          ],
        ),
      ),
    );
  }
}
