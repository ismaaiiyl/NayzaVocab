import 'package:flutter/material.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/history_screen.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/select_collections_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SelectCollectionsScreen()),
                  );
                },
                child: const Text('Start Training'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
