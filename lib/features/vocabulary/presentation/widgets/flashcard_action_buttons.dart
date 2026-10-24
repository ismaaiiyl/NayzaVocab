import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/widgets/nayza_widgets.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';

class FlashcardActionButtons extends StatelessWidget {
  final ValueChanged<bool> onMastery;

  const FlashcardActionButtons({
    super.key,
    required this.onMastery,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: NayzaButton(
            text: l10n.dontKnowWord.toUpperCase(),
            icon: LucideIcons.xCircle,
            onPressed: () => onMastery(false),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: NayzaButton(
            text: l10n.knowWord.toUpperCase(),
            icon: LucideIcons.checkCircle,
            onPressed: () => onMastery(true),
          ),
        ),
      ],
    );
  }
}
