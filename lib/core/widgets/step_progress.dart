import 'package:flutter/material.dart';

import '../constants/app_dimens.dart';
import '../theme/kalpi_colors.dart';

/// Four equal 4px tracks; completed and active steps are green.
class StepProgress extends StatelessWidget {
  const StepProgress({super.key, required this.current, this.total = 4});

  /// 1-based active step.
  final int current;
  final int total;

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Step $current of $total',
    child: Row(
      children: <Widget>[
        for (var i = 1; i <= total; i++) ...<Widget>[
          if (i > 1) const SizedBox(width: AppDimens.stepperGap),
          Expanded(
            child: Container(
              height: AppDimens.stepperTrackHeight,
              decoration: BoxDecoration(
                color: i <= current ? KalpiColors.primary : KalpiColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ],
    ),
  );
}
