import 'package:flutter/material.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/quiz_screen.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:provider/provider.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/core/widgets/nayza_widgets.dart';
import 'package:lucide_icons/lucide_icons.dart';

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
    final allSelected = _selectedSetIds.length == allSets.length && allSets.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('TO\'PLAMLARNI TANLASH'),
      ),
      body: allSets.isEmpty
          ? const Center(
              child: Text(
                'Avval kamida bitta to\'plam yaratishingiz kerak.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.textDim),
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Text(
                        allSelected ? 'Barchasini bekor qilish' : 'Barchasini tanlash',
                        style: const TextStyle(color: AppTheme.textDim, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Checkbox(
                        value: allSelected,
                        onChanged: (value) => _toggleSelectAll(value!, allSetIds),
                        activeColor: AppTheme.electricGold,
                        checkColor: AppTheme.darkNavy,
                      ),
                    ],
                  ),
                ),
                const Divider(color: Color(0xFF233554)),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: allSets.length,
                    itemBuilder: (context, index) {
                      final set = allSets[index];
                      final isSelected = _selectedSetIds.contains(set.id);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Card(
                          color: isSelected ? const Color(0xFF1E2D4A) : AppTheme.surfaceNavy,
                          child: ListTile(
                            onTap: () => _toggleSetSelection(set.id),
                            title: Text(set.title, style: TextStyle(color: isSelected ? AppTheme.electricGold : AppTheme.textMain, fontWeight: FontWeight.bold)),
                            subtitle: Text('${set.words.length} so\'z', style: const TextStyle(color: AppTheme.textDim)),
                            trailing: Checkbox(
                              value: isSelected,
                              onChanged: (value) => _toggleSetSelection(set.id),
                              activeColor: AppTheme.electricGold,
                              checkColor: AppTheme.darkNavy,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (_selectedSetIds.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Hero(
                      tag: 'start-training-btn',
                      child: NayzaButton(
                        text: 'TESTNI BOSHLASH',
                        icon: LucideIcons.play,
                        onPressed: () {
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
                              const SnackBar(content: Text('Tanlangan to\'plamlar bo\'sh.')),
                            );
                          }
                        },
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
