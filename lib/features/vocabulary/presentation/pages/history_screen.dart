import 'package:flutter/material.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/create_set_screen.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vocabulary Sets'),
        centerTitle: true,
      ),
      body: Consumer<VocabSetProvider>(
        builder: (context, provider, child) {
          if (provider.vocabSets.isEmpty) {
            return const Center(
              child: Text('No vocabulary sets found. Create one!'),
            );
          }
          return ListView.builder(
            itemCount: provider.vocabSets.length,
            itemBuilder: (context, index) {
              final set = provider.vocabSets[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(set.title),
                  subtitle: Text('${set.words.length} words'),
                  trailing: Text(set.createdAt.toString().substring(0, 10)),
                  onTap: () {
                    // Navigate to SetDetailsScreen
                  },
                ),
              );
            },
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
        child: const Icon(Icons.add),
      ),
    );
  }
}
