import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_config.dart';
import '../core/theme/kalpi_theme.dart';
import '../features/builder/presentation/cubit/builder_cubit.dart';
import '../features/onboarding/presentation/cubit/preferences_cubit.dart';
import '../features/strategies/presentation/cubit/strategy_list_cubit.dart';
import 'di/app_dependencies.dart';
import 'router/app_router.dart';

/// Root widget: provides repositories and cubits, then the router.
class KalpiApp extends StatefulWidget {
  const KalpiApp({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  State<KalpiApp> createState() => _KalpiAppState();
}

class _KalpiAppState extends State<KalpiApp> {
  late final PreferencesCubit _preferences;
  late final StrategyListCubit _strategies;
  late final BuilderCubit _builder;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    final deps = widget.dependencies;
    _preferences = PreferencesCubit(
      deps.preferencesRepository,
      failureSwitch: deps.failureSwitch,
    )..load();
    _strategies = StrategyListCubit(
      deps.strategyRepository,
      idGenerator: deps.idGenerator,
    )..load();
    _builder = BuilderCubit(
      deps.strategyRepository,
      idGenerator: deps.idGenerator,
    );
    _router = buildAppRouter(_preferences);
    SystemChrome.setSystemUIOverlayStyle(KalpiTheme.overlayStyle);
  }

  @override
  void dispose() {
    _router.dispose();
    _builder.close();
    _strategies.close();
    _preferences.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<PreferencesCubit>.value(value: _preferences),
        BlocProvider<StrategyListCubit>.value(value: _strategies),
        BlocProvider<BuilderCubit>.value(value: _builder),
      ],
      child: MaterialApp.router(
        title: AppConfig.appName,
        debugShowCheckedModeBanner: false,
        theme: KalpiTheme.dark,
        darkTheme: KalpiTheme.dark,
        themeMode: ThemeMode.dark,
        routerConfig: _router,
      ),
    );
  }
}
