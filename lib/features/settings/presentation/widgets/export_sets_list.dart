import 'package:flutter/material.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/features/settings/presentation/widgets/export_set_card.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/folder_model.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/vocab_set_model.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';

class ExportSetsList extends StatelessWidget {
  final List<VocabSetModel> vocabSets;
  final List<FolderModel> folders;
  final VocabSetProvider provider;
  final Set<String> selectedSetIds;
  final ValueChanged<String> onToggleSet;

  const ExportSetsList({
    super.key,
    required this.vocabSets,
    required this.folders,
    required this.provider,
    required this.selectedSetIds,
    required this.onToggleSet,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (vocabSets.isEmpty) {
      return Center(
        child: Text(
          l10n.noCollections,
          style: const TextStyle(color: AppTheme.textDim),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        ...folders.map((folder) {
          final setsInFolder = provider.getSetsByFolder(folder.id);
          if (setsInFolder.isEmpty) return const SizedBox.shrink();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
                child: Text(
                  folder.title.toUpperCase(),
                  style: const TextStyle(
                    color: AppTheme.electricGold,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              ...setsInFolder.map(
                (set) => ExportSetCard(
                  set: set,
                  isSelected: selectedSetIds.contains(set.id),
                  onToggle: (_) => onToggleSet(set.id),
                ),
              ),
              const SizedBox(height: 16),
            ],
          );
        }),
        if (provider.getSetsByFolder('uncategorized').isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
            child: Text(
              l10n.uncategorized,
              style: const TextStyle(
                color: AppTheme.textDim,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          ...provider.getSetsByFolder('uncategorized').map(
                (set) => ExportSetCard(
                  set: set,
                  isSelected: selectedSetIds.contains(set.id),
                  onToggle: (_) => onToggleSet(set.id),
                ),
              ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}
