import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/home_page.dart';
import 'package:nayza_vocab/features/settings/presentation/pages/settings_page.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/history_screen.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/set_details_screen.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/create_set_screen.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/select_collections_screen.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/quiz/quiz_setup_screen.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/quiz_screen.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/quiz/matching_game_screen.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/quiz/flashcard_quiz_screen.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/onboarding_page.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/quiz/quiz_summary_screen.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/difficult_words_screen.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/difficult_set_details_screen.dart';
import 'package:nayza_vocab/features/settings/presentation/pages/export_selection_page.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/vocab_set_model.dart';
import 'package:nayza_vocab/features/settings/presentation/provider/settings_provider.dart';
import 'package:nayza_vocab/features/navigation/presentation/main_screen.dart';
import 'package:provider/provider.dart';

class AppRouter {
  static GoRouter? _router;

  static GoRouter getRouter(SettingsProvider settings) {
    _router ??= GoRouter(
      initialLocation: '/',
      refreshListenable: settings,
    redirect: (context, state) {
      final bool onOnboarding = state.matchedLocation == '/onboarding';

      if (!settings.hasSeenOnboarding && !onOnboarding) {
        return '/onboarding';
      }
      if (settings.hasSeenOnboarding && onOnboarding) {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      // ─── FULL SCREEN SUB-PAGES (Outside the Shell) ────────────────────────
      GoRoute(
        path: '/create-set',
        name: 'create-set',
        pageBuilder: (context, state) => _customPageTransition(const CreateSetScreen()),
      ),
      GoRoute(
        path: '/set-details/:id',
        name: 'set-details',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return _customPageTransition(SetDetailsScreen(setId: id));
        },
      ),
      GoRoute(
        path: '/select-collections',
        name: 'select-collections',
        pageBuilder: (context, state) {
          final mode = state.uri.queryParameters['mode'] == 'matching' ? QuizMode.matching : QuizMode.flashcard;
          return _customPageTransition(SelectCollectionsScreen(initialMode: mode));
        },
      ),
      GoRoute(
        path: '/quiz-setup',
        name: 'quiz-setup',
        pageBuilder: (context, state) => _customPageTransition(const QuizSetupScreen()),
      ),
      GoRoute(
        path: '/flashcard-quiz',
        name: 'flashcard-quiz',
        pageBuilder: (context, state) {
          final direction = state.extra as QuizDirection? ?? QuizDirection.originalToTranslation;
          return _customPageTransition(FlashcardQuizScreen(direction: direction));
        },
      ),
      GoRoute(
        path: '/matching-game',
        name: 'matching-game',
        pageBuilder: (context, state) => _customPageTransition(const MatchingGameScreen()),
      ),
      GoRoute(
        path: '/quiz',
        name: 'quiz',
        pageBuilder: (context, state) {
          final extras = state.extra as Map<String, dynamic>? ?? {};
          final mode = extras['mode'] as QuizMode? ?? QuizMode.choice;
          final direction = extras['direction'] as QuizDirection? ?? QuizDirection.originalToTranslation;
          return _customPageTransition(QuizScreen(quizMode: mode, direction: direction));
        },
      ),
      GoRoute(
        path: '/quiz-results',
        name: 'quiz-results',
        pageBuilder: (context, state) {
          final extras = state.extra as Map<String, dynamic>? ?? {};
          return _customPageTransition(QuizSummaryScreen(
            mode: extras['mode'] as QuizMode?,
            direction: extras['direction'] as QuizDirection?,
          ));
        },
      ),
      GoRoute(
        path: '/difficult-set-details',
        name: 'difficult-set-details',
        pageBuilder: (context, state) {
          final set = state.extra as VocabSetModel;
          return _customPageTransition(DifficultSetDetailsScreen(virtualSet: set));
        },
      ),
      GoRoute(
        path: '/export-selection',
        name: 'export-selection',
        pageBuilder: (context, state) => _customPageTransition(const ExportSelectionPage()),
      ),

      // ─── SHELL FOR MAIN TABS ───────────────────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: 'home',
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/collections',
                name: 'collections',
                pageBuilder: (context, state) => _customPageTransition(const HistoryScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/difficult-words',
                name: 'difficult-words',
                pageBuilder: (context, state) => _customPageTransition(const DifficultWordsScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                name: 'settings',
                pageBuilder: (context, state) => _customPageTransition(const SettingsPage()),
              ),
            ],
          ),
        ],
      ),
    ],
    );
    return _router!;
  }

  static CustomTransitionPage<void> _customPageTransition(Widget child) {
    return CustomTransitionPage(
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            ),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }
}
