import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/create_set_screen.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/quiz_screen.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/set_details_screen.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vocabSetProvider = Provider.of<VocabSetProvider>(context);
    final vocabSets = vocabSetProvider.vocabSets;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('TO\'PLAMLARIM'),
      ),
      body: vocabSets.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(LucideIcons.library, size: 80, color: AppTheme.textDim),
                  const SizedBox(height: 20),
                  Text(
                    'To\'plamlar yo\'q',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Yangi to\'plam yaratish uchun + tugmasini bosing.',
                    style: TextStyle(color: AppTheme.textDim),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: vocabSets.length,
              itemBuilder: (context, index) {
                final set = vocabSets[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Hero(
                    tag: 'set-${set.id}',
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SetDetailsScreen(setId: set.id),
                          ),
                        ),
                        borderRadius: BorderRadius.circular(16),
                        child: Card(
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        set.title,
                                        style: theme.textTheme.titleLarge?.copyWith(
                                          color: AppTheme.electricGold,
                                          fontSize: 22,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(LucideIcons.layers, size: 14, color: AppTheme.textDim),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${set.words.length} so\'z',
                                            style: const TextStyle(color: AppTheme.textDim),
                                          ),
                                          const SizedBox(width: 12),
                                          const Icon(LucideIcons.calendar, size: 14, color: AppTheme.textDim),
                                          const SizedBox(width: 4),
                                          Text(
                                            DateFormat.yMMMd().format(set.createdAt),
                                            style: const TextStyle(color: AppTheme.textDim),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(LucideIcons.playCircle, color: AppTheme.electricGold, size: 32),
                                  onPressed: () {
                                    if (set.words.isNotEmpty) {
                                      vocabSetProvider.prepareTrainingSession({set.id});
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const QuizScreen()),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('To\'plam bo\'sh. Avval so\'z qo\'shing.')),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CreateSetScreen()),
        ),
        child: const Icon(LucideIcons.plus, size: 32),
      ),
    );
  }
}
