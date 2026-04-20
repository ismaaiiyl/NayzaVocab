import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/core/widgets/nayza_widgets.dart';
import 'package:nayza_vocab/features/settings/presentation/provider/settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/services/notification_service.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final List<OnboardingContent> contents = [
      OnboardingContent(
        title: l10n.onboardingPage1Title,
        subtitle: l10n.onboardingPage1Subtitle,
        icon: LucideIcons.brainCircuit,
        color: AppTheme.electricGold,
      ),
      OnboardingContent(
        title: l10n.onboardingPage2Title,
        subtitle: l10n.onboardingPage2Subtitle,
        icon: LucideIcons.gamepad2,
        color: Colors.cyanAccent,
      ),
      OnboardingContent(
        title: l10n.onboardingPage3Title,
        subtitle: l10n.onboardingPage3Subtitle,
        icon: LucideIcons.trendingUp,
        color: Colors.greenAccent,
      ),
      OnboardingContent(
        title: l10n.onboardingPage4Title,
        subtitle: l10n.onboardingPage4Subtitle,
        icon: LucideIcons.graduationCap,
        color: Colors.orangeAccent,
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppTheme.darkNavy, Color(0xFF030C1A)],
              ),
            ),
          ),

          // Content
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: contents.length,
            itemBuilder: (context, index) {
              return _buildPage(contents[index]);
            },
          ),

          // Bottom Controls
          Positioned(
            bottom: 60,
            left: 32,
            right: 32,
            child: Column(
              children: [
                // Indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    contents.length,
                    (index) => _buildIndicator(index),
                  ),
                ),
                const SizedBox(height: 48),
                
                // Button
                if (_currentPage == contents.length - 1)
                  NayzaButton(
                    text: l10n.onboardingGetStarted,
                    onPressed: () {
                      context.read<SettingsProvider>().completeOnboarding();
                      NotificationService().requestPermissions();
                      context.goNamed('home');
                    },
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Senior: Skip should take user directly to app
                          context.read<SettingsProvider>().completeOnboarding();
                          NotificationService().requestPermissions();
                          context.goNamed('home');
                        },
                        child: const Text(
                          'SKIP',
                          style: TextStyle(
                            color: Colors.redAccent, 
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      IconButton.filled(
                        onPressed: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: AppTheme.electricGold,
                          foregroundColor: AppTheme.darkNavy,
                        ),
                        icon: const Icon(LucideIcons.chevronRight),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingContent content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: content.color.withValues(alpha: 0.1),
              boxShadow: [
                BoxShadow(
                  color: content.color.withValues(alpha: 0.1),
                  blurRadius: 100,
                  spreadRadius: 20,
                ),
              ],
            ),
            child: Icon(content.icon, size: 100, color: content.color),
          ),
          const SizedBox(height: 60),
          Text(
            content.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppTheme.textMain,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            content.subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: AppTheme.textDim,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(int index) {
    final bool isActive = _currentPage == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 6),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? AppTheme.electricGold : AppTheme.textDim.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingContent {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  OnboardingContent({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}
