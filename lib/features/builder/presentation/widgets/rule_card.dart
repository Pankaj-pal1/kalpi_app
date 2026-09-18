import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/theme/kalpi_colors.dart';
import '../../../../core/theme/kalpi_typography.dart';
import '../../../../core/widgets/surface_card.dart';
import '../../../strategies/domain/rule.dart';

/// One filter rule: category, human-readable condition, metric icon.
class RuleCard extends StatelessWidget {
  const RuleCard({super.key, required this.rule, required this.onTap});

  final Rule rule;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => SurfaceCard(
    radius: AppDimens.radiusChoice,
    onTap: onTap,
    semanticLabel: 'Edit rule: ${rule.title}',
    child: ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 88),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppDimens.space16,
          AppDimens.space16 - 1,
          AppDimens.space16,
          AppDimens.space16 + 2,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: IconTile(
                icon: rule.metric.icon,
                size: AppDimens.ruleIconTileSize,
                radius: AppDimens.ruleIconTileRadius,
                color: KalpiColors.surfaceSelected,
                iconSize: AppDimens.iconDefault,
              ),
            ),
            const SizedBox(width: AppDimens.space16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    rule.metric.ruleCategoryLabel,
                    style: KalpiTextStyles.ruleCategory,
                  ),
                  const SizedBox(height: 7),
                  Text(rule.title, style: KalpiTextStyles.cardTitle),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
