import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/builder/presentation/cubit/builder_cubit.dart';
import '../../features/builder/presentation/pages/builder_step_page.dart';
import '../../features/builder/presentation/pages/custom_universe_page.dart';
import '../../features/builder/presentation/pages/metric_picker_page.dart';
import '../../features/learn/presentation/pages/learn_page.dart';
import '../../features/onboarding/presentation/cubit/preferences_cubit.dart';
import '../../features/onboarding/presentation/pages/experience_page.dart';
import '../../features/onboarding/presentation/pages/intent_page.dart';
import '../../features/onboarding/presentation/pages/splash_page.dart';
import '../../features/onboarding/presentation/pages/welcome_page.dart';
import '../../features/preferences/presentation/pages/preferences_page.dart';
import '../../features/strategies/presentation/pages/duplicate_strategy_page.dart';
import '../../features/strategies/presentation/pages/strategy_detail_page.dart';
import '../../features/strategies/presentation/pages/strategy_list_page.dart';
import 'app_routes.dart';
import 'kalpi_page.dart';

/// Builds the app router. Redirects keep users inside onboarding until it is
/// complete and out of it afterwards.
GoRouter buildAppRouter(PreferencesCubit preferences) {
  return GoRouter(
    initialLocation: AppRoutes.root,
    debugLogDiagnostics: kDebugMode,
    refreshListenable: _CubitListenable(preferences),
    redirect: (context, state) {
      final prefs = preferences.state;
      final location = state.matchedLocation;
      if (!prefs.isReady) {
        return location == AppRoutes.root ? null : AppRoutes.root;
      }
      final inOnboarding = location.startsWith('/onboarding');
      if (!prefs.onboardingComplete) {
        return inOnboarding ? null : AppRoutes.welcome;
      }
      if (location == AppRoutes.root || inOnboarding) {
        return AppRoutes.strategies;
      }
      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.root,
        pageBuilder: (context, state) =>
            KalpiPage<void>(child: const SplashPage()),
      ),
      GoRoute(
        path: AppRoutes.welcome,
        pageBuilder: (context, state) =>
            KalpiPage<void>(child: const WelcomePage()),
      ),
      GoRoute(
        path: AppRoutes.experience,
        pageBuilder: (context, state) => KalpiPage<void>(
          child: const ExperiencePage(mode: PreferencePageMode.onboarding),
        ),
      ),
      GoRoute(
        path: AppRoutes.intent,
        pageBuilder: (context, state) => KalpiPage<void>(
          child: const IntentPage(mode: PreferencePageMode.onboarding),
        ),
      ),
      GoRoute(
        path: AppRoutes.strategies,
        pageBuilder: (context, state) =>
            KalpiPage<void>(child: const StrategyListPage()),
        routes: <RouteBase>[
          GoRoute(
            path: ':id',
            pageBuilder: (context, state) => KalpiPage<void>(
              child: StrategyDetailPage(
                strategyId: state.pathParameters['id']!,
              ),
            ),
            routes: <RouteBase>[
              GoRoute(
                path: 'duplicate',
                pageBuilder: (context, state) => KalpiPage<void>(
                  child: DuplicateStrategyPage(
                    strategyId: state.pathParameters['id']!,
                  ),
                ),
              ),
              GoRoute(
                path: 'edit/:step',
                pageBuilder: (context, state) => KalpiPage<void>(
                  child: BuilderStepPage(
                    step: BuilderStep.fromPath(state.pathParameters['step']),
                    editingId: state.pathParameters['id'],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.customUniverse,
        pageBuilder: (context, state) =>
            KalpiPage<void>(child: const CustomUniversePage()),
      ),
      GoRoute(
        path: AppRoutes.metricPicker,
        pageBuilder: (context, state) => KalpiPage<void>(
          child: MetricPickerPage(
            forRanking:
                state.uri.queryParameters[AppRoutes.queryMode] ==
                AppRoutes.modeRanking,
          ),
        ),
      ),
      GoRoute(
        path: '${AppRoutes.builder}/:step',
        pageBuilder: (context, state) => KalpiPage<void>(
          child: BuilderStepPage(
            step: BuilderStep.fromPath(state.pathParameters['step']),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.learn,
        pageBuilder: (context, state) =>
            KalpiPage<void>(child: const LearnPage()),
      ),
      GoRoute(
        path: AppRoutes.preferences,
        pageBuilder: (context, state) =>
            KalpiPage<void>(child: const PreferencesPage()),
        routes: <RouteBase>[
          GoRoute(
            path: 'experience',
            pageBuilder: (context, state) => KalpiPage<void>(
              child: const ExperiencePage(mode: PreferencePageMode.edit),
            ),
          ),
          GoRoute(
            path: 'intent',
            pageBuilder: (context, state) => KalpiPage<void>(
              child: const IntentPage(mode: PreferencePageMode.edit),
            ),
          ),
        ],
      ),
    ],
    errorPageBuilder: (context, state) =>
        KalpiPage<void>(child: const StrategyListPage()),
  );
}

/// Adapts a cubit's stream to a [Listenable] for `refreshListenable`.
class _CubitListenable extends ChangeNotifier {
  _CubitListenable(Cubit<Object?> cubit) {
    _subscription = cubit.stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<Object?> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
