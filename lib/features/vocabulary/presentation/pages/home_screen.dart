import 'package:flutter/material.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/history_screen.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/training_screen.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocabulary_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showAddWordSheet(BuildContext context) {
    final originalController = TextEditingController();
    final translationController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Add New Word', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 20),
              TextFormField(
                controller: originalController,
                decoration: const InputDecoration(hintText: 'Original Word (e.g., Apple)'),
                validator: (value) => value!.isEmpty ? 'Cannot be empty' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: translationController,
                decoration: const InputDecoration(hintText: 'Translation (e.g., Olma)'),
                validator: (value) => value!.isEmpty ? 'Cannot be empty' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Provider.of<VocabularyProvider>(context, listen: false).addWord(
                      originalController.text,
                      translationController.text,
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add Word'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NayzaVocab'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HistoryScreen()),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'start-training-btn',
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
                onPressed: () {
                   Provider.of<VocabularyProvider>(context, listen: false).getTrainingList(10);
                   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TrainingScreen()),
                  );
                },
                child: const Text('Start Training'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddWordSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
