import 'package:flutter/material.dart';

import '../constants/app_dimens.dart';
import '../constants/app_durations.dart';
import '../theme/kalpi_colors.dart';

/// Shows a modal sheet with the shared frame: 64% scrim, 28px top corners,
/// grabber, keyboard-aware padding and a dismissible barrier unless
/// [isDismissible] is false (consequential confirmations).
Future<T?> showKalpiSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isDismissible = true,
  bool useRootNavigator = true,
}) {
  final reduceMotion = MediaQuery.disableAnimationsOf(context);
  return showModalBottomSheet<T>(
    context: context,
    useRootNavigator: useRootNavigator,
    isScrollControlled: true,
    isDismissible: isDismissible,
    enableDrag: isDismissible,
    backgroundColor: Colors.transparent,
    barrierColor: KalpiColors.scrim,
    sheetAnimationStyle: AnimationStyle(
      duration: reduceMotion ? Duration.zero : AppDurations.sheet,
      reverseDuration: reduceMotion ? Duration.zero : AppDurations.sheet,
    ),
    constraints: const BoxConstraints(maxWidth: AppDimens.maxContentWidth),
    builder: (context) => KalpiSheetFrame(child: builder(context)),
  );
}

/// The visual frame of every bottom sheet.
class KalpiSheetFrame extends StatelessWidget {
  const KalpiSheetFrame({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final maxHeight = media.size.height * 0.92;
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: Padding(
        padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
        child: Material(
          color: KalpiColors.surface,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppDimens.radiusSheet),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: AppDimens.space12),
                Container(
                  width: AppDimens.sheetGrabberWidth,
                  height: AppDimens.sheetGrabberHeight,
                  decoration: BoxDecoration(
                    color: KalpiColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      AppDimens.gutter,
                      AppDimens.space20 + 2,
                      AppDimens.gutter,
                      AppDimens.space16 + media.padding.bottom,
                    ),
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
