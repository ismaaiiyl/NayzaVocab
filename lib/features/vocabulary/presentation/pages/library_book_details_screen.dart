import 'package:flutter/material.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/folder_model.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/library_provider.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/widgets/book_details_header.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/widgets/library_unit_item.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';

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
    if (!mounted) return;
    setState(() {
      _units = units;
      _isLoading = false;
    });
  }

  Future<String> _getOrCreateFolder() async {
    final vocabProvider = context.read<VocabSetProvider>();
    final libraryProvider = context.read<LibraryProvider>();
    final bookTitle =
        (libraryProvider.books.firstWhere((b) => b['id'] == widget.bookId)['title'] as String?) ??
            '';

    final existingFolder = vocabProvider.folders.cast<FolderModel?>().firstWhere(
          (f) => f?.title == bookTitle,
          orElse: () => null,
        );

    if (existingFolder != null) {
      return existingFolder.id;
    }

    await vocabProvider.createFolder(bookTitle);
    final newFolder = vocabProvider.folders.firstWhere((f) => f.title == bookTitle);
    return newFolder.id;
  }

  bool _isUnitAlreadyInstalled(String title) {
    final vocabProvider = context.read<VocabSetProvider>();
    return vocabProvider.vocabSets.any((s) => s.title == title);
  }

  Future<void> _downloadUnit(
    Map<String, dynamic> unit, {
    String? targetFolderId,
    bool silent = false,
  }) async {
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

    final folderId = targetFolderId ?? await _getOrCreateFolder();
    final set = await libraryProvider.downloadUnitAsSet(unit);

    if (set != null) {
      final setInFolder = set.copyWith(folderId: folderId);
      await vocabProvider.addSet(setInFolder);

      if (!silent) {
        scaffoldMessenger.clearSnackBars();
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(l10n.importSuccess(1)),
            backgroundColor: AppTheme.success.withValues(alpha: 0.9),
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

    final uninstalledUnits = _units
        .where((u) => !_isUnitAlreadyInstalled((u['title'] as String?) ?? ''))
        .toList();

    if (uninstalledUnits.isEmpty) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text(l10n.installed)));
      return;
    }

    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text(l10n.downloading), duration: const Duration(seconds: 3)),
    );

    final folderId = await _getOrCreateFolder();

    try {
      await Future.wait(
        uninstalledUnits.map(
          (unit) => _downloadUnit(unit, targetFolderId: folderId, silent: true),
        ),
      );

      scaffoldMessenger.clearSnackBars();
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(l10n.importSuccess(uninstalledUnits.length)),
          backgroundColor: AppTheme.success.withValues(alpha: 0.9),
        ),
      );
    } catch (e, stack) {
      debugPrint('Download all error: $e\n$stack');
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
                  child: BookDetailsHeader(
                    book: book,
                    unitsCount: _units.length,
                    onDownloadAll: _downloadAll,
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final unit = _units[index];
                        return LibraryUnitItem(
                          unit: unit,
                          onDownload: () => _downloadUnit(unit),
                        );
                      },
                      childCount: _units.length,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
