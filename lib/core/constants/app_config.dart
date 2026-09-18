/// Compile-time configuration.
abstract final class AppConfig {
  static const String appName = 'Kalpi';

  /// Name/version shown in the preferences footer.
  static const String versionLabel = 'Demo build · local data only';

  /// Strategy name length limits (after trimming).
  static const int nameMinLength = 1;
  static const int nameMaxLength = 60;

  /// Ranking count presets offered in the builder.
  static const List<int> holdingPresets = <int>[10, 15, 20];

  /// Illustrative constituent counts for the index universes.
  static const int nifty50Count = 50;
  static const int nifty500Count = 500;
}
