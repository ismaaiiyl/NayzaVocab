import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/core/widgets/nayza_widgets.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/quiz_screen.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/quiz_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';

class QuizSummaryScreen extends StatelessWidget {
  final String? title;
  final QuizMode? mode;
  final QuizDirection? direction;
  
  const QuizSummaryScreen({
    super.key, 
    this.title,
    this.mode,
    this.direction,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuizProvider>();
    final l10n = AppLocalizations.of(context)!;
    final total = provider.correctCount + provider.incorrectCount;
    final accuracy = total == 0 ? 0 : (provider.correctCount / total * 100).toInt();
    final displayTitle = title ?? l10n.summaryTitle;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: AppTheme.textMain),
          onPressed: () => context.goNamed('home'),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.darkNavy,
              AppTheme.darkNavy.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            _buildTrophySection(accuracy),
            const SizedBox(height: 48),
            Text(
              displayTitle,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: AppTheme.electricGold,
                    letterSpacing: 2,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              '${l10n.scoreLabel(accuracy)}%',
              style: const TextStyle(color: AppTheme.textDim, fontSize: 18),
            ),
            const SizedBox(height: 48),
            _buildStatGrid(provider, l10n),
            const Spacer(),
            if (provider.failedQueue.isNotEmpty) ...[
              NayzaButton(
                text: l10n.tryAgain,
                icon: LucideIcons.refreshCcw,
                onPressed: () {
                   provider.retryFailedWords();
                   final targetRoute = mode == QuizMode.flashcard 
                     ? 'flashcard-quiz' 
                     : (mode == QuizMode.matching ? 'matching-game' : 'quiz');
                     
                   context.pushReplacementNamed(targetRoute, extra: {
                     'mode': mode ?? QuizMode.choice,
                     'direction': direction ?? QuizDirection.originalToTranslation,
                   });
                },
              ),
              const SizedBox(height: 12),
            ],
            NayzaButton(
              text: l10n.finish.toUpperCase(),
              icon: LucideIcons.home,
              onPressed: () => context.goNamed('home'),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTrophySection(int accuracy) {
    IconData icon = LucideIcons.trophy;
    Color color = AppTheme.electricGold;
    
    if (accuracy < 50) {
      icon = LucideIcons.frown;
      color = Colors.orangeAccent;
    } else if (accuracy == 100) {
      icon = LucideIcons.partyPopper;
      color = AppTheme.success;
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.1),
            border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
          ),
        ),
        Icon(icon, size: 70, color: color),
      ],
    );
  }

  Widget _buildStatGrid(QuizProvider provider, AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatCard(l10n.correctCountLabel(provider.correctCount), provider.correctCount.toString(), AppTheme.success),
        _buildStatCard(l10n.incorrectCountLabel(provider.incorrectCount), provider.incorrectCount.toString(), AppTheme.error),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      width: 120,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: AppTheme.textDim, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
