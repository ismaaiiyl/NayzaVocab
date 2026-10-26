import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
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
    final vocab = context.read<VocabSetProvider>();
    final lib = context.read<LibraryProvider>();
    final bookTitle = (lib.books.firstWhere((b) => b['id'] == widget.bookId)['title'] as String?) ?? '';
    final existing = vocab.folders.cast<FolderModel?>().firstWhere((f) => f?.title == bookTitle, orElse: () => null);
    if (existing != null) return existing.id;
    await vocab.createFolder(bookTitle);
    return vocab.folders.firstWhere((f) => f.title == bookTitle).id;
  }

  bool _isUnitAlreadyInstalled(String title) {
    return context.read<VocabSetProvider>().vocabSets.any((s) => s.title == title);
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
      if (!silent) scaffoldMessenger.showSnackBar(SnackBar(content: Text('$unitTitle ${l10n.installed}')));
      return;
    }

    if (!silent) scaffoldMessenger.showSnackBar(SnackBar(content: Text('$unitTitle ${l10n.downloading}')));
    final folderId = targetFolderId ?? await _getOrCreateFolder();
    if (!mounted) return;
    final set = await context.read<LibraryProvider>().downloadUnitAsSet(unit);

    if (set != null && mounted) {
      await context.read<VocabSetProvider>().addSet(set.copyWith(folderId: folderId));
      if (!silent) {
        scaffoldMessenger.clearSnackBars();
        scaffoldMessenger.showSnackBar(SnackBar(
          content: Text(l10n.importSuccess(1)),
          backgroundColor: AppTheme.success.withValues(alpha: 0.9),
        ));
      }
    } else if (!silent) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text(l10n.noInternetMessage)));
    }
  }

  Future<void> _downloadAll() async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final uninstalled = _units.where((u) => !_isUnitAlreadyInstalled((u['title'] as String?) ?? '')).toList();

    if (uninstalled.isEmpty) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.installed)));
      return;
    }

    messenger.showSnackBar(SnackBar(content: Text(l10n.downloading), duration: const Duration(seconds: 3)));
    final folderId = await _getOrCreateFolder();

    try {
      await Future.wait(uninstalled.map((u) => _downloadUnit(u, targetFolderId: folderId, silent: true)));
      messenger.clearSnackBars();
      messenger.showSnackBar(SnackBar(
        content: Text(l10n.importSuccess(uninstalled.length)),
        backgroundColor: AppTheme.success.withValues(alpha: 0.9),
      ));
    } catch (e, stack) {
      debugPrint('Download all error: $e\n$stack');
      messenger.showSnackBar(SnackBar(content: Text(l10n.noInternetMessage)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LibraryProvider>();
    final book = provider.books.firstWhere((b) => b['id'] == widget.bookId);

    return PopScope(
      canPop: context.canPop(),
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          if (context.canPop()) {
            context.pop();
          } else {
            context.goNamed('online-library');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            book['title'].toString().toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          leading: IconButton(
            icon: const Icon(LucideIcons.chevronLeft),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.goNamed('online-library');
              }
            },
          ),
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
      ),
    );
  }
}
