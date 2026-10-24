import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/folder_model.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/widgets/vocab_set_card.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';

class FolderDetailsScreen extends StatelessWidget {
  final String folderId;

  const FolderDetailsScreen({super.key, required this.folderId});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<VocabSetProvider>(context);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final folder = folderId == 'difficult'
        ? FolderModel(id: 'difficult', title: l10n.difficultCollectionsHeader, createdAt: DateTime.now())
        : (folderId == 'uncategorized'
            ? FolderModel(id: 'uncategorized', title: l10n.noFolder, createdAt: DateTime.now())
            : provider.getFolderById(folderId));

    if (folder == null) {
      return Scaffold(body: Center(child: Text(l10n.setNotFound)));
    }

    final sets = folderId == 'difficult'
        ? provider.getDifficultVirtualSets()
        : (folderId == 'uncategorized'
            ? provider.getSetsByFolder(null)
            : provider.getSetsByFolder(folderId));

    return Scaffold(
      appBar: AppBar(
        title: Text(folder.title.toUpperCase()),
      ),
      body: sets.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(LucideIcons.layers, size: 80, color: AppTheme.textDim),
                  const SizedBox(height: 20),
                  Text(l10n.noCollections, style: theme.textTheme.titleLarge),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sets.length,
              itemBuilder: (context, index) => VocabSetCard(set: sets[index]),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed(
          'create-set',
          extra: folderId == 'uncategorized' ? null : folderId,
        ),
        backgroundColor: AppTheme.electricGold,
        child: const Icon(LucideIcons.plus, color: AppTheme.darkNavy),
      ),
    );
  }
}
