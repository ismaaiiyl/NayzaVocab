import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/features/settings/presentation/provider/settings_provider.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';

class MatchingGameAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onToggleMute;

  const MatchingGameAppBar({super.key, required this.onToggleMute});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final l10n = AppLocalizations.of(context)!;

    return AppBar(
      title: Text(l10n.matchingGameTitle),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: onToggleMute,
          icon: Icon(
            settings.isMuted ? LucideIcons.volumeX : LucideIcons.volume2,
            color: settings.isMuted ? AppTheme.error : AppTheme.electricGold,
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
