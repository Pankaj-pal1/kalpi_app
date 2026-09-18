import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kalpi_app/app/router/app_router.dart';
import 'package:kalpi_app/core/constants/app_storage_keys.dart';
import 'package:kalpi_app/core/theme/kalpi_theme.dart';
import 'package:kalpi_app/features/builder/presentation/cubit/builder_cubit.dart';
import 'package:kalpi_app/features/onboarding/data/preferences_repository.dart';
import 'package:kalpi_app/features/onboarding/domain/experience_level.dart';
import 'package:kalpi_app/features/onboarding/domain/investing_intent.dart';
import 'package:kalpi_app/features/onboarding/domain/user_preferences.dart';
import 'package:kalpi_app/features/onboarding/presentation/cubit/preferences_cubit.dart';
import 'package:kalpi_app/features/strategies/data/demo_failure_switch.dart';
import 'package:kalpi_app/features/strategies/domain/strategy.dart';
import 'package:kalpi_app/features/strategies/presentation/cubit/strategy_list_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../support/fakes.dart';

/// Loads the bundled fonts (and the Cupertino icon font) so goldens render
/// real glyphs instead of placeholder boxes.
Future<void> loadAppFonts() async {
  Future<ByteData> read(String path) async {
    final bytes = await File(path).readAsBytes();
    return ByteData.view(bytes.buffer);
  }

  final manrope = FontLoader('Manrope');
  for (final w in <String>['Medium', 'SemiBold', 'Bold', 'ExtraBold']) {
    manrope.addFont(read('assets/fonts/Manrope-$w.ttf'));
  }
  await manrope.load();

  final inter = FontLoader('InterTight');
  for (final w in <String>['Regular', 'Medium', 'SemiBold', 'Bold']) {
    inter.addFont(read('assets/fonts/InterTight-$w.ttf'));
  }
  await inter.load();

  final config =
      jsonDecode(await File('.dart_tool/package_config.json').readAsString())
          as Map<String, dynamic>;
  final packages = config['packages'] as List<dynamic>;
  final icons = packages.cast<Map<String, dynamic>>().firstWhere(
    (p) => p['name'] == 'cupertino_icons',
  );
  var root = icons['rootUri'] as String;
  if (root.startsWith('file://')) {
    root = Uri.parse(root).toFilePath();
  } else if (root.startsWith('../')) {
    root = Directory.current.uri.resolve('.dart_tool/$root').toFilePath();
  }
  final iconLoader = FontLoader('packages/cupertino_icons/CupertinoIcons');
  iconLoader.addFont(
    read('${root.replaceAll(RegExp(r'/$'), '')}/assets/CupertinoIcons.ttf'),
  );
  await iconLoader.load();
}

/// Everything a golden scenario needs to poke at.
class GoldenApp {
  GoldenApp({
    required this.router,
    required this.repo,
    required this.preferences,
    required this.strategies,
    required this.builder,
  });

  final GoRouter router;
  final FakeStrategyRepository repo;
  final PreferencesCubit preferences;
  final StrategyListCubit strategies;
  final BuilderCubit builder;

  Future<void> dispose() async {
    router.dispose();
    await builder.close();
    await strategies.close();
    await preferences.close();
  }
}

/// Pumps the real app (router, theme, cubits) at 390 × 844 logical pixels.
Future<GoldenApp> pumpKalpi(
  WidgetTester tester, {
  required String location,
  bool onboarded = true,
  List<Strategy> strategies = const <Strategy>[],
  void Function(GoldenApp app)? beforeNavigate,
}) async {
  tester.view.physicalSize = const Size(390 * 2, 844 * 2);
  tester.view.devicePixelRatio = 2;
  tester.view.padding = const FakeViewPadding(top: 47 * 2, bottom: 34 * 2);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPadding);

  SharedPreferences.setMockInitialValues(<String, Object>{
    if (onboarded)
      AppStorageKeys.preferences: jsonEncode(
        const UserPreferences(
          experience: ExperienceLevel.gettingStarted,
          intent: InvestingIntent.build,
          onboardingComplete: true,
        ).toJson(),
      ),
  });
  final prefs = await SharedPreferences.getInstance();
  final preferences = PreferencesCubit(
    LocalPreferencesRepository(prefs),
    failureSwitch: DemoFailureSwitch(),
  );
  await preferences.load();
  final repo = FakeStrategyRepository(seed: strategies);
  final list = StrategyListCubit(repo, idGenerator: SequentialIdGenerator());
  await list.load();
  final builder = BuilderCubit(repo, idGenerator: SequentialIdGenerator());
  final router = buildAppRouter(preferences);
  final app = GoldenApp(
    router: router,
    repo: repo,
    preferences: preferences,
    strategies: list,
    builder: builder,
  );
  addTearDown(app.dispose);

  await tester.pumpWidget(
    MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<PreferencesCubit>.value(value: preferences),
        BlocProvider<StrategyListCubit>.value(value: list),
        BlocProvider<BuilderCubit>.value(value: builder),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: KalpiTheme.dark,
        routerConfig: router,
      ),
    ),
  );
  await tester.pumpAndSettle();
  beforeNavigate?.call(app);
  router.go(location);
  await tester.pumpAndSettle();
  return app;
}

Future<void> snap(WidgetTester tester, String name) => expectLater(
  find.byType(MaterialApp),
  matchesGoldenFile('goldens/$name.png'),
);
