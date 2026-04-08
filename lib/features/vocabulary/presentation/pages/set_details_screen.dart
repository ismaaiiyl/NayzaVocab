import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/vocab_set_model.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/word_model.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/widgets/add_edit_word_dialog.dart';
import 'package:provider/provider.dart';

class SetDetailsScreen extends StatefulWidget {
  final String setId;
  const SetDetailsScreen({super.key, required this.setId});

  @override
  State<SetDetailsScreen> createState() => _SetDetailsScreenState();
}

class _SetDetailsScreenState extends State<SetDetailsScreen> {
  void _showAddEditWordDialog({WordModel? existingWord, int? wordIndex}) async {
    final vocabSetProvider = Provider.of<VocabSetProvider>(context, listen: false);
    final set = vocabSetProvider.getSetById(widget.setId);
    if (set == null) return;

    final newWord = await showDialog<WordModel>(
      context: context,
      builder: (context) => AddEditWordDialog(word: existingWord),
    );

    if (newWord != null) {
      if (wordIndex != null) {
        set.words[wordIndex] = newWord;
      } else {
        set.words.add(newWord);
      }
      await vocabSetProvider.updateVocabSet(set);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VocabSetProvider>(
      builder: (context, provider, child) {
        final set = provider.getSetById(widget.setId);
        if (set == null) {
          return const Scaffold(body: Center(child: Text('To\'plam topilmadi.')));
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(set.title.toUpperCase()),
            actions: [
              IconButton(
                icon: const Icon(LucideIcons.plus, color: AppTheme.electricGold),
                onPressed: () => _showAddEditWordDialog(),
              ),
              IconButton(
                icon: const Icon(LucideIcons.trash2, color: Colors.redAccent, size: 20),
                onPressed: () => _showDeleteSetDialog(context, provider, set),
              ),
            ],
          ),
          body: Column(
            children: [
              _buildStatsHeader(set),
              const Divider(color: Color(0xFF233554), height: 1),
              Expanded(
                child: set.words.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(LucideIcons.plusCircle, size: 48, color: AppTheme.textDim),
                            const SizedBox(height: 16),
                            const Text('Bu to\'plam hali bo\'sh.', style: TextStyle(color: AppTheme.textDim)),
                            TextButton(
                              onPressed: () => _showAddEditWordDialog(),
                              child: const Text('SO\'Z QO\'SHISH', style: TextStyle(color: AppTheme.electricGold)),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: set.words.length,
                        itemBuilder: (context, index) {
                          final word = set.words[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Card(
                              child: ListTile(
                                onTap: () => _showAddEditWordDialog(existingWord: word, wordIndex: index),
                                title: Text(word.original, style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(word.translation, style: const TextStyle(color: AppTheme.textDim)),
                                trailing: IconButton(
                                  icon: const Icon(LucideIcons.trash2, size: 18, color: Colors.redAccent),
                                  onPressed: () async {
                                    set.words.removeAt(index);
                                    await provider.updateVocabSet(set);
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsHeader(VocabSetModel set) {
    int learnedCount = set.words.where((WordModel w) => w.isLearned).length;
    double progress = set.words.isEmpty ? 0 : learnedCount / set.words.length;

    return Container(
      padding: const EdgeInsets.all(24),
      color: AppTheme.surfaceNavy,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${set.words.length} ta so\'z mavjud',
                  style: const TextStyle(color: AppTheme.textDim, fontSize: 14),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: const Color(0xFF1E2D4A),
                    color: AppTheme.electricGold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Column(
            children: [
              Text(
                '${(progress * 100).toInt()}%',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.electricGold),
              ),
              const Text('PROGRES', style: TextStyle(fontSize: 10, color: AppTheme.textDim)),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteSetDialog(BuildContext context, VocabSetProvider provider, VocabSetModel set) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceNavy,
        title: const Text('TO\'PLAMNI O\'CHIRISH', style: TextStyle(color: Colors.redAccent)),
        content: Text('"${set.title}" to\'plamini o\'chirishga ishonchingiz komilmi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('BEKOR QILISH', style: TextStyle(color: AppTheme.textDim)),
          ),
          ElevatedButton(
            onPressed: () {
              provider.deleteVocabSet(set.id);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            child: const Text('O\'CHIRISH'),
          ),
        ],
      ),
    );
  }
}
