import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/features/settings/presentation/widgets/profile_folder_breakdown.dart';
import 'package:nayza_vocab/features/settings/presentation/widgets/profile_header.dart';
import 'package:nayza_vocab/features/settings/presentation/widgets/profile_quick_stats.dart';
import 'package:nayza_vocab/features/settings/presentation/widgets/profile_subject_breakdown.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/vocab_set_model.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/word_model.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final vocabProvider = context.watch<VocabSetProvider>();

    final totalSets = vocabProvider.vocabSets.length;
    final totalFolders = vocabProvider.folders.length;
    final totalWords = vocabProvider.vocabSets.fold<int>(
      0,
      (int sum, VocabSetModel set) => sum + set.words.length,
    );
    final learnedWords = vocabProvider.vocabSets.fold<int>(
      0,
      (int sum, VocabSetModel set) =>
          sum + set.words.where((WordModel w) => w.isLearned).length,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profile.toUpperCase()),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.settings, color: AppTheme.electricGold),
            tooltip: l10n.settings,
            onPressed: () => context.pushNamed('settings'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children: [
          ProfileHeader(masteredWordsCount: learnedWords),
          ProfileQuickStats(
            totalWords: totalWords,
            masteredWords: learnedWords,
            foldersCount: totalFolders,
            setsCount: totalSets,
          ),
          const SizedBox(height: 24),
          ProfileFolderBreakdown(provider: vocabProvider),
          const SizedBox(height: 24),
          ProfileSubjectBreakdown(provider: vocabProvider),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
