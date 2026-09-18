import 'package:flutter/material.dart';

import '../constants/app_dimens.dart';
import '../theme/kalpi_colors.dart';
import '../theme/kalpi_typography.dart';

/// Page title with an optional eyebrow pill above and subtitle below.
class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.eyebrow,
    this.titleStyle,
    this.subtitleStyle,
    this.subtitleGap = 7,
  });

  final String title;
  final String? subtitle;
  final String? eyebrow;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final double subtitleGap;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      if (eyebrow != null) ...<Widget>[
        EyebrowPill(label: eyebrow!),
        const SizedBox(height: AppDimens.space20 - 1),
      ],
      Semantics(
        header: true,
        child: Text(title, style: titleStyle ?? KalpiTextStyles.pageTitle),
      ),
      if (subtitle != null) ...<Widget>[
        SizedBox(height: subtitleGap),
        Text(subtitle!, style: subtitleStyle ?? KalpiTextStyles.subtitle),
      ],
    ],
  );
}

/// Small uppercase label pill, e.g. "PERSONALISE YOUR GUIDANCE".
class EyebrowPill extends StatelessWidget {
  const EyebrowPill({
    super.key,
    required this.label,
    this.color = KalpiColors.surfaceSelected,
    this.textColor = KalpiColors.accent,
  });

  final String label;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: Container(
      height: AppDimens.chipHeight,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppDimens.radiusChip),
      ),
      child: Center(
        widthFactor: 1,
        child: Text(
          label,
          style: KalpiTextStyles.chip.copyWith(color: textColor),
        ),
      ),
    ),
  );
}
