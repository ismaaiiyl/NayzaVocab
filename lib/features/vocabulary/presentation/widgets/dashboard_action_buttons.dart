import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/widgets/nayza_button.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';

class DashboardActionButtons extends StatelessWidget {
  const DashboardActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: NayzaButton(
              text: l10n.startTest,
              icon: LucideIcons.play,
              onPressed: () => context.pushNamed('select-collections'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: NayzaButton(
              text: l10n.matchingGame,
              icon: LucideIcons.layoutGrid,
              onPressed: () => context.pushNamed(
                'select-collections',
                queryParameters: {'mode': 'matching'},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
