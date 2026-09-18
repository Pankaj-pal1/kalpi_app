import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/kalpi_colors.dart';
import '../../../../core/theme/kalpi_typography.dart';
import '../../../../core/utils/number_format.dart';
import '../../../../core/widgets/surface_card.dart';
import '../../../strategies/domain/allocation_mode.dart';

/// Illustrative bar preview of how weight is split across holdings.
class AllocationPreview extends StatelessWidget {
  const AllocationPreview({
    super.key,
    required this.holdings,
    required this.mode,
  });

  final int holdings;
  final AllocationMode mode;

  static const List<Color> _palette = <Color>[
    KalpiColors.primary,
    KalpiColors.primaryMid,
    KalpiColors.accent,
  ];

  @override
  Widget build(BuildContext context) {
    final count = holdings.clamp(1, 40);
    final isEqual = mode == AllocationMode.equal;
    final title = isEqual
        ? AppStrings.balancedSplitTitle(count)
        : AppStrings.marketCapPreviewTitle;
    final caption = isEqual
        ? AppStrings.approxPerStock(formatPercent(100 / count))
        : AppStrings.marketCapPreviewNote;
    return SurfaceCard(
      radius: AppDimens.radiusCard,
      padding: const EdgeInsets.fromLTRB(
        AppDimens.space16,
        AppDimens.space16 + 2,
        AppDimens.space16 + 2,
        AppDimens.space24 + 5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: KalpiTextStyles.cardTitle),
          const SizedBox(height: AppDimens.space24 + 2),
          SizedBox(
            height: 31,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                for (var i = 0; i < count; i++) ...<Widget>[
                  if (i > 0) const SizedBox(width: 5),
                  Expanded(
                    child: Container(
                      height: isEqual ? 31 : _capHeight(i, count),
                      decoration: BoxDecoration(
                        color: _palette[i % _palette.length],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppDimens.space16 + 2),
          Text(caption, style: KalpiTextStyles.helper),
        ],
      ),
    );
  }

  /// Descending heights for the market-cap illustration (largest first).
  double _capHeight(int index, int count) {
    if (count == 1) return 31;
    final t = index / (count - 1);
    return 31 - (t * 21);
  }
}
