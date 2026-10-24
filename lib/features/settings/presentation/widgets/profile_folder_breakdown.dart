import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/core/widgets/nayza_progress_bar.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';

class ProfileFolderBreakdown extends StatelessWidget {
  final VocabSetProvider provider;

  const ProfileFolderBreakdown({super.key, required this.provider});

  String _detectFolderLanguage(String? folderId) {
    final sets = provider.getSetsByFolder(folderId);
    final allWords = sets.expand((s) => s.words).toList();
    if (allWords.isEmpty) return 'General';

    final langCounts = <String, int>{};
    for (final w in allWords) {
      final code = (w.langCode ?? 'en').split('-').first.toUpperCase();
      langCounts[code] = (langCounts[code] ?? 0) + 1;
    }

    var bestLang = 'EN';
    var maxCount = 0;
    langCounts.forEach((lang, count) {
      if (count > maxCount) {
        maxCount = count;
        bestLang = lang;
      }
    });

    return bestLang;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final folders = provider.folders;
    final uncategorizedSets = provider.getSetsByFolder(null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.folderBreakdown,
          style: const TextStyle(
            color: AppTheme.textDim,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        if (folders.isEmpty && uncategorizedSets.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surfaceNavy,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.borderNavy),
            ),
            child: Text(
              l10n.noCollections,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.textDim),
            ),
          )
        else ...[
          ...folders.map((folder) => _buildFolderTile(
                title: folder.title,
                folderId: folder.id,
                l10n: l10n,
              )),
          if (uncategorizedSets.isNotEmpty)
            _buildFolderTile(
              title: l10n.noFolder,
              folderId: null,
              l10n: l10n,
            ),
        ],
      ],
    );
  }

  Widget _buildFolderTile({
    required String title,
    required String? folderId,
    required AppLocalizations l10n,
  }) {
    final sets = provider.getSetsByFolder(folderId);
    final totalWords = sets.fold<int>(0, (sum, s) => sum + s.words.length);
    final learnedWords = sets.fold<int>(0, (sum, s) => sum + s.learnedWordsCount);
    final langTag = _detectFolderLanguage(folderId);
    final progress = totalWords == 0 ? 0 : (learnedWords / totalWords * 100).toInt();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceNavy,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderNavy, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.cardDark,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(LucideIcons.folder, size: 16, color: AppTheme.electricGold),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.textMain,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.electricGold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  langTag,
                  style: const TextStyle(
                    color: AppTheme.electricGold,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${sets.length} ${l10n.collections.toLowerCase()} • $totalWords ${l10n.wordCountLabel(totalWords)}',
                style: const TextStyle(color: AppTheme.textDim, fontSize: 11),
              ),
              Text(
                '$progress%',
                style: TextStyle(
                  color: progress == 100 ? AppTheme.success : AppTheme.electricGold,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          NayzaProgressBar(
            current: learnedWords,
            total: totalWords == 0 ? 1 : totalWords,
          ),
        ],
      ),
    );
  }
}
