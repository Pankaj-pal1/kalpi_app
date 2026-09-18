import 'package:flutter/material.dart';

import '../constants/app_dimens.dart';
import '../theme/kalpi_colors.dart';

/// Rounded surface with the quiet 1px border used for cards and tiles.
class SurfaceCard extends StatelessWidget {
  const SurfaceCard({
    super.key,
    required this.child,
    this.radius = AppDimens.radiusCard,
    this.color = KalpiColors.surface,
    this.borderColor = KalpiColors.border,
    this.borderWidth = AppDimens.borderWidth,
    this.padding = EdgeInsets.zero,
    this.onTap,
    this.semanticLabel,
    this.clip = true,
  });

  final Widget child;
  final double radius;
  final Color color;
  final Color? borderColor;
  final double borderWidth;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final bool clip;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
      side: borderColor == null
          ? BorderSide.none
          : BorderSide(color: borderColor!, width: borderWidth),
    );
    Widget content = Padding(padding: padding, child: child);
    if (onTap != null) {
      content = InkWell(
        onTap: onTap,
        splashFactory: NoSplash.splashFactory,
        highlightColor: KalpiColors.surfaceSelected.withValues(alpha: 0.6),
        child: content,
      );
    }
    final card = Material(
      color: color,
      shape: shape,
      clipBehavior: clip ? Clip.antiAlias : Clip.none,
      child: content,
    );
    if (semanticLabel == null) return card;
    return Semantics(button: onTap != null, label: semanticLabel, child: card);
  }
}

/// Square tile that frames a 20px icon.
class IconTile extends StatelessWidget {
  const IconTile({
    super.key,
    required this.icon,
    this.size = AppDimens.iconTileSize,
    this.radius = AppDimens.iconTileRadius,
    this.color = KalpiColors.background,
    this.iconColor = KalpiColors.accent,
    this.iconSize = AppDimens.iconLarge,
  });

  final IconData icon;
  final double size;
  final double radius;
  final Color color;
  final Color iconColor;
  final double iconSize;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
    ),
    alignment: Alignment.center,
    child: Icon(icon, size: iconSize, color: iconColor),
  );
}

/// 1px horizontal rule in the border colour.
class HairlineDivider extends StatelessWidget {
  const HairlineDivider({super.key, this.indent = 0});

  final double indent;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(horizontal: indent),
    child: const SizedBox(
      height: 1,
      width: double.infinity,
      child: ColoredBox(color: KalpiColors.border),
    ),
  );
}
