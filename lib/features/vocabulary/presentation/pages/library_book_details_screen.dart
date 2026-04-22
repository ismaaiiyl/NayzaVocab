import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/library_provider.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/folder_model.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';

class BookDetailsScreen extends StatefulWidget {
  final String bookId;
  const BookDetailsScreen({super.key, required this.bookId});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  List<Map<String, dynamic>> _units = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUnits();
  }

  Future<void> _loadUnits() async {
    final units = await context.read<LibraryProvider>().fetchUnits(widget.bookId);
    if (mounted) {
      setState(() {
        _units = units;
        _isLoading = false;
      });
    }
  }

  Future<String> _getOrCreateFolder() async {
    final vocabProvider = context.read<VocabSetProvider>();
    final libraryProvider = context.read<LibraryProvider>();
    final bookTitle = libraryProvider.books.firstWhere((b) => b['id'] == widget.bookId)['title'];
    
    final existingFolder = vocabProvider.folders.cast<FolderModel?>().firstWhere(
      (f) => f?.title == bookTitle,
      orElse: () => null,
    );

    if (existingFolder != null) {
      return existingFolder.id;
    } else {
      await vocabProvider.createFolder(bookTitle);
      // Re-fetch to get the new ID
      final newFolder = vocabProvider.folders.firstWhere((f) => f.title == bookTitle);
      return newFolder.id;
    }
  }

  bool _isUnitAlreadyInstalled(String title) {
    final vocabProvider = context.read<VocabSetProvider>();
    return vocabProvider.vocabSets.any((s) => s.title == title);
  }

  Future<void> _downloadUnit(Map<String, dynamic> unit, {String? targetFolderId, bool silent = false}) async {
    final l10n = AppLocalizations.of(context)!;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    
    final unitTitle = unit['title'].toString();
    if (_isUnitAlreadyInstalled(unitTitle)) {
      if (!silent) {
        scaffoldMessenger.showSnackBar(SnackBar(content: Text('$unitTitle ${l10n.installed}')));
      }
      return;
    }

    if (!silent) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text('$unitTitle ${l10n.downloading}')));
    }

    final libraryProvider = context.read<LibraryProvider>();
    final vocabProvider = context.read<VocabSetProvider>();

    // 1. Get folder
    final folderId = targetFolderId ?? await _getOrCreateFolder();

    // 2. Download unit
    final set = await libraryProvider.downloadUnitAsSet(unit);
    
    if (set != null) {
      final setInFolder = set.copyWith(folderId: folderId);
      await vocabProvider.addSet(setInFolder);
      
      if (!silent) {
        scaffoldMessenger.clearSnackBars();
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(l10n.importSuccess(1)),
            backgroundColor: Colors.greenAccent.withValues(alpha: 0.8),
          ),
        );
      }
    } else if (!silent) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text(l10n.noInternetMessage)));
    }
  }

  Future<void> _downloadAll() async {
    final l10n = AppLocalizations.of(context)!;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    
    // 1. Filter out already installed units
    final uninstalledUnits = _units.where((u) => !_isUnitAlreadyInstalled(u['title'])).toList();
    
    if (uninstalledUnits.isEmpty) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text(l10n.installed)));
      return;
    }

    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text(l10n.downloading), duration: const Duration(seconds: 3)),
    );

    // 2. Get folder once (Crucial for avoiding multiple folders)
    final folderId = await _getOrCreateFolder();

    // 3. Download ALL in parallel for maximum speed
    try {
      await Future.wait(
        uninstalledUnits.map((unit) => _downloadUnit(unit, targetFolderId: folderId, silent: true))
      );

      scaffoldMessenger.clearSnackBars();
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(l10n.importSuccess(uninstalledUnits.length)),
          backgroundColor: Colors.greenAccent.withValues(alpha: 0.8),
        ),
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(l10n.noInternetMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LibraryProvider>();
    final book = provider.books.firstWhere((b) => b['id'] == widget.bookId);

    return Scaffold(
      appBar: AppBar(
        title: Text(book['title'].toString().toUpperCase()),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.electricGold))
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _buildBookHeader(book),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final unit = _units[index];
                        return _buildUnitItem(unit);
                      },
                      childCount: _units.length,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildBookHeader(Map<String, dynamic> book) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceNavy.withValues(alpha: 0.5),
        border: const Border(bottom: BorderSide(color: AppTheme.borderNavy)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: 'book-cover-${book['id']}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                book['cover_url'] ?? '',
                width: 100,
                height: 140,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 100,
                  height: 140,
                  color: AppTheme.darkNavy,
                  child: const Icon(LucideIcons.book, color: AppTheme.textDim, size: 40),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book['title'],
                  style: const TextStyle(color: AppTheme.textMain, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildInfoBadge(book['target_lang'].toString().toUpperCase(), AppTheme.electricGold),
                    const SizedBox(width: 8),
                    _buildInfoBadge('${_units.length} UNITS', AppTheme.textDim),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  book['description'] ?? '',
                  style: const TextStyle(color: AppTheme.textDim, fontSize: 14, height: 1.4),
                ),
                const SizedBox(height: 16),
                if (_units.isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _downloadAll,
                      icon: const Icon(LucideIcons.downloadCloud, size: 18),
                      label: Text(l10n.downloadAll),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.electricGold.withValues(alpha: 0.1),
                        foregroundColor: AppTheme.electricGold,
                        side: const BorderSide(color: AppTheme.electricGold),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
      ),
    );
  }

  Widget _buildUnitItem(Map<String, dynamic> unit) {
    return Consumer2<LibraryProvider, VocabSetProvider>(
      builder: (context, libraryProvider, vocabProvider, child) {
        final l10n = AppLocalizations.of(context)!;
        final unitId = unit['id'].toString();
        final isDownloading = libraryProvider.isUnitDownloading(unitId);
        
        // Tekshiramiz: bu unit allaqachon yuklanganmi? (Sarlavha bo'yicha)
        final isInstalled = vocabProvider.vocabSets.any((s) => s.title == unit['title']);

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: isInstalled ? 0 : 2,
          color: isInstalled ? AppTheme.surfaceNavy.withValues(alpha: 0.3) : AppTheme.surfaceNavy,
          child: ListTile(
            leading: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isInstalled 
                    ? Colors.greenAccent.withValues(alpha: 0.1)
                    : AppTheme.electricGold.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isInstalled 
                    ? const Icon(LucideIcons.check, color: Colors.greenAccent, size: 16)
                    : Text(
                        '${unit['index']}',
                        style: const TextStyle(color: AppTheme.electricGold, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
            title: Text(
              unit['title'],
              style: TextStyle(
                color: isInstalled ? AppTheme.textDim : AppTheme.textMain,
                fontWeight: isInstalled ? FontWeight.normal : FontWeight.w600,
              ),
            ),
            subtitle: Text(
              l10n.wordCountLabel_short(unit['wordCount'] ?? 0),
              style: TextStyle(color: isInstalled ? AppTheme.textDim.withValues(alpha: 0.5) : AppTheme.textDim, fontSize: 12),
            ),
            trailing: isDownloading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.electricGold),
                  )
                : isInstalled
                    ? Text(l10n.installed, style: const TextStyle(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold))
                    : IconButton(
                        icon: const Icon(LucideIcons.download, color: AppTheme.electricGold, size: 20),
                        onPressed: () => _downloadUnit(unit),
                      ),
          ),
        );
      },
    );
  }
}
