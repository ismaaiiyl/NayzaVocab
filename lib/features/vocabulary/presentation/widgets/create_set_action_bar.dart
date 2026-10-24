import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/core/widgets/nayza_button.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';

class CreateSetActionBar extends StatelessWidget {
  final VoidCallback onAddRow;
  final VoidCallback onBulkPaste;

  const CreateSetActionBar({
    super.key,
    required this.onAddRow,
    required this.onBulkPaste,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: NayzaButton(
              text: l10n.addRowButton,
              icon: LucideIcons.plus,
              onPressed: onAddRow,
              isFullWidth: true,
            ),
          ),
          const SizedBox(width: 16),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.surfaceNavy,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.borderNavy),
            ),
            child: IconButton(
              icon: const Icon(LucideIcons.clipboardPaste, color: AppTheme.electricGold),
              onPressed: onBulkPaste,
              tooltip: 'Paste from clipboard',
              padding: const EdgeInsets.all(14),
            ),
          ),
        ],
      ),
    );
  }
}
