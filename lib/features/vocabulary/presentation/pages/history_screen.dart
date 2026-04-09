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

  void _showModeSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF112240),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'TEST TURINI TANLANG',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.electricGold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text("O'zingizga qulay usulni tanlang", style: TextStyle(color: AppTheme.textDim)),
            const SizedBox(height: 24),
            _buildModeCard(context, icon: LucideIcons.layoutGrid, title: 'Variantli Test', subtitle: "To'g'ri javobni variantlar ichidan tanlang", mode: QuizMode.choice),
            const SizedBox(height: 12),
            _buildModeCard(context, icon: LucideIcons.pencil, title: 'Yozma Javob', subtitle: "Tarjimani o'zingiz yozib kiriting", mode: QuizMode.input),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildModeCard(BuildContext context, {required IconData icon, required String title, required String subtitle, required QuizMode mode}) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => QuizScreen(quizMode: mode)));
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2D4A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF233554), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppTheme.electricGold.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: AppTheme.electricGold, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textMain)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 13, color: AppTheme.textDim)),
                ],
              ),
            ),
            const Icon(LucideIcons.chevronRight, color: AppTheme.textDim),
          ],
        ),
      ),
    );
  }

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
                                      _showModeSheet(context);
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
