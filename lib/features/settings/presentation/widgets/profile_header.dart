import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/core/widgets/nayza_icon.dart';
import 'package:nayza_vocab/features/settings/presentation/dialogs/edit_profile_dialog.dart';
import 'package:nayza_vocab/features/settings/presentation/provider/settings_provider.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';

class ProfileHeader extends StatelessWidget {
  final int masteredWordsCount;

  const ProfileHeader({super.key, required this.masteredWordsCount});

  String _getRankTitle(int count, AppLocalizations l10n) {
    if (count >= 300) return l10n.rankWordMaster;
    if (count >= 100) return l10n.rankCommander;
    if (count >= 25) return l10n.rankAdvanced;
    return l10n.rankNovice;
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final l10n = AppLocalizations.of(context)!;
    final rankTitle = _getRankTitle(masteredWordsCount, l10n);

    return Column(
      children: [
        const SizedBox(height: 12),
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 86,
              height: 86,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.surfaceNavy,
                border: Border.all(color: AppTheme.electricGold, width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.electricGold.withValues(alpha: 0.25),
                    blurRadius: 18,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Center(
                child: NayzaIcon(size: 42, color: AppTheme.electricGold),
              ),
            ),
            GestureDetector(
              onTap: () => EditProfileDialog.show(context, settings),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.electricGold,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.darkNavy, width: 2),
                ),
                child: const Icon(LucideIcons.edit2, size: 14, color: AppTheme.darkNavy),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              settings.userName,
              style: const TextStyle(
                color: AppTheme.textMain,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 6),
            IconButton(
              icon: const Icon(LucideIcons.pencil, size: 16, color: AppTheme.textDim),
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              padding: EdgeInsets.zero,
              onPressed: () => EditProfileDialog.show(context, settings),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildBadge(LucideIcons.user, l10n.yearsOld(settings.userAge), AppTheme.info),
            const SizedBox(width: 8),
            _buildBadge(LucideIcons.languages, settings.targetLanguage, AppTheme.electricGold),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            color: AppTheme.electricGold.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.electricGold.withValues(alpha: 0.3)),
          ),
          child: Text(
            rankTitle,
            style: const TextStyle(
              color: AppTheme.electricGold,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildBadge(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.surfaceNavy,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
