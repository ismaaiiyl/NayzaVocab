import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/core/services/data_service.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:provider/provider.dart';

import 'package:nayza_vocab/features/settings/presentation/pages/export_selection_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SOZLAMALAR'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSettingsHeader('MA\'LUMOTLARNI BOSHQARISH'),
          const SizedBox(height: 12),
          _buildSettingsCard(
            context,
            title: 'Export (Zaxiralash)',
            subtitle: 'To\'plamlarni tanlab zaxira qilish',
            icon: LucideIcons.download,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ExportSelectionPage()),
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingsCard(
            context,
            title: 'Import (Tiklash)',
            subtitle: 'JSON fayldan to\'plamlarni yuklash',
            icon: LucideIcons.upload,
            onTap: () => _handleImport(context),
          ),
          const SizedBox(height: 48),
          _buildSettingsHeader('ILOVA HAQIDA'),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              'Nayza Vocab v1.0.0\nCreated for Nayzadorlar 🔱',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textDim,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          color: AppTheme.electricGold.withValues(alpha: 0.8),
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.surfaceNavy.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF233554),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.electricGold.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppTheme.electricGold, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textMain,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textDim,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              LucideIcons.chevronRight,
              color: AppTheme.textDim,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleImport(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final importedSets = await DataService.importSets();
      if (importedSets.isEmpty) return;

      if (!context.mounted) return;
      final provider = context.read<VocabSetProvider>();
      for (var set in importedSets) {
        await provider.addSet(set);
      }
      
      messenger.showSnackBar(
        SnackBar(content: Text('${importedSets.length} ta to\'plam muvaffaqiyatli import qilindi')),
      );
    } catch (e) {
      if (!context.mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text('Import xatoligi: $e')),
      );
    }
  }
}
