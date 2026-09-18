import 'package:flutter/material.dart';

import '../constants/app_dimens.dart';
import '../theme/kalpi_colors.dart';
import '../theme/kalpi_typography.dart';

/// 56px selectable number tile used for the holdings count.
class CountPill extends StatelessWidget {
  const CountPill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.enabled = true,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: selected,
    enabled: enabled,
    inMutuallyExclusiveGroup: true,
    label: label,
    child: Opacity(
      opacity: enabled ? 1 : 0.45,
      child: Material(
        color: selected ? KalpiColors.primary : KalpiColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusControl),
          side: selected
              ? BorderSide.none
              : const BorderSide(
                  color: KalpiColors.border,
                  width: AppDimens.borderWidth,
                ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: enabled ? onTap : null,
          splashFactory: NoSplash.splashFactory,
          highlightColor: KalpiColors.surfaceSelected,
          child: SizedBox(
            height: AppDimens.countPillHeight,
            child: Center(
              child: Text(
                label,
                style: KalpiTextStyles.countPill.copyWith(
                  color: selected ? KalpiColors.onPrimary : KalpiColors.text,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
