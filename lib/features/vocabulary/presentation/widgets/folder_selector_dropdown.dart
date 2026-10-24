import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';

class FolderSelectorDropdown extends StatelessWidget {
  final String? selectedFolderId;
  final ValueChanged<String?> onChanged;

  const FolderSelectorDropdown({
    super.key,
    required this.selectedFolderId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<VocabSetProvider>(
      builder: (context, provider, child) {
        return DropdownButtonFormField<String?>(
          initialValue: selectedFolderId,
          decoration: InputDecoration(
            labelText: l10n.folderName,
            prefixIcon: const Icon(LucideIcons.folder, size: 20, color: AppTheme.electricGold),
          ),
          dropdownColor: AppTheme.surfaceNavy,
          items: [
            DropdownMenuItem(value: null, child: Text(l10n.noFolder)),
            ...provider.folders.map((f) => DropdownMenuItem(value: f.id, child: Text(f.title))),
          ],
          onChanged: onChanged,
        );
      },
    );
  }
}
