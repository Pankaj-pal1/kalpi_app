import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/kalpi_colors.dart';
import '../../../../core/theme/kalpi_icons.dart';
import '../../../../core/theme/kalpi_typography.dart';

/// Shown for the instant preferences take to load. Dark, never white.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
    backgroundColor: KalpiColors.background,
    body: Center(child: KalpiWordmark()),
  );
}

/// Leaf glyph + "kalpi" wordmark.
class KalpiWordmark extends StatelessWidget {
  const KalpiWordmark({super.key});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const Padding(
        padding: EdgeInsets.only(left: AppDimens.space4, top: 2),
        child: Icon(KalpiIcons.leaf, size: 25, color: KalpiColors.accent),
      ),
      const SizedBox(width: AppDimens.space12 + 1),
      Text(AppStrings.appName, style: KalpiTextStyles.logo),
    ],
  );
}
