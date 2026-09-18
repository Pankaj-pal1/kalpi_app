/// Motion and feedback timings from the design tokens.
abstract final class AppDurations {
  static const Duration page = Duration(milliseconds: 160);
  static const Duration sheet = Duration(milliseconds: 220);
  static const Duration toast = Duration(milliseconds: 2400);
  static const Duration searchDebounce = Duration(milliseconds: 300);

  /// Latency simulated by the local demo repository so busy states are
  /// visible. A real backend controls completion instead.
  static const Duration demoSaveDelay = Duration(milliseconds: 900);
  static const Duration demoLoadDelay = Duration(milliseconds: 250);
}
