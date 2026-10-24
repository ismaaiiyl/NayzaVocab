import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/core/utils/audio_helper.dart';
import 'package:nayza_vocab/features/settings/presentation/provider/settings_provider.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/folder_model.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/dialogs/create_or_rename_folder_dialog.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/dialogs/delete_folder_dialog.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/dialogs/folder_options_sheet.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/widgets/dashboard_action_buttons.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/widgets/dashboard_recent_sets.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/widgets/dashboard_stats_card.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/widgets/difficult_words_banner.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/widgets/folder_card.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Timer? _debounce;

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _searchQuery = query);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _showFolderOptions(BuildContext context, FolderModel folder) {
    FolderOptionsSheet.show(
      context: context,
      folder: folder,
      onRename: () => CreateOrRenameFolderDialog.show(
        context,
        folderId: folder.id,
        initialTitle: folder.title,
      ),
      onDelete: () => DeleteFolderDialog.show(context, folder),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vocabSetProvider = context.watch<VocabSetProvider>();
    final settings = context.watch<SettingsProvider>();
    final l10n = AppLocalizations.of(context)!;

    final filteredFolders = vocabSetProvider.folders.where((f) {
      return f.title.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    final uncategorizedSets = vocabSetProvider.getSetsByFolder(null);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle.toUpperCase()),
        actions: [
          IconButton(
            icon: Icon(
              settings.isMuted ? LucideIcons.volumeX : LucideIcons.volume2,
              color: AppTheme.electricGold,
            ),
            tooltip: settings.isMuted ? l10n.muteOn : l10n.muteOff,
            onPressed: () {
              settings.toggleMute();
              AudioHelper().isMuted = settings.isMuted;
            },
          ),
          IconButton(
            icon: const Icon(LucideIcons.folderPlus, color: AppTheme.electricGold),
            tooltip: l10n.createFolder,
            onPressed: () => CreateOrRenameFolderDialog.show(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          DashboardStatsCard(provider: vocabSetProvider),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: DifficultWordsBanner(provider: vocabSetProvider),
          ),
          const DashboardActionButtons(),
          if (_searchQuery.isEmpty)
            DashboardRecentSets(provider: vocabSetProvider),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: l10n.searchHint,
                prefixIcon: const Icon(LucideIcons.search, color: AppTheme.textDim),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(LucideIcons.x, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text(
              l10n.myCollectionsHeader,
              style: const TextStyle(
                color: AppTheme.textDim,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                fontSize: 13,
              ),
            ),
          ),
          if (filteredFolders.isEmpty && uncategorizedSets.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: Text(
                  _searchQuery.isEmpty ? l10n.noCollections : l10n.noResults,
                  style: const TextStyle(color: AppTheme.textDim),
                ),
              ),
            )
          else ...[
            ...filteredFolders.map(
              (folder) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: FolderCard(
                  folder: folder,
                  onLongPress: () => _showFolderOptions(context, folder),
                ),
              ),
            ),
            if (uncategorizedSets.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: FolderCard(
                  folder: FolderModel(
                    id: 'uncategorized',
                    title: l10n.noFolder,
                    createdAt: DateTime.now(),
                  ),
                ),
              ),
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed('create-set'),
        backgroundColor: AppTheme.electricGold,
        tooltip: l10n.create,
        child: const Icon(LucideIcons.plus, color: AppTheme.darkNavy),
      ),
    );
  }
}
