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
import '../../../../core/widgets/kalpi_top_bar.dart';
import '../../../../core/widgets/page_header.dart';
import '../../../../core/widgets/surface_card.dart';
import '../../../builder/presentation/builder_launcher.dart';

/// Learn — the two-minute worked example.
class LearnPage extends StatelessWidget {
  const LearnPage({super.key});

  void _back(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.strategies);
    }
  }

  @override
  Widget build(BuildContext context) {
    return KalpiScaffold(
      body: Column(
        children: <Widget>[
          KalpiTopBar(
            title: AppStrings.learnTopBar,
            onBack: () => _back(context),
          ),
          Expanded(
            child: ScrollableWithFooter(
              footer: ActionFooter(
                child: KalpiButton(
                  label: AppStrings.tryBuildingIt,
                  icon: KalpiIcons.arrow,
                  onPressed: () =>
                      BuilderLauncher.startCreate(context, useExample: true),
                ),
              ),
              children: const <Widget>[
                SizedBox(height: AppDimens.space24 + 4),
                PageHeader(
                  eyebrow: AppStrings.learnEyebrow,
                  title: AppStrings.learnTitle,
                  subtitle: AppStrings.learnQuote,
                  subtitleGap: 7,
                ),
                SizedBox(height: AppDimens.space48 + 7),
                _GuideStep(
                  icon: KalpiIcons.grid,
                  title: AppStrings.learnStep1Title,
                  body: AppStrings.learnStep1Body,
                ),
                SizedBox(height: AppDimens.space16 - 1),
                _GuideStep(
                  icon: KalpiIcons.rules,
                  title: AppStrings.learnStep2Title,
                  body: AppStrings.learnStep2Body,
                ),
                SizedBox(height: AppDimens.space16 - 1),
                _GuideStep(
                  icon: KalpiIcons.stack,
                  title: AppStrings.learnStep3Title,
                  body: AppStrings.learnStep3Body,
                ),
                SizedBox(height: AppDimens.space32 + 2),
                _Footnote(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Footnote extends StatelessWidget {
  const _Footnote();

  @override
  Widget build(BuildContext context) =>
      Text(AppStrings.learnFootnote, style: KalpiTextStyles.caption);
}

class _GuideStep extends StatelessWidget {
  const _GuideStep({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) => SurfaceCard(
    radius: AppDimens.radiusChoice,
    padding: const EdgeInsets.fromLTRB(
      AppDimens.space16 + 2,
      AppDimens.space16,
      AppDimens.space16,
      AppDimens.space16 + 2,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: AppDimens.iconLarge,
          child: Icon(
            icon,
            size: AppDimens.iconLarge,
            color: KalpiColors.accent,
          ),
        ),
        const SizedBox(width: AppDimens.space20 + 1),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: KalpiTextStyles.listTitle),
              const SizedBox(height: AppDimens.space12),
              Text(body, style: KalpiTextStyles.cardSubtitle),
            ],
          ),
        ),
      ],
    ),
  );
}
