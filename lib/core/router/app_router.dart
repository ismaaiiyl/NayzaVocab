import 'package:go_router/go_router.dart';
import 'package:nayza_vocab/core/router/quiz_routes.dart';
import 'package:nayza_vocab/core/router/route_transitions.dart';
import 'package:nayza_vocab/features/navigation/presentation/main_screen.dart';
import 'package:nayza_vocab/features/settings/presentation/pages/export_selection_page.dart';
import 'package:nayza_vocab/features/settings/presentation/pages/profile_page.dart';
import 'package:nayza_vocab/features/settings/presentation/pages/settings_page.dart';
import 'package:nayza_vocab/features/settings/presentation/provider/settings_provider.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/vocab_set_model.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/create_set_screen.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/dashboard_page.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/difficult_set_details_screen.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/difficult_words_screen.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/folder_details_screen.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/library_book_details_screen.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/library_screen.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/onboarding_page.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/set_details_screen.dart';

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
        GoRoute(
          path: '/create-set',
          name: 'create-set',
          pageBuilder: (context, state) {
            final folderId = state.extra as String?;
            return buildCustomPageTransition(
                CreateSetScreen(folderId: folderId));
          },
        ),
        GoRoute(
          path: '/set-details/:id',
          name: 'set-details',
          pageBuilder: (context, state) {
            final id = state.pathParameters['id']!;
            return buildCustomPageTransition(SetDetailsScreen(setId: id));
          },
        ),
        GoRoute(
          path: '/folder-details/:id',
          name: 'folder-details',
          pageBuilder: (context, state) {
            final id = state.pathParameters['id']!;
            return buildCustomPageTransition(
                FolderDetailsScreen(folderId: id));
          },
        ),
        ...getQuizRoutes(),
        GoRoute(
          path: '/difficult-set-details',
          name: 'difficult-set-details',
          pageBuilder: (context, state) {
            final set = state.extra as VocabSetModel;
            return buildCustomPageTransition(
                DifficultSetDetailsScreen(virtualSet: set));
          },
        ),
        GoRoute(
          path: '/export-selection',
          name: 'export-selection',
          pageBuilder: (context, state) =>
              buildCustomPageTransition(const ExportSelectionPage()),
        ),
        GoRoute(
          path: '/online-library',
          name: 'online-library',
          pageBuilder: (context, state) =>
              buildCustomPageTransition(const LibraryScreen()),
          routes: [
            GoRoute(
              path: 'book/:id',
              name: 'book-details',
              pageBuilder: (context, state) {
                final id = state.pathParameters['id']!;
                return buildCustomPageTransition(
                    BookDetailsScreen(bookId: id));
              },
            ),
          ],
        ),
        GoRoute(
          path: '/settings',
          name: 'settings',
          pageBuilder: (context, state) =>
              buildCustomPageTransition(const SettingsPage()),
        ),
        GoRoute(
          path: '/collections',
          name: 'collections',
          pageBuilder: (context, state) =>
              buildCustomPageTransition(const DashboardPage()),
        ),
        GoRoute(
          path: '/difficult-words',
          name: 'difficult-words',
          pageBuilder: (context, state) =>
              buildCustomPageTransition(const DifficultWordsScreen()),
        ),
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
                  builder: (context, state) => const DashboardPage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/profile',
                  name: 'profile',
                  builder: (context, state) => const ProfilePage(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
    return _router!;
  }
}
