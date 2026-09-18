import 'dart:ui';

/// Kalpi colour tokens. Dark theme only — there is no light palette.
///
/// Values are normative and sourced from the design token file
/// (`tokens.json`) that accompanies the Penpot design.
abstract final class KalpiColors {
  // Surfaces
  static const Color background = Color(0xFF0B1210);
  static const Color surface = Color(0xFF141F1A);
  static const Color surfaceSelected = Color(0xFF163329);
  static const Color border = Color(0xFF30463A);
  static const Color borderInteractive = Color(0xFF657D6F);

  // Text
  static const Color text = Color(0xFFF2F7F4);
  static const Color textSecondary = Color(0xFFA4B7AE);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryMuted = Color(0xFFB8E7D2);

  // Brand
  static const Color primary = Color(0xFF0B8161);
  static const Color primaryHover = Color(0xFF0A7659);
  static const Color primaryPressed = Color(0xFF08664C);
  static const Color primaryMid = Color(0xFF39896C);
  static const Color accent = Color(0xFF71D7AC);
  static const Color focus = Color(0xFF71D7AC);

  // Danger
  static const Color danger = Color(0xFFA53E43);
  static const Color dangerText = Color(0xFFFF9AA7);
  static const Color dangerSurface = Color(0xFF351D24);

  // Overlays
  static const Color scrim = Color(0xA3000000); // rgba(0,0,0,0.64)
}
