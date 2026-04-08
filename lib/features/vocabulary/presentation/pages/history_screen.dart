import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
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
        title: const Text('Vocabulary Sets'),
      ),
      body: vocabSets.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.school, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 20),
                  Text(
                    'No Vocabulary Sets Yet',
                    style: theme.textTheme.headlineLarge?.copyWith(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to create your first set.',
                    style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: vocabSets.length,
              itemBuilder: (context, index) {
                final set = vocabSets[index];
                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    title: Text(set.title, style: theme.textTheme.displaySmall?.copyWith(fontSize: 28)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        '${set.words.length} words | ${DateFormat.yMMMd().format(set.createdAt)}',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(LucideIcons.playCircle, size: 28),
                      onPressed: () {
                        if (set.words.isNotEmpty) {
                          vocabSetProvider.prepareTrainingSession({set.id});
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const QuizScreen(),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('This set is empty. Add some words first.')),
                          );
                        }
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SetDetailsScreen(setId: set.id),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateSetScreen()),
          );
        },
        child: const Icon(LucideIcons.plus, size: 28),
        tooltip: 'Create a new set',
      ),
    );
  }
}
