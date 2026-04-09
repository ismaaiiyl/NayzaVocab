import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/core/widgets/nayza_widgets.dart';
import 'package:nayza_vocab/core/services/data_service.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:provider/provider.dart';

class ExportSelectionPage extends StatefulWidget {
  const ExportSelectionPage({super.key});

  @override
  State<ExportSelectionPage> createState() => _ExportSelectionPageState();
}

class _ExportSelectionPageState extends State<ExportSelectionPage> {
  final Set<String> _selectedSetIds = {};

  @override
  void initState() {
    super.initState();
    // Pre-select all by default for convenience
    final provider = Provider.of<VocabSetProvider>(context, listen: false);
    _selectedSetIds.addAll(provider.vocabSets.map((s) => s.id));
  }

  void _toggleSet(String id) {
    setState(() {
      if (_selectedSetIds.contains(id)) {
        _selectedSetIds.remove(id);
      } else {
        _selectedSetIds.add(id);
      }
    });
  }

  void _toggleAll(bool selectAll, List<String> ids) {
    setState(() {
      if (selectAll) {
        _selectedSetIds.addAll(ids);
      } else {
        _selectedSetIds.clear();
      }
    });
  }

  Future<void> _handleExport() async {
    if (_selectedSetIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kamida bitta to\'plamni tanlang.')),
      );
      return;
    }

    final provider = Provider.of<VocabSetProvider>(context, listen: false);
    final selectedSets = provider.vocabSets.where((s) => _selectedSetIds.contains(s.id)).toList();

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator(color: AppTheme.electricGold)),
      );

      await DataService.exportSets(selectedSets);
      
      if (mounted) {
        Navigator.pop(context); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Eksport muvaffaqiyatli yakunlandi!')),
        );
        Navigator.pop(context); // Return to settings
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Eksportda xatolik: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vocabSets = Provider.of<VocabSetProvider>(context).vocabSets;
    final allIds = vocabSets.map((s) => s.id).toList();
    final allSelected = _selectedSetIds.length == vocabSets.length && vocabSets.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('TO\'PLAMLARNI TANLASH'),
      ),
      body: Column(
        children: [
          if (vocabSets.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    allSelected ? 'Barchasini bekor qilish' : 'Barchasini tanlash',
                    style: const TextStyle(color: AppTheme.textDim, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Checkbox(
                    value: allSelected,
                    onChanged: (val) => _toggleAll(val!, allIds),
                    activeColor: AppTheme.electricGold,
                    checkColor: AppTheme.darkNavy,
                  ),
                ],
              ),
            ),
          const Divider(color: Color(0xFF233554)),
          Expanded(
            child: vocabSets.isEmpty
                ? const Center(
                    child: Text('To\'plamlar mavjud emas.', style: TextStyle(color: AppTheme.textDim)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: vocabSets.length,
                    itemBuilder: (context, index) {
                      final set = vocabSets[index];
                      final isSelected = _selectedSetIds.contains(set.id);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Card(
                          color: isSelected ? const Color(0xFF1E2D4A) : AppTheme.surfaceNavy,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isSelected ? AppTheme.electricGold.withValues(alpha: 0.5) : Colors.transparent,
                              width: 1,
                            ),
                          ),
                          child: CheckboxListTile(
                            value: isSelected,
                            onChanged: (_) => _toggleSet(set.id),
                            title: Text(set.title, style: TextStyle(color: isSelected ? AppTheme.electricGold : AppTheme.textMain, fontWeight: FontWeight.bold)),
                            subtitle: Text('${set.words.length} so\'z', style: const TextStyle(color: AppTheme.textDim, fontSize: 13)),
                            activeColor: AppTheme.electricGold,
                            checkColor: AppTheme.darkNavy,
                            secondary: Icon(LucideIcons.library, color: isSelected ? AppTheme.electricGold : AppTheme.textDim),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: NayzaButton(
              text: 'EKSPORT QILISH (${_selectedSetIds.length})',
              icon: LucideIcons.download,
              onPressed: _handleExport,
            ),
          ),
        ],
      ),
    );
  }
}
