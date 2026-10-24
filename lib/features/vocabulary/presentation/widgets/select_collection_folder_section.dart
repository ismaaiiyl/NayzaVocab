import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/vocab_set_model.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';

class SelectCollectionFolderSection extends StatelessWidget {
  final String folderId;
  final String title;
  final List<VocabSetModel> sets;
  final Set<String> selectedSetIds;
  final ValueChanged<String> onToggleSet;

  const SelectCollectionFolderSection({
    super.key,
    required this.folderId,
    required this.title,
    required this.sets,
    required this.selectedSetIds,
    required this.onToggleSet,
  });

  @override
  Widget build(BuildContext context) {
    if (sets.isEmpty) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context)!;

    final isDifficult = folderId == 'difficult';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Icon(
                isDifficult ? LucideIcons.flame : LucideIcons.folder,
                size: 18,
                color: isDifficult ? AppTheme.error : AppTheme.electricGold,
              ),
              const SizedBox(width: 8),
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  color: isDifficult ? AppTheme.error : AppTheme.textDim,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
        ),
        ...sets.map((set) {
          final isSelected = selectedSetIds.contains(set.id);
          final groupNum = int.tryParse(set.id.replaceAll('difficult-group-', ''));
          final displayTitle = (isDifficult && groupNum != null)
              ? l10n.difficultSetTitle(groupNum)
              : set.title;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Card(
              color: isSelected ? AppTheme.cardDark : AppTheme.surfaceNavy,
              child: ListTile(
                onTap: () => onToggleSet(set.id),
                title: Text(
                  displayTitle,
                  style: TextStyle(
                    color: isSelected
                        ? AppTheme.electricGold
                        : AppTheme.textMain,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  l10n.wordCountLabel(set.words.length),
                  style: const TextStyle(
                    color: AppTheme.textDim,
                    fontSize: 12,
                  ),
                ),
                trailing: Checkbox(
                  value: isSelected,
                  onChanged: (value) => onToggleSet(set.id),
                  activeColor: AppTheme.electricGold,
                  checkColor: AppTheme.darkNavy,
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 16),
      ],
    );
  }
}
