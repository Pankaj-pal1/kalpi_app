import 'package:flutter/material.dart';

import '../constants/app_dimens.dart';
import '../theme/kalpi_colors.dart';

/// A 44×44 tappable icon with an accessible name.
class KalpiIconButton extends StatelessWidget {
  const KalpiIconButton({
    super.key,
    required this.icon,
    required this.semanticLabel,
    this.onPressed,
    this.color = KalpiColors.accent,
    this.size = AppDimens.iconLarge,
    this.hitSize = AppDimens.minTouchTarget,
  });

  final IconData icon;
  final String semanticLabel;
  final VoidCallback? onPressed;
  final Color color;
  final double size;
  final double hitSize;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: semanticLabel,
    child: SizedBox(
      width: hitSize,
      height: hitSize,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          splashFactory: NoSplash.splashFactory,
          highlightColor: KalpiColors.surfaceSelected,
          child: Center(
            child: Icon(icon, size: size, color: color),
          ),
        ),
      ),
    ),
  );
}
