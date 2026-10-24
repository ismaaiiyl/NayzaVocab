import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/vocab_set_model.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';

class ExportSetCard extends StatelessWidget {
  final VocabSetModel set;
  final bool isSelected;
  final ValueChanged<bool?> onToggle;

  const ExportSetCard({
    super.key,
    required this.set,
    required this.isSelected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Card(
        color: isSelected ? AppTheme.cardDark : AppTheme.surfaceNavy,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected
                ? AppTheme.electricGold.withValues(alpha: 0.5)
                : Colors.transparent,
            width: 1,
          ),
        ),
        child: CheckboxListTile(
          value: isSelected,
          onChanged: onToggle,
          title: Text(
            set.title,
            style: TextStyle(
              color: isSelected ? AppTheme.electricGold : AppTheme.textMain,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            l10n.wordsCountLabel(set.words.length),
            style: const TextStyle(color: AppTheme.textDim, fontSize: 13),
          ),
          activeColor: AppTheme.electricGold,
          checkColor: AppTheme.darkNavy,
          secondary: Icon(
            LucideIcons.library,
            color: isSelected ? AppTheme.electricGold : AppTheme.textDim,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        ),
      ),
    );
  }
}
