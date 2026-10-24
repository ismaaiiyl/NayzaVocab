import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class DifficultWordsScreen extends StatelessWidget {
  const DifficultWordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.difficultWordsTitle),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Consumer<VocabSetProvider>(
        builder: (context, provider, child) {
          final virtualSets = provider.getDifficultVirtualSets();
          
          if (virtualSets.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.smile, size: 64, color: AppTheme.textDim),
                    const SizedBox(height: 16),
                    Text(
                      l10n.noDifficultWords,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppTheme.textDim, fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: virtualSets.length,
            itemBuilder: (context, index) {
              final set = virtualSets[index];
              final groupNumber = index + 1;
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Card(
                  child: InkWell(
                    onTap: () => context.pushNamed('difficult-set-details', extra: set.copyWith(title: l10n.difficultSetTitle(groupNumber))),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.error.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(LucideIcons.alertCircle, color: AppTheme.error, size: 24),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.difficultSetTitle(groupNumber),
                                  style: theme.textTheme.titleLarge?.copyWith(color: AppTheme.electricGold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  l10n.wordCountLabel(set.words.length),
                                  style: const TextStyle(color: AppTheme.textDim),
                                ),
                              ],
                            ),
                          ),
                          const Icon(LucideIcons.chevronRight, color: AppTheme.textDim),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
