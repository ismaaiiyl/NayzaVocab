import 'package:flutter/material.dart';
import 'package:nayza_vocab/core/widgets/nayza_widgets.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/core/utils/audio_helper.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:nayza_vocab/features/settings/presentation/provider/settings_provider.dart';
import 'package:nayza_vocab/core/widgets/nayza_icon.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vocabSetProvider = context.watch<VocabSetProvider>();
    final settings = context.watch<SettingsProvider>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle.toUpperCase()),
        actions: [
          IconButton(
            icon: Icon(
              settings.isMuted ? LucideIcons.volumeX : LucideIcons.volume2,
              color: AppTheme.electricGold,
            ),
            tooltip: settings.isMuted ? l10n.muteOn : l10n.muteOff,
            onPressed: () {
              settings.toggleMute();
              AudioHelper().isMuted = settings.isMuted;
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.electricGold.withValues(alpha: 0.1),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.electricGold.withValues(alpha: 0.2),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: const NayzaIcon(
                  size: 80,
                  color: AppTheme.electricGold,
                ),
              ),
            ),
            const SizedBox(height: 48),
            Text(
              l10n.homeTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.homeSubtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.textDim, fontSize: 16),
            ),
            const SizedBox(height: 40),
            _buildDifficultWordsCard(context, vocabSetProvider),
            const SizedBox(height: 48),
            Hero(
              tag: 'start-training-btn',
              child: NayzaButton(
                text: l10n.startTest,
                icon: LucideIcons.play,
                onPressed: () => context.pushNamed('select-collections'),
              ),
            ),
            const SizedBox(height: 16),
            NayzaButton(
              text: l10n.matchingGame,
              icon: LucideIcons.layoutGrid,
              onPressed: () => context.pushNamed(
                'select-collections',
                queryParameters: {'mode': 'matching'},
              ),
            ),
            const SizedBox(height: 40), // Safe margin above bottom bar
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultWordsCard(
    BuildContext context,
    VocabSetProvider provider,
  ) {
    final difficultWords = provider.getDifficultWords();
    if (difficultWords.isEmpty) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () => context.pushNamed('difficult-words'),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF5F6D), Color(0xFFFFC371)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF5F6D).withValues(alpha: 0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                LucideIcons.flame,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.difficultWordsTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.difficultWordsSubtitle(difficultWords.length),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(LucideIcons.chevronRight, color: Colors.white, size: 24),
          ],
        ),
      ),
    );
  }
}
