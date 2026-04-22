import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/library_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/widgets/library_empty_state.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  void initState() {
    super.initState();
    // Sahifa ochilishi bilan kitoblarni yuklaymiz
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LibraryProvider>().fetchBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.onlineLibraryTitle.toUpperCase()),
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
          _buildSearchAndFilter(context, l10n),
          Expanded(
            child: Consumer<LibraryProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: 5,
                    itemBuilder: (context, index) => _buildShimmerBookCard(),
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
                      final book = provider.books[index];
                      return _buildBookCard(context, book, theme, l10n);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter(BuildContext context, AppLocalizations l10n) {
    final provider = context.watch<LibraryProvider>();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceNavy.withValues(alpha: 0.5),
        border: const Border(bottom: BorderSide(color: AppTheme.borderNavy)),
      ),
      child: Column(
        children: [
          TextField(
            onChanged: provider.setSearchQuery,
            decoration: InputDecoration(
              hintText: l10n.searchHint,
              prefixIcon: const Icon(LucideIcons.search, size: 20),
              filled: true,
              fillColor: AppTheme.darkNavy,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(context, null, l10n.all.toUpperCase(), isLang: true),
                _buildFilterChip(context, 'en', l10n.englishLang.toUpperCase(), isLang: true),
                _buildFilterChip(context, 'ru', l10n.russianLang.toUpperCase(), isLang: true),
                _buildFilterChip(context, 'ar', l10n.arabicLang.toUpperCase(), isLang: true),
                _buildFilterChip(context, 'de', l10n.germanLang.toUpperCase(), isLang: true),
                _buildFilterChip(context, 'ko', l10n.koreanLang.toUpperCase(), isLang: true),
              ],
            ),
          ),
          if (provider.categories.isNotEmpty) ...[
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip(context, null, l10n.allTopics.toUpperCase(), isLang: false),
                  ...provider.categories.map((cat) => _buildFilterChip(context, cat, cat.toUpperCase(), isLang: false)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String? value, String label, {required bool isLang}) {
    final provider = context.read<LibraryProvider>();
    final isSelected = isLang 
        ? provider.selectedLang == value 
        : provider.selectedCategory == value;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        selected: isSelected,
        onSelected: (_) {
          if (isLang) {
            provider.setSelectedLang(value);
          } else {
            provider.setSelectedCategory(value);
          }
        },
        selectedColor: AppTheme.electricGold.withValues(alpha: 0.2),
        backgroundColor: AppTheme.darkNavy,
        labelStyle: TextStyle(color: isSelected ? AppTheme.electricGold : AppTheme.textDim),
        side: BorderSide(color: isSelected ? AppTheme.electricGold : AppTheme.borderNavy),
      ),
    );
  }

  Widget _buildBookCard(BuildContext context, Map<String, dynamic> book, ThemeData theme, AppLocalizations l10n) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => context.goNamed('book-details', pathParameters: {'id': book['id'].toString()}),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Hero(
                tag: 'book-cover-${book['id']}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    book['cover_url'] ?? '',
                    width: 80,
                    height: 110,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 80,
                      height: 110,
                      color: AppTheme.surfaceNavy,
                      child: const Icon(LucideIcons.book, color: AppTheme.textDim),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.electricGold.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        book['target_lang'].toString().toUpperCase(),
                        style: const TextStyle(color: AppTheme.electricGold, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      book['title'],
                      style: theme.textTheme.titleLarge?.copyWith(color: AppTheme.textMain, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.setsCountLabel(book['unitsCount'] ?? 0),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppTheme.textDim, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const Icon(LucideIcons.chevronRight, color: AppTheme.textDim),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerBookCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceNavy.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 110,
            decoration: BoxDecoration(
              color: AppTheme.darkNavy,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 40, height: 14, color: AppTheme.darkNavy),
                const SizedBox(height: 12),
                Container(width: 150, height: 20, color: AppTheme.darkNavy),
                const SizedBox(height: 8),
                Container(width: 200, height: 14, color: AppTheme.darkNavy),
                const SizedBox(height: 4),
                Container(width: 180, height: 14, color: AppTheme.darkNavy),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
