import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/core/widgets/nayza_text_field.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/widgets/word_row_controllers.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';

class WordRowItem extends StatelessWidget {
  final WordRowControllers controllers;
  final VoidCallback onRemove;

  const WordRowItem({
    super.key,
    required this.controllers,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Expanded(
            child: NayzaTextField(
              controller: controllers.original,
              focusNode: controllers.focusNode,
              label: l10n.wordPlaceholder,
              hint: 'Word',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: NayzaTextField(
              controller: controllers.translation,
              label: l10n.translationPlaceholder,
              hint: 'Translation',
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(LucideIcons.trash2, color: AppTheme.error, size: 20),
          ),
        ],
      ),
    );
  }
}
