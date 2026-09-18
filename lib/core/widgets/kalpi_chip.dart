import 'package:flutter/material.dart';

import '../constants/app_dimens.dart';
import '../theme/kalpi_colors.dart';
import '../theme/kalpi_typography.dart';

enum KalpiChipStyle { accent, primary, muted }

/// 26px pill. Informational by default; pass [onTap] and [selected] for a
/// filter chip, which then behaves as a toggle button.
class KalpiChip extends StatelessWidget {
  const KalpiChip({
    super.key,
    required this.label,
    this.style = KalpiChipStyle.accent,
    this.onTap,
    this.selected,
    this.horizontalPadding = 20,
  });

  final String label;
  final KalpiChipStyle style;
  final VoidCallback? onTap;
  final bool? selected;

  /// Inner padding either side of the label.
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final effective = selected == null
        ? style
        : (selected! ? KalpiChipStyle.primary : KalpiChipStyle.muted);
    final Color bg;
    final TextStyle text;
    switch (effective) {
      case KalpiChipStyle.accent:
        bg = KalpiColors.surfaceSelected;
        text = KalpiTextStyles.chip;
      case KalpiChipStyle.primary:
        bg = KalpiColors.primary;
        text = KalpiTextStyles.chipOnPrimary;
      case KalpiChipStyle.muted:
        bg = KalpiColors.surface;
        text = KalpiTextStyles.chipMuted;
    }
    final chip = Container(
      height: AppDimens.chipHeight,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppDimens.radiusChip),
      ),
      child: Center(
        widthFactor: 1,
        child: Text(
          label,
          style: text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
    if (onTap == null) return chip;
    return Semantics(
      button: true,
      selected: selected ?? false,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimens.radiusChip + 5),
          splashFactory: NoSplash.splashFactory,
          // Vertical padding grows the hit area to 36px without widening it.
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: chip,
          ),
        ),
      ),
    );
  }
}
