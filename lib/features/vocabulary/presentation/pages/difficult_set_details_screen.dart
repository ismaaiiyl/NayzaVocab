import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/vocab_set_model.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/quiz_provider.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class DifficultSetDetailsScreen extends StatelessWidget {
  final VocabSetModel virtualSet;
  const DifficultSetDetailsScreen({super.key, required this.virtualSet});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(virtualSet.title),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.playCircle, color: AppTheme.electricGold, size: 28),
            onPressed: () {
              if (virtualSet.words.isNotEmpty) {
                context.read<QuizProvider>().prepareSession(virtualSet.words);
                context.pushNamed('quiz-setup');
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer<VocabSetProvider>(
        builder: (context, provider, child) {
          // Re-filter words to ensure real-time UI updates when one is removed
          final allDifficult = provider.getDifficultWords();
          final currentWords = virtualSet.words.where((w) => allDifficult.any((dw) => dw.id == w.id)).toList();

          if (currentWords.isEmpty) {
            return Center(child: Text(l10n.noResults));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: currentWords.length,
            itemBuilder: (context, index) {
              final word = currentWords[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Card(
                  color: AppTheme.cardDark,
                  child: ListTile(
                    title: Text(word.original, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(word.translation, style: const TextStyle(color: AppTheme.textDim)),
                    trailing: IconButton(
                      icon: const Icon(LucideIcons.trash2, color: AppTheme.error, size: 18),
                      tooltip: l10n.removeFromDifficult,
                      onPressed: () => provider.resetWordDifficultStatus(word),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
