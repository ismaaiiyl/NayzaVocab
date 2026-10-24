import 'package:go_router/go_router.dart';
import 'package:nayza_vocab/core/router/route_transitions.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/quiz/flashcard_quiz_screen.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/quiz/matching_game_screen.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/quiz/quiz_setup_screen.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/quiz/quiz_summary_screen.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/quiz_screen.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/select_collections_screen.dart';

List<RouteBase> getQuizRoutes() {
  return [
    GoRoute(
      path: '/select-collections',
      name: 'select-collections',
      pageBuilder: (context, state) {
        final mode = state.uri.queryParameters['mode'] == 'matching'
            ? QuizMode.matching
            : QuizMode.flashcard;
        return buildCustomPageTransition(
            SelectCollectionsScreen(initialMode: mode));
      },
    ),
    GoRoute(
      path: '/quiz-setup',
      name: 'quiz-setup',
      pageBuilder: (context, state) =>
          buildCustomPageTransition(const QuizSetupScreen()),
    ),
    GoRoute(
      path: '/flashcard-quiz',
      name: 'flashcard-quiz',
      pageBuilder: (context, state) {
        final direction = state.extra as QuizDirection? ??
            QuizDirection.originalToTranslation;
        return buildCustomPageTransition(
            FlashcardQuizScreen(direction: direction));
      },
    ),
    GoRoute(
      path: '/matching-game',
      name: 'matching-game',
      pageBuilder: (context, state) =>
          buildCustomPageTransition(const MatchingGameScreen()),
    ),
    GoRoute(
      path: '/quiz',
      name: 'quiz',
      pageBuilder: (context, state) {
        final extras = state.extra as Map<String, dynamic>? ?? {};
        final mode = extras['mode'] as QuizMode? ?? QuizMode.choice;
        final direction = extras['direction'] as QuizDirection? ??
            QuizDirection.originalToTranslation;
        return buildCustomPageTransition(
            QuizScreen(quizMode: mode, direction: direction));
      },
    ),
    GoRoute(
      path: '/quiz-results',
      name: 'quiz-results',
      pageBuilder: (context, state) {
        final extras = state.extra as Map<String, dynamic>? ?? {};
        return buildCustomPageTransition(QuizSummaryScreen(
          mode: extras['mode'] as QuizMode?,
          direction: extras['direction'] as QuizDirection?,
        ));
      },
    ),
  ];
}
