import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/kalpi_colors.dart';
import '../../../../core/theme/kalpi_icons.dart';
import '../../../../core/theme/kalpi_typography.dart';
import '../../../../core/widgets/kalpi_button.dart';
import '../../../../core/widgets/surface_card.dart';

/// "Your first idea starts here." — the true empty state.
class EmptyStateCard extends StatelessWidget {
  const EmptyStateCard({super.key, required this.onBuild});

  final VoidCallback onBuild;

  @override
  Widget build(BuildContext context) => SurfaceCard(
    radius: AppDimens.radiusPanel,
    padding: const EdgeInsets.fromLTRB(
      AppDimens.space20,
      AppDimens.space32 + 3,
      AppDimens.space20,
      AppDimens.space16 + 1,
    ),
    child: Column(
      children: <Widget>[
        Container(
          width: 156,
          height: 116,
          decoration: BoxDecoration(
            color: KalpiColors.surfaceSelected,
            borderRadius: BorderRadius.circular(AppDimens.radiusSheet),
          ),
          alignment: Alignment.center,
          child: const Icon(
            KalpiIcons.stack,
            size: 35,
            color: KalpiColors.accent,
          ),
        ),
        const SizedBox(height: AppDimens.space24 + 3),
        Text(
          AppStrings.emptyTitle,
          textAlign: TextAlign.center,
          style: KalpiTextStyles.emptyTitle,
        ),
        const SizedBox(height: AppDimens.space16 + 1),
        Text(
          AppStrings.emptyBody,
          textAlign: TextAlign.center,
          style: KalpiTextStyles.subtitle,
        ),
        const SizedBox(height: AppDimens.space32 + 4),
        KalpiButton(
          label: AppStrings.emptyCta,
          icon: KalpiIcons.arrow,
          onPressed: onBuild,
        ),
      ],
    ),
  );
}

/// "New to rule-based investing?" promo pointing to the guide.
class LearnPromoCard extends StatelessWidget {
  const LearnPromoCard({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => SurfaceCard(
    radius: AppDimens.radiusCard,
    color: KalpiColors.surfaceSelected,
    borderColor: null,
    onTap: onTap,
    semanticLabel: '${AppStrings.learnPromoTitle} ${AppStrings.learnPromoLink}',
    padding: const EdgeInsets.fromLTRB(
      AppDimens.space20,
      AppDimens.space20 - 1,
      AppDimens.space20,
      AppDimens.space16 + 1,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(top: AppDimens.space4 + 1),
          child: Icon(
            KalpiIcons.book,
            size: AppDimens.iconLarge,
            color: KalpiColors.accent,
          ),
        ),
        const SizedBox(width: AppDimens.space16 + 1),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                AppStrings.learnPromoTitle,
                style: KalpiTextStyles.listTitle,
              ),
              const SizedBox(height: AppDimens.space8 + 2),
              Text(
                AppStrings.learnPromoBody,
                style: KalpiTextStyles.cardSubtitle,
              ),
              const SizedBox(height: AppDimens.space20 + 1),
              Text(AppStrings.learnPromoLink, style: KalpiTextStyles.linkSmall),
            ],
          ),
        ),
      ],
    ),
  );
}
