import 'package:flutter/material.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';

class UpdateReleaseNotesCard extends StatelessWidget {
  final String releaseNotes;

  const UpdateReleaseNotesCard({
    super.key,
    required this.releaseNotes,
  });

  @override
  Widget build(BuildContext context) {
    final notes = releaseNotes.trim();
    if (notes.isEmpty) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context)!;

    return Container(
      constraints: const BoxConstraints(maxHeight: 120),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.darkNavy.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.whatsNew,
              style: const TextStyle(
                color: AppTheme.electricGold,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              notes,
              style: const TextStyle(color: AppTheme.textDim, fontSize: 13, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
