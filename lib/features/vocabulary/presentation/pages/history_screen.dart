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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


  void _showEditWordDialog(BuildContext context, WordModel word, String setId) {
    final l10n = AppLocalizations.of(context)!;
    final originalController = TextEditingController(text: word.original);
    final translationController = TextEditingController(text: word.translation);
    
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceNavy,
        title: Text(l10n.editWord, style: const TextStyle(color: AppTheme.electricGold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: originalController,
              decoration: InputDecoration(labelText: l10n.originalWord),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: translationController,
              decoration: InputDecoration(labelText: l10n.translationWord),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel, style: const TextStyle(color: AppTheme.textDim)),
          ),
          ElevatedButton(
            onPressed: () {
              final provider = context.read<VocabSetProvider>();
              final updatedWord = word.copyWith(
                original: originalController.text,
                translation: translationController.text,
              );
              
              final set = provider.getSetById(setId);
              if (set != null) {
                final updatedWords = set.words.map((w) => w.id == word.id ? updatedWord : w).toList();
                provider.updateVocabSet(set.copyWith(words: updatedWords));
              }
              
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.wordUpdated)),
              );
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultSetCard(BuildContext context, VocabSetModel set, ThemeData theme, AppLocalizations l10n, int number) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Card(
        child: InkWell(
          onTap: () => context.pushNamed('difficult-set-details', extra: set.copyWith(title: l10n.difficultSetTitle(number))),
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
                        l10n.difficultSetTitle(number), 
                        style: theme.textTheme.titleLarge?.copyWith(color: AppTheme.electricGold, fontSize: 18),
                        overflow: TextOverflow.ellipsis,
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
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
                          padding: const EdgeInsets.only(right: 12.0, top: 2.0),
                          child: _buildSetStatusIndicator(set),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                set.title, 
                                style: theme.textTheme.titleLarge?.copyWith(color: AppTheme.electricGold, fontSize: 20),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(LucideIcons.layers, size: 14, color: AppTheme.textDim),
                                  const SizedBox(width: 4),
                                  Text(l10n.wordCountLabel(set.words.length), style: const TextStyle(color: AppTheme.textDim)),
                                  const SizedBox(width: 12),
                                  const Icon(LucideIcons.calendar, size: 14, color: AppTheme.textDim),
                                  const SizedBox(width: 4),
                                  Text(DateFormat.yMMMd().format(set.createdAt), style: const TextStyle(color: AppTheme.textDim)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
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
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: const Icon(LucideIcons.playCircle, color: AppTheme.electricGold, size: 28),
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
    );
  }

  Widget _buildSetStatusIndicator(VocabSetModel set) {
    if (set.progressPercentage == 100) {
      return const Icon(LucideIcons.star, color: AppTheme.electricGold, size: 28);
    }
    return const SizedBox(width: 28); // Keep the space but show nothing
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
        title: Text(l10n.historyTitle),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed('create-set'),
        child: const Icon(LucideIcons.plus, size: 32),
      ),
    );
  }
}
