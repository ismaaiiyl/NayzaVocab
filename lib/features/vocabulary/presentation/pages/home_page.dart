import 'package:flutter/material.dart';
import 'package:nayza_vocab/core/widgets/nayza_widgets.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/history_screen.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/select_collections_screen.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/core/utils/audio_helper.dart';
import 'package:provider/provider.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:nayza_vocab/features/settings/presentation/pages/settings_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final vocabSetProvider = Provider.of<VocabSetProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('NAYZA VOCAB'.toUpperCase()),
        leading: IconButton(
          icon: const Icon(LucideIcons.settings),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SettingsPage()),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              vocabSetProvider.isMuted ? LucideIcons.volumeX : LucideIcons.volume2,
              color: AppTheme.electricGold,
            ),
            tooltip: vocabSetProvider.isMuted ? 'Ovozni yoqish' : 'Ovozni o\'chirish',
            onPressed: () {
              vocabSetProvider.toggleMute();
              AudioHelper().isMuted = vocabSetProvider.isMuted;
              AudioHelper().playToggle(vocabSetProvider.isMuted);
            },
          ),
          IconButton(
            icon: const Icon(LucideIcons.history),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HistoryScreen()),
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.sword, size: 100, color: AppTheme.electricGold),
            const SizedBox(height: 32),
            Text(
              'O\'Z BILIMINGNI SINAB KO\'R!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 16),
            const Text(
              'To\'plamlaringizni tanlang va testni boshlang.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textDim, fontSize: 16),
            ),
            const SizedBox(height: 48),
            Hero(
              tag: 'start-training-btn',
              child: NayzaButton(
                text: 'TESTNI BOSHLASH',
                icon: LucideIcons.play,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SelectCollectionsScreen()),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoryScreen()),
              ),
              icon: const Icon(LucideIcons.list, color: AppTheme.electricGold),
              label: const Text('TO\'PLAMLARNI BOSHQARISH', style: TextStyle(color: AppTheme.electricGold)),
            ),
          ],
        ),
      ),
    );
  }
}
