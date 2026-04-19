import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/quiz_provider.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/vocab_set_model.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/word_model.dart';
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

  Widget _buildSetCard(BuildContext context, VocabSetModel set, ThemeData theme) {
    final progress = set.progressPercentage;
    final l10n = AppLocalizations.of(context)!;
    final double titleFontSize = set.title.length > 20 ? 16 : 20;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Dismissible(
        key: Key('set-dismiss-${set.id}'),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: Colors.redAccent.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(LucideIcons.trash2, color: Colors.white),
        ),
        confirmDismiss: (direction) async {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              backgroundColor: AppTheme.surfaceNavy,
              title: Text(l10n.deleteSetConfirm, style: const TextStyle(color: Colors.redAccent)),
              content: Text(set.title),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel, style: const TextStyle(color: AppTheme.textDim))),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                  onPressed: () => Navigator.pop(ctx, true), 
                  child: Text(l10n.delete),
                ),
              ],
            ),
          );
          return confirmed;
        },
        onDismissed: (direction) {
          final provider = context.read<VocabSetProvider>();
          provider.deleteVocabSet(set.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${set.title} deleted'),
              action: SnackBarAction(
                label: 'UNDO',
                onPressed: () => provider.addSet(set),
              ),
            ),
          );
        },
        child: Hero(
          tag: 'set-${set.id}',
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => context.pushNamed('set-details', pathParameters: {'id': set.id}),
              borderRadius: BorderRadius.circular(16),
              child: Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ─── LEFT STATUS INDICATOR ───────────────────────
                          Padding(
                            padding: const EdgeInsets.only(right: 12.0, top: 4.0),
                            child: _buildSetStatusIndicator(set),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        set.title, 
                                        style: theme.textTheme.titleLarge?.copyWith(
                                          color: AppTheme.electricGold, 
                                          fontSize: titleFontSize,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(LucideIcons.edit2, size: 16, color: AppTheme.textDim),
                                      onPressed: () => _showEditTitleDialog(context, set),
                                      padding: const EdgeInsets.all(12), // Senior fix: Larger tap area
                                      constraints: const BoxConstraints(),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(LucideIcons.layers, size: 14, color: AppTheme.textDim),
                                    const SizedBox(width: 4),
                                    Text(l10n.wordCountLabel(set.words.length), style: const TextStyle(color: AppTheme.textDim, fontSize: 12)),
                                    const SizedBox(width: 12),
                                    const Icon(LucideIcons.calendar, size: 14, color: AppTheme.textDim),
                                    const SizedBox(width: 4),
                                    Text(DateFormat.yMMMd().format(set.createdAt), style: const TextStyle(color: AppTheme.textDim, fontSize: 12)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    height: 48, width: 48,
                                    child: CircularProgressIndicator(
                                      value: progress / 100,
                                      backgroundColor: AppTheme.cardDark.withValues(alpha: 0.5),
                                      color: progress == 100 ? Colors.greenAccent : AppTheme.electricGold,
                                      strokeWidth: 4,
                                    ),
                                  ),
                                  Text('${progress.toInt()}%', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              IconButton(
                                onPressed: () {
                                  if (set.words.isNotEmpty) {
                                    context.read<QuizProvider>().prepareSession(set.words);
                                    context.pushNamed('quiz-setup');
                                  }
                                },
                                padding: const EdgeInsets.all(8), // Larger tap area
                                icon: const Icon(LucideIcons.playCircle, color: AppTheme.electricGold, size: 32),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      NayzaProgressBar(
                        current: progress.toInt(),
                        total: 100,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSetStatusIndicator(VocabSetModel set) {
    final progress = set.progressPercentage;
    if (progress == 100) {
      return const Icon(LucideIcons.star, color: AppTheme.electricGold, size: 28);
    } else if (progress > 0) {
      return Icon(LucideIcons.starHalf, color: AppTheme.electricGold.withValues(alpha: 0.5), size: 28);
    }
    return Icon(LucideIcons.star, color: AppTheme.textDim.withValues(alpha: 0.2), size: 28);
  }

  Widget _buildWordResultCard(BuildContext context, WordModel word, String setId) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: AppTheme.cardDark,
      child: ListTile(
        title: Text(word.original, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(word.translation, style: const TextStyle(color: AppTheme.textDim)),
        trailing: const Icon(LucideIcons.edit3, size: 18, color: AppTheme.electricGold),
        onTap: () => _showEditWordDialog(context, word, setId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vocabSetProvider = Provider.of<VocabSetProvider>(context);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    // Filtered Sets
    final filteredSets = vocabSetProvider.vocabSets.where((set) {
      return set.title.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    // Matching Words
    final matchingWords = <MapEntry<WordModel, String>>[];
    if (_searchQuery.isNotEmpty) {
      for (var set in vocabSetProvider.vocabSets) {
        for (var word in set.words) {
          if (word.original.toLowerCase().contains(_searchQuery.toLowerCase()) || 
              word.translation.toLowerCase().contains(_searchQuery.toLowerCase())) {
            matchingWords.add(MapEntry(word, set.id));
          }
        }
      }
    }

    // Difficult Virtual Sets
    final difficultSets = vocabSetProvider.getDifficultVirtualSets();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.collectionsPageTitle.toUpperCase()),
        automaticallyImplyLeading: false, // Cleaner tab look
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
            child: (filteredSets.isEmpty && difficultSets.isEmpty && matchingWords.isEmpty)
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(LucideIcons.searchX, size: 80, color: AppTheme.textDim),
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
                      // ─── DIFFICULT SETS SECTION ───────────────────────
                      if (difficultSets.isNotEmpty && _searchQuery.isEmpty) ...[
                        Text(
                          l10n.difficultCollectionsHeader, 
                          style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, letterSpacing: 1.2, fontSize: 13),
                        ),
                        const SizedBox(height: 12),
                        ...difficultSets.asMap().entries.map((entry) {
                           return _buildDifficultSetCard(context, entry.value, theme, l10n, entry.key + 1);
                        }),
                        const SizedBox(height: 24),
                      ],

                      // ─── MY COLLECTIONS SECTION ───────────────────────
                      if (filteredSets.isNotEmpty) ...[
                        Text(
                          l10n.myCollectionsHeader, 
                          style: const TextStyle(color: AppTheme.textDim, fontWeight: FontWeight.bold, letterSpacing: 1.2, fontSize: 13),
                        ),
                        const SizedBox(height: 12),
                        ...filteredSets.map((set) => _buildSetCard(context, set, theme)),
                      ],

                      // ─── SEARCH RESULTS: WORDS ────────────────────────
                      if (matchingWords.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        Text(
                          l10n.foundWordsLabel, 
                          style: const TextStyle(color: AppTheme.textDim, fontWeight: FontWeight.bold, letterSpacing: 1.2, fontSize: 13),
                        ),
                        const SizedBox(height: 12),
                        ...matchingWords.map((entry) => _buildWordResultCard(context, entry.key, entry.value)),
                      ],
                    ],
                  ),
          ),
        ],
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

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.set.title);
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
          widget.set.copyWith(title: newTitle),
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
      content: TextField(
        controller: _titleController,
        autofocus: true,
        decoration: InputDecoration(labelText: l10n.collectionNameLabel),
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _save(),
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
