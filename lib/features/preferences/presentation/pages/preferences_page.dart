import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/constants/app_config.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/kalpi_colors.dart';
import '../../../../core/theme/kalpi_icons.dart';
import '../../../../core/theme/kalpi_typography.dart';
import '../../../../core/widgets/kalpi_button.dart';
import '../../../../core/widgets/kalpi_scaffold.dart';
import '../../../../core/widgets/page_header.dart';
import '../../../../core/widgets/surface_card.dart';
import '../../../onboarding/presentation/cubit/preferences_cubit.dart';

/// Your preferences — guidance settings plus clearly labelled demo controls.
class PreferencesPage extends StatelessWidget {
  const PreferencesPage({super.key});

  void _done(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.strategies);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PreferencesCubit, PreferencesState>(
      builder: (context, state) {
        return KalpiScaffold(
          body: ScrollableWithFooter(
            footer: ActionFooter(
              child: KalpiButton(
                label: AppStrings.backToMyStrategies,
                icon: KalpiIcons.check,
                onPressed: () => _done(context),
              ),
            ),
            children: <Widget>[
              const SizedBox(height: AppDimens.space32 - 3),
              const PageHeader(
                title: AppStrings.preferencesTitle,
                subtitle: AppStrings.preferencesSubtitle,
                subtitleGap: AppDimens.space24 + 2,
              ),
              const SizedBox(height: AppDimens.space48 + 11),
              _PreferenceTile(
                label: AppStrings.investingExperience,
                value: state.experience?.summary ?? AppStrings.notSet,
                onTap: () => context.push(AppRoutes.preferencesExperience),
              ),
              const SizedBox(height: AppDimens.space20),
              _PreferenceTile(
                label: AppStrings.yourFocus,
                value: state.intent?.summary ?? AppStrings.notSet,
                onTap: () => context.push(AppRoutes.preferencesIntent),
              ),
              const SizedBox(height: AppDimens.space20 + 2),
              const _PreferenceTile(
                label: AppStrings.appearance,
                value: AppStrings.appearanceDark,
                height: 91,
              ),
              const SizedBox(height: AppDimens.space40 + 4),
              Text(
                AppStrings.preferencesFootnote,
                style: KalpiTextStyles.helper,
              ),
              const SizedBox(height: AppDimens.space40),
              Text(
                AppStrings.demoSectionTitle,
                style: KalpiTextStyles.fieldLabel,
              ),
              const SizedBox(height: AppDimens.space12),
              SurfaceCard(
                radius: AppDimens.radiusControl,
                borderColor: null,
                padding: const EdgeInsets.fromLTRB(
                  AppDimens.space16,
                  AppDimens.space12,
                  AppDimens.space8,
                  AppDimens.space12,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            AppStrings.simulateFailureTitle,
                            style: KalpiTextStyles.listTitle,
                          ),
                          const SizedBox(height: AppDimens.space4),
                          Text(
                            AppStrings.simulateFailureBody,
                            style: KalpiTextStyles.cardSubtitle,
                          ),
                        ],
                      ),
                    ),
                    Switch.adaptive(
                      value: state.simulateSaveFailure,
                      onChanged: context
                          .read<PreferencesCubit>()
                          .setSimulateSaveFailure,
                      activeThumbColor: KalpiColors.onPrimary,
                      activeTrackColor: KalpiColors.primary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimens.space16),
              Text(AppStrings.demoDataNotice, style: KalpiTextStyles.caption),
              const SizedBox(height: AppDimens.space8),
              Text(AppConfig.versionLabel, style: KalpiTextStyles.captionSmall),
            ],
          ),
        );
      },
    );
  }
}

class _PreferenceTile extends StatelessWidget {
  const _PreferenceTile({
    required this.label,
    required this.value,
    this.onTap,
    this.height = 97,
  });

  final String label;
  final String value;
  final VoidCallback? onTap;
  final double height;

  @override
  Widget build(BuildContext context) => SurfaceCard(
    radius: AppDimens.radiusControl,
    borderColor: null,
    onTap: onTap,
    semanticLabel: onTap == null ? null : '$label: $value',
    child: ConstrainedBox(
      constraints: BoxConstraints(minHeight: height),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppDimens.space16,
          AppDimens.space16 + 1,
          AppDimens.space16,
          AppDimens.space16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(label, style: KalpiTextStyles.caption),
            const SizedBox(height: AppDimens.space12 + 1),
            Text(value, style: KalpiTextStyles.preferenceValue),
          ],
        ),
      ),
    ),
  );
}
