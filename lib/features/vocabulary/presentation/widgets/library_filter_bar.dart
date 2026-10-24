import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/library_provider.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';

class LibraryFilterBar extends StatelessWidget {
  const LibraryFilterBar({super.key});

  Widget _buildFilterChip(
    BuildContext context,
    String? value,
    String label, {
    required bool isLang,
  }) {
    final provider = context.read<LibraryProvider>();
    final isSelected =
        isLang ? provider.selectedLang == value : provider.selectedCategory == value;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        selected: isSelected,
        onSelected: (_) {
          if (isLang) {
            provider.setSelectedLang(value);
          } else {
            provider.setSelectedCategory(value);
          }
        },
        selectedColor: AppTheme.electricGold.withValues(alpha: 0.2),
        backgroundColor: AppTheme.darkNavy,
        labelStyle: TextStyle(color: isSelected ? AppTheme.electricGold : AppTheme.textDim),
        side: BorderSide(color: isSelected ? AppTheme.electricGold : AppTheme.borderNavy),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LibraryProvider>();
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceNavy.withValues(alpha: 0.5),
        border: const Border(bottom: BorderSide(color: AppTheme.borderNavy)),
      ),
      child: Column(
        children: [
          TextField(
            onChanged: provider.setSearchQuery,
            decoration: InputDecoration(
              hintText: l10n.searchHint,
              prefixIcon: const Icon(LucideIcons.search, size: 20),
              filled: true,
              fillColor: AppTheme.darkNavy,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(context, null, l10n.all.toUpperCase(), isLang: true),
                _buildFilterChip(context, 'en', l10n.englishLang.toUpperCase(), isLang: true),
                _buildFilterChip(context, 'ru', l10n.russianLang.toUpperCase(), isLang: true),
                _buildFilterChip(context, 'ar', l10n.arabicLang.toUpperCase(), isLang: true),
                _buildFilterChip(context, 'de', l10n.germanLang.toUpperCase(), isLang: true),
                _buildFilterChip(context, 'ko', l10n.koreanLang.toUpperCase(), isLang: true),
              ],
            ),
          ),
          if (provider.categories.isNotEmpty) ...[
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip(context, null, l10n.allTopics.toUpperCase(), isLang: false),
                  ...provider.categories.map(
                    (cat) => _buildFilterChip(
                      context,
                      cat,
                      cat.toUpperCase(),
                      isLang: false,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
