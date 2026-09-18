/// Layout, spacing and radius constants taken from the design tokens.
///
/// The Penpot boards are 390 × 844 references; runtime layouts are fluid and
/// use these values as fixed insets/sizes, never as a hardcoded viewport.
abstract final class AppDimens {
  // Reference canvas (documentation only — never used to size the viewport).
  static const double designWidth = 390;
  static const double designHeight = 844;

  // Spacing scale
  static const double space4 = 4;
  static const double space8 = 8;
  static const double space12 = 12;
  static const double space16 = 16;
  static const double space20 = 20;
  static const double space24 = 24;
  static const double space32 = 32;
  static const double space40 = 40;
  static const double space48 = 48;

  /// Horizontal page gutter.
  static const double gutter = 24;

  /// Maximum reading column on wide screens.
  static const double maxContentWidth = 480;

  // Radii
  static const double radiusChip = 13;
  static const double radiusControl = 14;
  static const double radiusTile = 16;
  static const double radiusChoice = 18;
  static const double radiusCard = 20;
  static const double radiusStrategyCard = 22;
  static const double radiusPanel = 24;
  static const double radiusSheet = 28;
  static const double radiusPill = 999;

  // Controls
  static const double minTouchTarget = 44;
  static const double buttonHeight = 54;
  static const double fieldHeight = 54;
  static const double fieldHeightTall = 58;
  static const double conditionFieldHeight = 56;
  static const double searchFieldHeight = 50;
  static const double compactSearchFieldHeight = 52;
  static const double chipHeight = 26;
  static const double countPillHeight = 56;
  static const double iconTileSize = 40;
  static const double iconTileRadius = 12;
  static const double ruleIconTileSize = 36;
  static const double ruleIconTileRadius = 10;
  static const double strategyIconTileSize = 42;
  static const double strategyIconTileRadius = 13;
  static const double stepBadgeSize = 27;
  static const double stepBadgeRadius = 9;
  static const double dangerIconTileSize = 52;
  static const double dangerIconTileRadius = 16;

  // Chrome
  static const double topBarHeight = 44;
  static const double bottomNavHeight = 73;
  static const double navIndicatorWidth = 52;
  static const double navIndicatorHeight = 30;
  static const double stepperTrackHeight = 4;
  static const double stepperGap = 10;
  static const double sheetGrabberWidth = 36;
  static const double sheetGrabberHeight = 4;
  static const double borderWidth = 1;
  static const double errorBorderWidth = 1.5;

  // Icon sizes
  static const double iconSmall = 15;
  static const double iconMedium = 17;
  static const double iconDefault = 18;
  static const double iconLarge = 20;
  static const double iconXLarge = 23;
}
