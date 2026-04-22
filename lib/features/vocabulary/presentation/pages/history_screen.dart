import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/quiz_provider.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/vocab_set_model.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/word_model.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/folder_model.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';
import 'package:nayza_vocab/core/widgets/nayza_widgets.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Timer? _debounce;

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _searchQuery = query;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }


  /// Shows a dialog to edit a word. Uses a proper StatefulWidget
  /// so TextEditingControllers are always disposed (no memory leak).
  void _showEditWordDialog(BuildContext context, WordModel word, String setId) {
    showDialog<void>(
      context: context,
      builder: (ctx) => _EditWordDialog(word: word, setId: setId),
    );
  }

  /// Shows a dialog to rename a collection. Uses a proper StatefulWidget
  /// so the TextEditingController is always disposed (no memory leak).
  void _showEditTitleDialog(BuildContext context, VocabSetModel set) {
    showDialog<void>(
      context: context,
      builder: (ctx) => _EditTitleDialog(set: set),
    );
  }

  Widget _buildDifficultSetCard(BuildContext context, VocabSetModel set, ThemeData theme, AppLocalizations l10n, int number) {
    final title = l10n.difficultSetTitle(number);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Card(
        child: InkWell(
          onTap: () => context.pushNamed('difficult-set-details', extra: set.copyWith(title: title)),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.flame, color: Colors.redAccent, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title, 
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: AppTheme.electricGold, 
                          fontSize: title.length > 25 ? 16 : 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.wordCountLabel(set.words.length),
                        style: const TextStyle(color: AppTheme.textDim, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const Icon(LucideIcons.chevronRight, color: AppTheme.textDim, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFolderCard(BuildContext context, FolderModel folder, ThemeData theme) {
    final setsCount = context.read<VocabSetProvider>().getSetsByFolder(folder.id).length;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Card(
        child: InkWell(
          onTap: () {
            if (folder.id == 'difficult') {
              context.pushNamed('difficult-words');
            } else {
              context.pushNamed('folder-details', pathParameters: {'id': folder.id});
            }
          },
          onLongPress: folder.id == 'difficult' ? null : () => _showFolderOptions(context, folder, l10n),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (folder.id == 'difficult' ? Colors.redAccent : AppTheme.electricGold).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    folder.id == 'difficult' ? LucideIcons.flame : LucideIcons.folder, 
                    color: folder.id == 'difficult' ? Colors.redAccent : AppTheme.electricGold, 
                    size: 28
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        folder.title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: AppTheme.textMain,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.setsCountLabel(setsCount),
                        style: const TextStyle(color: AppTheme.textDim, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const Icon(LucideIcons.chevronRight, color: AppTheme.textDim, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFolderOptions(BuildContext context, FolderModel folder, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceNavy,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: AppTheme.borderNavy, borderRadius: BorderRadius.circular(2)),
          ),
          ListTile(
            leading: const Icon(LucideIcons.edit, color: AppTheme.electricGold),
            title: Text(l10n.rename, style: const TextStyle(color: AppTheme.textMain)),
            onTap: () {
              Navigator.pop(ctx);
              _showRenameFolderDialog(context, folder, l10n);
            },
          ),
          ListTile(
            leading: const Icon(LucideIcons.trash2, color: Colors.redAccent),
            title: Text(l10n.delete, style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.pop(ctx);
              _showDeleteConfirmation(context, folder, l10n);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showRenameFolderDialog(BuildContext context, FolderModel folder, AppLocalizations l10n) {
    final controller = TextEditingController(text: folder.title);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceNavy,
        title: Text(l10n.rename, style: const TextStyle(color: AppTheme.electricGold)),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(hintText: l10n.enterFolderName),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel, style: const TextStyle(color: AppTheme.textDim))),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                context.read<VocabSetProvider>().renameFolder(folder.id, controller.text.trim());
                Navigator.pop(ctx);
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, FolderModel folder, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceNavy,
        title: Text(l10n.dangerZone, style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
        content: Text(
          l10n.deleteFolderConfirm,
          style: const TextStyle(color: AppTheme.textMain),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel, style: const TextStyle(color: AppTheme.textDim))),
          ElevatedButton(
            onPressed: () {
              context.read<VocabSetProvider>().deleteFolder(folder.id);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  void _showCreateFolderDialog(BuildContext context) {
    final controller = TextEditingController();
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceNavy,
        title: Text(l10n.createFolder, style: const TextStyle(color: AppTheme.electricGold)),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(hintText: l10n.enterFolderName),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel, style: const TextStyle(color: AppTheme.textDim))),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                context.read<VocabSetProvider>().createFolder(controller.text.trim());
                Navigator.pop(ctx);
              }
            },
            child: Text(l10n.create),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vocabSetProvider = Provider.of<VocabSetProvider>(context);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    // Filtered Folders
    final filteredFolders = vocabSetProvider.folders.where((f) {
      return f.title.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    // Difficult Virtual Sets
    final difficultSets = vocabSetProvider.getDifficultVirtualSets();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.collectionsPageTitle.toUpperCase()),
        automaticallyImplyLeading: false, 
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: l10n.searchHint,
                prefixIcon: const Icon(LucideIcons.search, color: AppTheme.textDim),
                suffixIcon: _searchQuery.isNotEmpty 
                  ? IconButton(
                      icon: const Icon(LucideIcons.x, size: 20),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          Expanded(
            child: (filteredFolders.isEmpty && difficultSets.isEmpty && vocabSetProvider.getSetsByFolder(null).isEmpty)
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(LucideIcons.folderSearch, size: 80, color: AppTheme.textDim),
                        const SizedBox(height: 20),
                        Text(
                          _searchQuery.isEmpty ? l10n.noCollections : l10n.noResults,
                          style: theme.textTheme.titleLarge,
                        ),
                      ],
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      // ─── DIFFICULT SETS SECTION (Virtual Folder) ───────────────────────
                      if (difficultSets.isNotEmpty && _searchQuery.isEmpty) ...[
                        Text(
                          l10n.difficultCollectionsHeader, 
                          style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, letterSpacing: 1.2, fontSize: 13),
                        ),
                        const SizedBox(height: 12),
                        // Treat as a special folder card
                        _buildFolderCard(
                          context, 
                          FolderModel(id: 'difficult', title: l10n.difficultCollectionsHeader, createdAt: DateTime.now()), 
                          theme
                        ),
                        const SizedBox(height: 24),
                      ],

                      // ─── MY FOLDERS SECTION ───────────────────────
                      if (filteredFolders.isNotEmpty) ...[
                        Text(
                          l10n.myCollectionsHeader, 
                          style: const TextStyle(color: AppTheme.textDim, fontWeight: FontWeight.bold, letterSpacing: 1.2, fontSize: 13),
                        ),
                        const SizedBox(height: 12),
                        ...filteredFolders.map((folder) => _buildFolderCard(context, folder, theme)),
                      ],

                      // ─── UNCATEGORIZED SETS (Virtual Folder) ───────────────────────
                      if (vocabSetProvider.getSetsByFolder(null).isNotEmpty) ...[
                        if (filteredFolders.isEmpty) ...[
                           Text(
                            l10n.myCollectionsHeader, 
                            style: const TextStyle(color: AppTheme.textDim, fontWeight: FontWeight.bold, letterSpacing: 1.2, fontSize: 13),
                          ),
                          const SizedBox(height: 12),
                        ],
                        _buildFolderCard(
                          context, 
                          FolderModel(id: 'uncategorized', title: l10n.noFolder, createdAt: DateTime.now()), 
                          theme
                        ),
                      ],
                    ],
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateFolderDialog(context),
        backgroundColor: AppTheme.electricGold,
        child: const Icon(LucideIcons.plus, color: AppTheme.darkNavy),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PRIVATE DIALOG WIDGETS — Each owns and disposes its own controllers.
// Senior pattern: Never create TextEditingControllers inside a builder() closure.
// ─────────────────────────────────────────────────────────────────────────────

/// Dialog for editing a word's original text and translation.
class _EditWordDialog extends StatefulWidget {
  final WordModel word;
  final String setId;

  const _EditWordDialog({required this.word, required this.setId});

  @override
  State<_EditWordDialog> createState() => _EditWordDialogState();
}

class _EditWordDialogState extends State<_EditWordDialog> {
  late final TextEditingController _originalController;
  late final TextEditingController _translationController;

  @override
  void initState() {
    super.initState();
    _originalController = TextEditingController(text: widget.word.original);
    _translationController = TextEditingController(text: widget.word.translation);
  }

  @override
  void dispose() {
    _originalController.dispose();
    _translationController.dispose();
    super.dispose();
  }

  void _save() {
    final originalText = _originalController.text.trim();
    final translationText = _translationController.text.trim();
    if (originalText.isEmpty || translationText.isEmpty) return;

    final provider = context.read<VocabSetProvider>();
    final updatedWord = widget.word.copyWith(
      original: originalText,
      translation: translationText,
    );
    final set = provider.getSetById(widget.setId);
    if (set != null) {
      final updatedWords =
          set.words.map((w) => w.id == widget.word.id ? updatedWord : w).toList();
      provider.updateVocabSet(set.copyWith(words: updatedWords));
    }

    Navigator.of(context).pop();

    // Show snackbar using root context after dialog closes
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.wordUpdated),
        backgroundColor: Colors.greenAccent.withValues(alpha: 0.85),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      backgroundColor: AppTheme.surfaceNavy,
      title: Text(
        l10n.editWord,
        style: const TextStyle(color: AppTheme.electricGold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _originalController,
            autofocus: true,
            decoration: InputDecoration(labelText: l10n.originalWord),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _translationController,
            decoration: InputDecoration(labelText: l10n.translationWord),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _save(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel, style: const TextStyle(color: AppTheme.textDim)),
        ),
        ElevatedButton(
          onPressed: _save,
          child: Text(l10n.save),
        ),
      ],
    );
  }
}

/// Dialog for renaming a collection's title.
class _EditTitleDialog extends StatefulWidget {
  final VocabSetModel set;

  const _EditTitleDialog({required this.set});

  @override
  State<_EditTitleDialog> createState() => _EditTitleDialogState();
}

class _EditTitleDialogState extends State<_EditTitleDialog> {
  late final TextEditingController _titleController;
  String? _selectedFolderId;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.set.title);
    _selectedFolderId = widget.set.folderId;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _save() {
    final newTitle = _titleController.text.trim();
    if (newTitle.isEmpty) return;
    context.read<VocabSetProvider>().updateVocabSet(
          widget.set.copyWith(
            title: newTitle,
            folderId: _selectedFolderId,
          ),
        );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      backgroundColor: AppTheme.surfaceNavy,
      title: Text(
        l10n.editSetTitle,
        style: const TextStyle(color: AppTheme.electricGold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            autofocus: true,
            decoration: InputDecoration(labelText: l10n.collectionNameLabel),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          Consumer<VocabSetProvider>(
            builder: (context, provider, child) {
              final folders = provider.folders;
              return DropdownButtonFormField<String?>(
                value: _selectedFolderId,
                decoration: InputDecoration(
                  labelText: l10n.folderName,
                  prefixIcon: const Icon(LucideIcons.folder, size: 20, color: AppTheme.electricGold),
                ),
                dropdownColor: AppTheme.surfaceNavy,
                items: [
                  DropdownMenuItem(value: null, child: Text(l10n.noFolder)),
                  ...folders.map((f) => DropdownMenuItem(value: f.id, child: Text(f.title))),
                ],
                onChanged: (v) => setState(() => _selectedFolderId = v),
              );
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel, style: const TextStyle(color: AppTheme.textDim)),
        ),
        ElevatedButton(
          onPressed: _save,
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
