import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/library_provider.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/widgets/library_book_card.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/widgets/library_empty_state.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/widgets/library_filter_bar.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/widgets/library_shimmer_card.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LibraryProvider>().fetchBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: context.canPop(),
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              l10n.onlineLibraryTitle.toUpperCase(),
              style: const TextStyle(letterSpacing: 1.2),
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(LucideIcons.chevronLeft),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/');
              }
            },
          ),
        ),
        body: Column(
          children: [
            const LibraryFilterBar(),
          Expanded(
            child: Consumer<LibraryProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: 5,
                    itemBuilder: (context, index) => const LibraryShimmerCard(),
                  );
                }

                if (provider.error != null || provider.books.isEmpty) {
                  return LibraryEmptyState(
                    icon: provider.error != null ? LucideIcons.wifiOff : LucideIcons.searchX,
                    title: provider.error != null ? l10n.connectionError : l10n.noResultsFound,
                    message: provider.error != null ? l10n.noInternetMessage : l10n.noResultsFound,
                    buttonText: l10n.tryAgain,
                    onRetry: () {
                      if (provider.error != null) {
                        provider.fetchBooks();
                      } else {
                        provider.setSearchQuery('');
                        provider.setSelectedLang(null);
                        provider.setSelectedCategory(null);
                      }
                    },
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => provider.fetchBooks(),
                  color: AppTheme.electricGold,
                  backgroundColor: AppTheme.darkNavy,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: provider.books.length,
                    itemBuilder: (context, index) {
                      return LibraryBookCard(book: provider.books[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
}
