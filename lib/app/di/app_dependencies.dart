import 'package:shared_preferences/shared_preferences.dart';

import '../../core/utils/id_generator.dart';
import '../../features/onboarding/data/preferences_repository.dart';
import '../../features/strategies/data/demo_failure_switch.dart';
import '../../features/strategies/data/local_strategy_repository.dart';
import '../../features/strategies/data/strategy_repository.dart';

/// Composition root. Swap the local adapters for API clients when a backend
/// contract exists; nothing above this layer needs to change.
class AppDependencies {
  const AppDependencies({
    required this.strategyRepository,
    required this.preferencesRepository,
    required this.idGenerator,
    required this.failureSwitch,
  });

  final StrategyRepository strategyRepository;
  final PreferencesRepository preferencesRepository;
  final IdGenerator idGenerator;
  final DemoFailureSwitch failureSwitch;

  static Future<AppDependencies> create() async {
    final prefs = await SharedPreferences.getInstance();
    const ids = UuidGenerator();
    final failureSwitch = DemoFailureSwitch();
    return AppDependencies(
      strategyRepository: LocalStrategyRepository(
        prefs,
        idGenerator: ids,
        failureSwitch: failureSwitch,
      ),
      preferencesRepository: LocalPreferencesRepository(prefs),
      idGenerator: ids,
      failureSwitch: failureSwitch,
    );
  }
}
