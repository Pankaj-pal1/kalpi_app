import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/kalpi_colors.dart';
import '../../../../core/theme/kalpi_icons.dart';
import '../../../../core/theme/kalpi_typography.dart';
import '../../../../core/widgets/kalpi_button.dart';
import '../../../../core/widgets/kalpi_scaffold.dart';
import '../../../../core/widgets/page_header.dart';
import 'splash_page.dart';

/// Onboarding · Welcome.
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return KalpiScaffold(
      body: ScrollableWithFooter(
        padding: const EdgeInsets.fromLTRB(
          AppDimens.gutter,
          0,
          AppDimens.gutter,
          0,
        ),
        footer: ActionFooter(
          caption: Text(
            AppStrings.welcomeFootnote,
            textAlign: TextAlign.center,
            style: KalpiTextStyles.caption,
          ),
          child: KalpiButton(
            label: AppStrings.welcomeCta,
            icon: KalpiIcons.arrow,
            onPressed: () => context.go(AppRoutes.experience),
          ),
        ),
        children: <Widget>[
          const SizedBox(height: AppDimens.space20 + 1),
          const KalpiWordmark(),
          const SizedBox(height: AppDimens.space32 + 3),
          const EyebrowPill(label: AppStrings.tagline),
          const SizedBox(height: AppDimens.space24),
          Semantics(
            header: true,
            child: Text(
              AppStrings.welcomeHeadline,
              style: KalpiTextStyles.hero,
            ),
          ),
          const SizedBox(height: AppDimens.space16 + 2),
          Text(AppStrings.welcomeBody, style: KalpiTextStyles.heroSubtitle),
          const SizedBox(height: AppDimens.space48 + 2),
          const _JourneyIllustration(),
          const SizedBox(height: AppDimens.space24),
        ],
      ),
    );
  }
}

/// The stacked "universe → rules → strategy" illustration card.
class _JourneyIllustration extends StatelessWidget {
  const _JourneyIllustration();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(27, 27, 19, 17),
      decoration: BoxDecoration(
        color: KalpiColors.surfaceSelected,
        borderRadius: BorderRadius.circular(AppDimens.radiusSheet),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Align(
            alignment: Alignment.centerLeft,
            child: _JourneyRow(
              icon: KalpiIcons.grid,
              title: AppStrings.welcomeStepUniverseTitle,
              subtitle: AppStrings.welcomeStepUniverseSubtitle,
              color: KalpiColors.surface,
              titleColor: KalpiColors.text,
              subtitleColor: KalpiColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimens.space12),
          const Padding(
            padding: EdgeInsets.only(left: AppDimens.space12 + 2),
            child: _JourneyRow(
              icon: KalpiIcons.rules,
              title: AppStrings.welcomeStepRulesTitle,
              subtitle: AppStrings.welcomeStepRulesSubtitle,
              color: KalpiColors.primary,
              titleColor: KalpiColors.onPrimary,
              subtitleColor: KalpiColors.onPrimaryMuted,
            ),
          ),
          const SizedBox(height: AppDimens.space12),
          Padding(
            padding: const EdgeInsets.only(left: 29),
            child: Container(
              height: AppDimens.chipHeight,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: KalpiColors.accent,
                borderRadius: BorderRadius.circular(AppDimens.radiusChip),
              ),
              child: Center(
                widthFactor: 1,
                child: Text(
                  AppStrings.welcomeStepResult,
                  style: KalpiTextStyles.chip.copyWith(
                    color: KalpiColors.background,
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

class _JourneyRow extends StatelessWidget {
  const _JourneyRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.titleColor,
    required this.subtitleColor,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Color titleColor;
  final Color subtitleColor;

  @override
  Widget build(BuildContext context) => Container(
    width: 282,
    height: 62,
    padding: const EdgeInsets.fromLTRB(
      AppDimens.space20,
      AppDimens.space12,
      AppDimens.space12,
      AppDimens.space12,
    ),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(AppDimens.radiusTile),
    ),
    child: Row(
      children: <Widget>[
        Icon(icon, size: AppDimens.iconLarge, color: KalpiColors.accent),
        const SizedBox(width: AppDimens.space20 - 1),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: KalpiTextStyles.body(
                  13,
                  weight: FontWeight.w600,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: KalpiTextStyles.body(12, color: subtitleColor),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
