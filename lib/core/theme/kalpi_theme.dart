import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'kalpi_colors.dart';
import 'kalpi_typography.dart';

/// The single (dark) theme. There is deliberately no light variant.
abstract final class KalpiTheme {
  static ThemeData get dark {
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: KalpiColors.primary,
      onPrimary: KalpiColors.onPrimary,
      secondary: KalpiColors.accent,
      onSecondary: KalpiColors.background,
      error: KalpiColors.danger,
      onError: KalpiColors.onPrimary,
      surface: KalpiColors.surface,
      onSurface: KalpiColors.text,
      surfaceContainerHighest: KalpiColors.surfaceSelected,
      outline: KalpiColors.border,
      outlineVariant: KalpiColors.borderInteractive,
    );
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      fontFamily: KalpiFonts.body,
      scaffoldBackgroundColor: KalpiColors.background,
      canvasColor: KalpiColors.background,
      splashFactory: NoSplash.splashFactory,
      highlightColor: KalpiColors.surfaceSelected,
      dividerColor: KalpiColors.border,
      visualDensity: VisualDensity.standard,
    );
    return base.copyWith(
      textTheme: base.textTheme.apply(
        fontFamily: KalpiFonts.body,
        bodyColor: KalpiColors.text,
        displayColor: KalpiColors.text,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: KalpiColors.accent,
        selectionColor: Color(0x5571D7AC),
        selectionHandleColor: KalpiColors.accent,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? KalpiColors.onPrimary
              : KalpiColors.textSecondary,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? KalpiColors.primary
              : KalpiColors.surfaceSelected,
        ),
        trackOutlineColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? KalpiColors.primary
              : KalpiColors.border,
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: KalpiColors.accent,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: KalpiColors.surfaceSelected,
        contentTextStyle: KalpiTextStyles.banner,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  /// Light status-bar icons on the dark background.
  static const SystemUiOverlayStyle overlayStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: KalpiColors.surface,
    systemNavigationBarIconBrightness: Brightness.light,
  );
}
