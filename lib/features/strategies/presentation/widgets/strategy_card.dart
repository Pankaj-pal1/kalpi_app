import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/kalpi_colors.dart';
import '../../../../core/theme/kalpi_icons.dart';
import '../../../../core/theme/kalpi_typography.dart';
import '../../../../core/utils/number_format.dart';
import '../../../../core/widgets/kalpi_chip.dart';
import '../../../../core/widgets/kalpi_icon_button.dart';
import '../../../../core/widgets/surface_card.dart';
import '../../domain/strategy.dart';

/// Saved-strategy summary card with a separately focusable "More" action.
class StrategyCard extends StatelessWidget {
  const StrategyCard({
    super.key,
    required this.strategy,
    required this.onOpen,
    required this.onMore,
  });

  final Strategy strategy;
  final VoidCallback onOpen;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      radius: AppDimens.radiusStrategyCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimens.space16 + 2,
              AppDimens.space16,
              2,
              0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: AppDimens.space4),
                  child: IconTile(
                    icon: KalpiIcons.leaf,
                    size: AppDimens.strategyIconTileSize,
                    radius: AppDimens.strategyIconTileRadius,
                    color: KalpiColors.surfaceSelected,
                    iconSize: AppDimens.iconLarge,
                  ),
                ),
                const SizedBox(width: AppDimens.space16 - 1),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: AppDimens.space4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          strategy.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: KalpiTextStyles.strategyName,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          AppStrings.savedStrategy,
                          style: KalpiTextStyles.cardSubtitle,
                        ),
                      ],
                    ),
                  ),
                ),
                KalpiIconButton(
                  icon: KalpiIcons.more,
                  semanticLabel:
                      '${AppStrings.moreActions} for ${strategy.name}',
                  onPressed: onMore,
                  size: AppDimens.iconDefault,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.space24 + 3),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.space16 + 2,
            ),
            child: Wrap(
              spacing: 10,
              runSpacing: AppDimens.space8,
              children: <Widget>[
                KalpiChip(
                  label: strategy.universe.summaryLabel,
                  horizontalPadding: 24,
                ),
                KalpiChip(
                  label: pluralise(strategy.ranking.count, 'stock'),
                  horizontalPadding: 24,
                ),
                KalpiChip(
                  label: pluralise(strategy.rules.length, 'rule'),
                  horizontalPadding: 24,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.space16),
          const HairlineDivider(indent: AppDimens.space16 + 2),
          const SizedBox(height: AppDimens.space20 - 1),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.space16 + 2,
            ),
            child: Text(
              strategy.allocation.label,
              style: KalpiTextStyles.helper,
            ),
          ),
          const SizedBox(height: AppDimens.space12 + 2),
          Semantics(
            button: true,
            label: '${AppStrings.viewStrategy} ${strategy.name}',
            child: InkWell(
              onTap: onOpen,
              splashFactory: NoSplash.splashFactory,
              highlightColor: KalpiColors.surfaceSelected.withValues(
                alpha: 0.6,
              ),
              child: SizedBox(
                height: AppDimens.buttonHeight,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimens.space16 + 2,
                    0,
                    AppDimens.space20 + 2,
                    0,
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          AppStrings.viewStrategy,
                          style: KalpiTextStyles.link,
                        ),
                      ),
                      const Icon(
                        KalpiIcons.arrow,
                        size: AppDimens.iconDefault,
                        color: KalpiColors.accent,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
