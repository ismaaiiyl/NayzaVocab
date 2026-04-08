import 'package:flutter/material.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/quiz_screen.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:provider/provider.dart';

class SelectCollectionsScreen extends StatefulWidget {
  const SelectCollectionsScreen({super.key});

  @override
  State<SelectCollectionsScreen> createState() => _SelectCollectionsScreenState();
}

class _SelectCollectionsScreenState extends State<SelectCollectionsScreen> {
  final Set<String> _selectedSetIds = {};

  void _toggleSetSelection(String setId) {
    setState(() {
      if (_selectedSetIds.contains(setId)) {
        _selectedSetIds.remove(setId);
      } else {
        _selectedSetIds.add(setId);
      }
    });
  }

  void _toggleSelectAll(bool selectAll, List<String> allSetIds) {
    setState(() {
      if (selectAll) {
        _selectedSetIds.addAll(allSetIds);
      } else {
        _selectedSetIds.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vocabSetProvider = Provider.of<VocabSetProvider>(context);
    final allSets = vocabSetProvider.vocabSets;
    final allSetIds = allSets.map((set) => set.id).toList();
    final bool allSelected = _selectedSetIds.length == allSets.length && allSets.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Sets for Quiz'),
      ),
      body: allSets.isEmpty
          ? const Center(
              child: Text(
                'You need to create at least one vocabulary set first.',
                textAlign: TextAlign.center,
              ),
            )
          : Column(
              children: [
                ListTile(
                  title: Text(allSelected ? 'Deselect All' : 'Select All'),
                  trailing: Checkbox(
                    value: allSelected,
                    onChanged: (value) => _toggleSelectAll(value!, allSetIds),
                  ),
                  onTap: () => _toggleSelectAll(!allSelected, allSetIds),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    itemCount: allSets.length,
                    itemBuilder: (context, index) {
                      final set = allSets[index];
                      final isSelected = _selectedSetIds.contains(set.id);

                      return ListTile(
                        title: Text(set.title),
                        subtitle: Text('${set.words.length} words'),
                        trailing: Checkbox(
                          value: isSelected,
                          onChanged: (value) => _toggleSetSelection(set.id),
                        ),
                        onTap: () => _toggleSetSelection(set.id),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: _selectedSetIds.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                if (_selectedSetIds.isNotEmpty) {
                  final provider = Provider.of<VocabSetProvider>(context, listen: false);
                  provider.prepareTrainingSession(_selectedSetIds);

                  if (provider.trainingList.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QuizScreen(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Selected sets are empty. Add some words first.')),
                    );
                  }
                }
              },
              label: const Text('Start Quiz'),
              icon: const Icon(Icons.play_arrow),
            )
          : null,
    );
  }
}
