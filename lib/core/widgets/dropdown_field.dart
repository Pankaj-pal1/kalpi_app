import 'package:flutter/material.dart';

import '../constants/app_dimens.dart';
import '../theme/kalpi_colors.dart';
import '../theme/kalpi_icons.dart';
import '../theme/kalpi_typography.dart';

/// Tappable field that looks like a select: value text plus a chevron.
class DropdownField extends StatelessWidget {
  const DropdownField({
    super.key,
    required this.value,
    required this.onTap,
    this.subtitle,
    this.leading,
    this.height = AppDimens.fieldHeightTall,
    this.color = KalpiColors.background,
    this.textStyle,
    this.semanticLabel,
  });

  final String value;
  final String? subtitle;
  final Widget? leading;
  final VoidCallback onTap;
  final double height;
  final Color color;
  final TextStyle? textStyle;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: semanticLabel ?? value,
    child: Material(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusControl),
        side: const BorderSide(
          color: KalpiColors.border,
          width: AppDimens.borderWidth,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        splashFactory: NoSplash.splashFactory,
        highlightColor: KalpiColors.surfaceSelected,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: height),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.space16 + 2,
            ),
            child: Row(
              children: <Widget>[
                if (leading != null) ...<Widget>[
                  leading!,
                  const SizedBox(width: AppDimens.space20),
                ],
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textStyle ?? KalpiTextStyles.fieldValueCompact,
                      ),
                      if (subtitle != null) ...<Widget>[
                        const SizedBox(height: 3),
                        Text(subtitle!, style: KalpiTextStyles.cardSubtitle),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppDimens.space12),
                const Icon(
                  KalpiIcons.down,
                  size: 15,
                  color: KalpiColors.accent,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
