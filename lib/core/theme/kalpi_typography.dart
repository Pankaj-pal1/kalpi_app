import 'package:flutter/painting.dart';

import 'kalpi_colors.dart';

/// Font families bundled with the app (see `pubspec.yaml`).
abstract final class KalpiFonts {
  /// Display face used for page titles and the hero statement.
  static const String display = 'Manrope';

  /// Body face used for everything else.
  static const String body = 'InterTight';
}

/// Text styles that mirror the Penpot design one-to-one.
///
/// Every style uses a 1.35 line height with even leading distribution, which
/// reproduces the CSS `line-height` behaviour Penpot renders with.
abstract final class KalpiTextStyles {
  static const double lineHeight = 1.35;

  static TextStyle display(
    double size, {
    FontWeight weight = FontWeight.w700,
    Color color = KalpiColors.text,
  }) => TextStyle(
    fontFamily: KalpiFonts.display,
    fontSize: size,
    fontWeight: weight,
    height: lineHeight,
    color: color,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static TextStyle body(
    double size, {
    FontWeight weight = FontWeight.w400,
    Color color = KalpiColors.text,
  }) => TextStyle(
    fontFamily: KalpiFonts.body,
    fontSize: size,
    fontWeight: weight,
    height: lineHeight,
    color: color,
    leadingDistribution: TextLeadingDistribution.even,
  );

  // ---- Display (Manrope) -------------------------------------------------
  static final TextStyle hero = display(39);
  static final TextStyle pageTitle = display(28);
  static final TextStyle pageTitleLarge = display(30);
  static final TextStyle sheetTitle = display(24);
  static final TextStyle logo = display(26, weight: FontWeight.w800);

  // ---- Body (Inter Tight) -------------------------------------------------
  static final TextStyle topBarTitle = body(14, weight: FontWeight.w600);
  static final TextStyle topBarAction = body(
    13,
    weight: FontWeight.w500,
    color: KalpiColors.textSecondary,
  );
  static final TextStyle topBarExit = body(
    12,
    weight: FontWeight.w500,
    color: KalpiColors.textSecondary,
  );

  static final TextStyle subtitle = body(14, color: KalpiColors.textSecondary);
  static final TextStyle heroSubtitle = body(
    15,
    color: KalpiColors.textSecondary,
  );
  static final TextStyle eyebrow = body(
    13,
    weight: FontWeight.w500,
    color: KalpiColors.textSecondary,
  );
  static final TextStyle fieldLabel = body(
    13,
    weight: FontWeight.w500,
    color: KalpiColors.textSecondary,
  );
  static final TextStyle fieldLabelSmall = body(
    12,
    weight: FontWeight.w500,
    color: KalpiColors.textSecondary,
  );

  static final TextStyle cardTitle = body(16, weight: FontWeight.w600);
  static final TextStyle cardTitleMedium = body(16, weight: FontWeight.w500);
  static final TextStyle cardSubtitle = body(
    12,
    color: KalpiColors.textSecondary,
  );
  static final TextStyle listTitle = body(14, weight: FontWeight.w600);
  static final TextStyle strategyName = body(19, weight: FontWeight.w700);
  static final TextStyle strategyNameCompact = body(
    18,
    weight: FontWeight.w700,
  );
  static final TextStyle preferenceValue = body(17, weight: FontWeight.w600);
  static final TextStyle emptyTitle = body(22, weight: FontWeight.w700);
  static final TextStyle statValue = body(23, weight: FontWeight.w700);
  static final TextStyle statLabel = body(10, color: KalpiColors.textSecondary);
  static final TextStyle sectionHeading = body(19, weight: FontWeight.w700);
  static final TextStyle errorTitle = body(20, weight: FontWeight.w700);
  static final TextStyle countPill = body(18, weight: FontWeight.w600);
  static final TextStyle numericValue = body(21, weight: FontWeight.w600);

  static final TextStyle chip = body(
    11,
    weight: FontWeight.w600,
    color: KalpiColors.accent,
  );
  static final TextStyle chipOnPrimary = body(
    11,
    weight: FontWeight.w600,
    color: KalpiColors.onPrimary,
  );
  static final TextStyle chipMuted = body(
    11,
    weight: FontWeight.w600,
    color: KalpiColors.textSecondary,
  );
  static final TextStyle navLabel = body(11, weight: FontWeight.w600);

  static final TextStyle button = body(15, weight: FontWeight.w600);
  static final TextStyle link = body(
    14,
    weight: FontWeight.w600,
    color: KalpiColors.accent,
  );
  static final TextStyle linkSmall = body(
    13,
    weight: FontWeight.w600,
    color: KalpiColors.accent,
  );
  static final TextStyle banner = body(
    13,
    weight: FontWeight.w600,
    color: KalpiColors.accent,
  );
  static final TextStyle info = body(13, color: KalpiColors.accent);
  static final TextStyle helper = body(13, color: KalpiColors.textSecondary);
  static final TextStyle caption = body(12, color: KalpiColors.textSecondary);
  static final TextStyle captionSmall = body(
    11,
    color: KalpiColors.textSecondary,
  );
  static final TextStyle fieldValue = body(16, weight: FontWeight.w600);
  static final TextStyle fieldValueMedium = body(16, weight: FontWeight.w500);
  static final TextStyle fieldValueCompact = body(15, weight: FontWeight.w600);
  static final TextStyle fieldValueRegular = body(15);
  static final TextStyle fieldError = body(
    11,
    weight: FontWeight.w500,
    color: KalpiColors.dangerText,
  );
  static final TextStyle fieldErrorRegular = body(
    12,
    color: KalpiColors.dangerText,
  );
  static final TextStyle summaryLabel = body(
    11,
    color: KalpiColors.textSecondary,
  );
  static final TextStyle summaryValue = body(14, weight: FontWeight.w500);
  static final TextStyle detailKey = body(13, color: KalpiColors.textSecondary);
  static final TextStyle detailValue = body(14, weight: FontWeight.w600);
  static final TextStyle detailValueSecondary = body(
    13,
    weight: FontWeight.w500,
  );
  static final TextStyle stepBadge = body(
    12,
    weight: FontWeight.w600,
    color: KalpiColors.accent,
  );
  static final TextStyle ruleCategory = body(
    12,
    weight: FontWeight.w500,
    color: KalpiColors.textSecondary,
  );
  static final TextStyle andLabel = body(
    11,
    weight: FontWeight.w600,
    color: KalpiColors.textSecondary,
  );
}
