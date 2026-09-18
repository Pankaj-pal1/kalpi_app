import 'package:flutter/material.dart';

import '../constants/app_dimens.dart';
import '../constants/app_strings.dart';
import '../theme/kalpi_colors.dart';
import '../theme/kalpi_icons.dart';
import '../theme/kalpi_typography.dart';
import 'kalpi_icon_button.dart';

/// Compact 44px header: back chevron, title and an optional trailing action.
class KalpiTopBar extends StatelessWidget {
  const KalpiTopBar({
    super.key,
    this.title,
    this.onBack,
    this.trailing,
    this.backLabel = AppStrings.back,
  });

  final String? title;
  final VoidCallback? onBack;
  final Widget? trailing;
  final String backLabel;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(
      AppDimens.space16,
      AppDimens.space8,
      AppDimens.space16,
      0,
    ),
    child: SizedBox(
      height: AppDimens.topBarHeight,
      child: Row(
        children: <Widget>[
          if (onBack != null)
            KalpiIconButton(
              icon: KalpiIcons.back,
              semanticLabel: backLabel,
              onPressed: onBack,
              size: AppDimens.iconLarge,
            )
          else
            const SizedBox(width: AppDimens.minTouchTarget),
          const SizedBox(width: AppDimens.space12 + 2),
          Expanded(
            child: title == null
                ? const SizedBox.shrink()
                : Semantics(
                    header: true,
                    child: Text(
                      title!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: KalpiTextStyles.topBarTitle,
                    ),
                  ),
          ),
          ?trailing,
        ],
      ),
    ),
  );
}

/// Text action for the header ("Skip", "Exit").
class TopBarTextAction extends StatelessWidget {
  const TopBarTextAction({
    super.key,
    required this.label,
    required this.onPressed,
    this.style,
    this.minWidth = 64,
  });

  final String label;
  final VoidCallback onPressed;
  final TextStyle? style;
  final double minWidth;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    child: ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: minWidth,
        minHeight: AppDimens.minTouchTarget,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppDimens.space8),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          splashFactory: NoSplash.splashFactory,
          highlightColor: KalpiColors.surface,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.space16),
            child: Center(
              child: Text(label, style: style ?? KalpiTextStyles.topBarAction),
            ),
          ),
        ),
      ),
    ),
  );
}
