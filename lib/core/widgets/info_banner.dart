import 'package:flutter/material.dart';

import '../constants/app_dimens.dart';
import '../theme/kalpi_colors.dart';
import '../theme/kalpi_icons.dart';
import '../theme/kalpi_typography.dart';

/// Mint-tinted explanatory panel with an info icon.
class InfoBanner extends StatelessWidget {
  const InfoBanner({
    super.key,
    required this.text,
    this.title,
    this.icon = KalpiIcons.info,
    this.iconColor = KalpiColors.accent,
    this.textStyle,
  });

  final String text;
  final String? title;
  final IconData icon;
  final Color iconColor;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(
      AppDimens.space16 + 2,
      AppDimens.space16,
      AppDimens.space16 + 3,
      AppDimens.space16 + 3,
    ),
    decoration: BoxDecoration(
      color: KalpiColors.surfaceSelected,
      borderRadius: BorderRadius.circular(AppDimens.radiusTile),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(icon, size: AppDimens.iconMedium, color: iconColor),
        ),
        const SizedBox(width: AppDimens.space12 + 1),
        Expanded(
          child: Text(
            title == null ? text : '$title\n$text',
            style: textStyle ?? KalpiTextStyles.info,
          ),
        ),
      ],
    ),
  );
}

/// Success banner shown above lists ("“Quality first” saved").
class StatusBanner extends StatelessWidget {
  const StatusBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: true,
    child: Container(
      height: 49,
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.space16 + 2),
      decoration: BoxDecoration(
        color: KalpiColors.surfaceSelected,
        borderRadius: BorderRadius.circular(AppDimens.radiusControl),
      ),
      child: Row(
        children: <Widget>[
          const Icon(
            KalpiIcons.check,
            size: AppDimens.iconMedium,
            color: KalpiColors.accent,
          ),
          const SizedBox(width: AppDimens.space16 - 1),
          Expanded(
            child: Text(
              message,
              style: KalpiTextStyles.banner,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ),
  );
}
