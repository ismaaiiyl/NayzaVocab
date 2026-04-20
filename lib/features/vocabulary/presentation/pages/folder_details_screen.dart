import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/quiz_provider.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/vocab_set_model.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/folder_model.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';
import 'package:nayza_vocab/core/widgets/nayza_widgets.dart';

class FolderDetailsScreen extends StatelessWidget {
  final String folderId;

  const FolderDetailsScreen({super.key, required this.folderId});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<VocabSetProvider>(context);
    final l10n = AppLocalizations.of(context)!;
    
    final folder = folderId == 'difficult' 
        ? FolderModel(id: 'difficult', title: l10n.difficultCollectionsHeader, createdAt: DateTime.now())
        : (folderId == 'uncategorized' 
            ? FolderModel(id: 'uncategorized', title: l10n.noFolder, createdAt: DateTime.now())
            : provider.getFolderById(folderId));

    final sets = folderId == 'difficult'
        ? provider.getDifficultVirtualSets()
        : (folderId == 'uncategorized' 
            ? provider.getSetsByFolder(null) 
            : provider.getSetsByFolder(folderId));
    
    final theme = Theme.of(context);

    if (folder == null) {
      return Scaffold(body: Center(child: Text(l10n.setNotFound)));
    }

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
              itemBuilder: (context, index) => _buildSetCard(context, sets[index], theme),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed('create-set', extra: folderId == 'uncategorized' ? null : folderId),
        backgroundColor: AppTheme.electricGold,
        child: const Icon(LucideIcons.plus, color: AppTheme.darkNavy),
      ),
    );
  }

  Widget _buildSetCard(BuildContext context, VocabSetModel set, ThemeData theme) {
    final progress = set.progressPercentage;
    final l10n = AppLocalizations.of(context)!;
    final double titleFontSize = set.title.length > 20 ? 16 : 20;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Dismissible(
        key: Key('set-dismiss-${set.id}'),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: Colors.redAccent.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(LucideIcons.trash2, color: Colors.white),
        ),
        onDismissed: (direction) {
          context.read<VocabSetProvider>().deleteVocabSet(set.id);
        },
        child: Hero(
          tag: 'set-${set.id}',
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => context.pushNamed('set-details', pathParameters: {'id': set.id}),
              borderRadius: BorderRadius.circular(16),
              child: Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 12.0, top: 4.0),
                            child: _buildSetStatusIndicator(set),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        set.title,
                                        style: theme.textTheme.titleLarge?.copyWith(
                                          color: AppTheme.electricGold,
                                          fontSize: titleFontSize,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(LucideIcons.edit2, size: 16, color: AppTheme.textDim),
                                      onPressed: () => _showEditTitleDialog(context, set),
                                      padding: const EdgeInsets.all(12),
                                      constraints: const BoxConstraints(),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(LucideIcons.layers, size: 14, color: AppTheme.textDim),
                                    const SizedBox(width: 4),
                                    Text(l10n.wordCountLabel(set.words.length), style: const TextStyle(color: AppTheme.textDim, fontSize: 12)),
                                    const SizedBox(width: 12),
                                    const Icon(LucideIcons.calendar, size: 14, color: AppTheme.textDim),
                                    const SizedBox(width: 4),
                                    Text(DateFormat.yMMMd().format(set.createdAt), style: const TextStyle(color: AppTheme.textDim, fontSize: 12)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    height: 48, width: 48,
                                    child: CircularProgressIndicator(
                                      value: progress / 100,
                                      backgroundColor: AppTheme.cardDark.withValues(alpha: 0.5),
                                      color: progress == 100 ? Colors.greenAccent : AppTheme.electricGold,
                                      strokeWidth: 4,
                                    ),
                                  ),
                                  Text('${progress.toInt()}%', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              IconButton(
                                onPressed: () {
                                  if (set.words.isNotEmpty) {
                                    context.read<QuizProvider>().prepareSession(set.words);
                                    context.pushNamed('quiz-setup');
                                  }
                                },
                                padding: const EdgeInsets.all(8),
                                icon: const Icon(LucideIcons.playCircle, color: AppTheme.electricGold, size: 32),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      NayzaProgressBar(
                        current: progress.toInt(),
                        total: 100,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSetStatusIndicator(VocabSetModel set) {
    final progress = set.progressPercentage;
    if (progress == 100) {
      return const Icon(LucideIcons.star, color: AppTheme.electricGold, size: 28);
    } else if (progress > 0) {
      return Icon(LucideIcons.starHalf, color: AppTheme.electricGold.withValues(alpha: 0.5), size: 28);
    }
    return Icon(LucideIcons.star, color: AppTheme.textDim.withValues(alpha: 0.2), size: 28);
  }

  void _showEditTitleDialog(BuildContext context, VocabSetModel set) {
    showDialog<void>(
      context: context,
      builder: (ctx) => _EditTitleDialog(set: set),
    );
  }
}

class _EditTitleDialog extends StatefulWidget {
  final VocabSetModel set;
  const _EditTitleDialog({required this.set});

  @override
  State<_EditTitleDialog> createState() => _EditTitleDialogState();
}

class _EditTitleDialogState extends State<_EditTitleDialog> {
  late final TextEditingController _titleController;
  String? _selectedFolderId;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.set.title);
    _selectedFolderId = widget.set.folderId;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _save() {
    final newTitle = _titleController.text.trim();
    if (newTitle.isEmpty) return;
    context.read<VocabSetProvider>().updateVocabSet(
          widget.set.copyWith(
            title: newTitle,
            folderId: _selectedFolderId,
          ),
        );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      backgroundColor: AppTheme.surfaceNavy,
      title: Text(
        l10n.editSetTitle,
        style: const TextStyle(color: AppTheme.electricGold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            autofocus: true,
            decoration: InputDecoration(labelText: l10n.collectionNameLabel),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          Consumer<VocabSetProvider>(
            builder: (context, provider, child) {
              final folders = provider.folders;
              return DropdownButtonFormField<String?>(
                value: _selectedFolderId,
                decoration: InputDecoration(
                  labelText: l10n.folderName,
                  prefixIcon: const Icon(LucideIcons.folder, size: 20, color: AppTheme.electricGold),
                ),
                dropdownColor: AppTheme.surfaceNavy,
                items: [
                  DropdownMenuItem(value: null, child: Text(l10n.noFolder)),
                  ...folders.map((f) => DropdownMenuItem(value: f.id, child: Text(f.title))),
                ],
                onChanged: (v) => setState(() => _selectedFolderId = v),
              );
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel, style: const TextStyle(color: AppTheme.textDim)),
        ),
        ElevatedButton(
          onPressed: _save,
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
