/// Route paths and names. Keep navigation calls pointed at these constants.
abstract final class AppRoutes {
  static const String root = '/';

  static const String welcome = '/onboarding/welcome';
  static const String experience = '/onboarding/experience';
  static const String intent = '/onboarding/intent';

  static const String strategies = '/strategies';
  static String strategyDetail(String id) => '/strategies/$id';
  static String strategyDuplicate(String id) => '/strategies/$id/duplicate';
  static String strategyEdit(String id, String step) =>
      '/strategies/$id/edit/$step';

  static const String builder = '/builder';
  static String builderStep(String step) => '/builder/$step';
  static const String customUniverse = '/builder/custom-universe';
  static const String metricPicker = '/builder/metric-picker';

  static const String learn = '/learn';

  static const String preferences = '/preferences';
  static const String preferencesExperience = '/preferences/experience';
  static const String preferencesIntent = '/preferences/intent';

  // Query keys
  static const String queryMode = 'mode';
  static const String modeRanking = 'ranking';
  static const String modeRule = 'rule';
}
