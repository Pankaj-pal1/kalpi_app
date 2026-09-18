import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/kalpi_icons.dart';
import '../../../../core/theme/kalpi_typography.dart';
import '../../../../core/widgets/choice_card.dart';
import '../../../../core/widgets/kalpi_button.dart';
import '../../../../core/widgets/kalpi_scaffold.dart';
import '../../../../core/widgets/kalpi_top_bar.dart';
import '../../../../core/widgets/page_header.dart';
import '../../domain/experience_level.dart';
import '../cubit/preferences_cubit.dart';
import 'preference_page_mode.dart';

export 'preference_page_mode.dart';

/// Onboarding step 2 / Preferences · investing experience.
class ExperiencePage extends StatefulWidget {
  const ExperiencePage({super.key, required this.mode});

  final PreferencePageMode mode;

  @override
  State<ExperiencePage> createState() => _ExperiencePageState();
}

class _ExperiencePageState extends State<ExperiencePage> {
  ExperienceLevel? _selected;

  bool get _isOnboarding => widget.mode == PreferencePageMode.onboarding;

  @override
  void initState() {
    super.initState();
    _selected =
        context.read<PreferencesCubit>().state.experience ??
        (_isOnboarding ? ExperienceLevel.gettingStarted : null);
  }

  Future<void> _continue() async {
    final cubit = context.read<PreferencesCubit>();
    final level = _selected;
    if (level != null) await cubit.setExperience(level);
    if (!mounted) return;
    if (_isOnboarding) {
      context.go(AppRoutes.intent);
    } else {
      context.pop();
    }
  }

  Future<void> _skip() async {
    await context.read<PreferencesCubit>().skipOnboarding();
    if (mounted) context.go(AppRoutes.strategies);
  }

  void _back() {
    if (_isOnboarding) {
      context.go(AppRoutes.welcome);
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return KalpiScaffold(
      body: Column(
        children: <Widget>[
          KalpiTopBar(
            title: AppStrings.experienceTopBar,
            onBack: _back,
            trailing: _isOnboarding
                ? TopBarTextAction(label: AppStrings.skip, onPressed: _skip)
                : null,
          ),
          Expanded(
            child: ScrollableWithFooter(
              footer: ActionFooter(
                child: Column(
                  children: <Widget>[
                    Text(
                      AppStrings.changeLaterHint,
                      style: KalpiTextStyles.caption,
                    ),
                    const SizedBox(height: AppDimens.space16 + 1),
                    KalpiButton(
                      label: _isOnboarding
                          ? AppStrings.continueLabel
                          : AppStrings.savePreference,
                      icon: KalpiIcons.arrow,
                      enabled: _selected != null,
                      onPressed: _continue,
                    ),
                  ],
                ),
              ),
              children: <Widget>[
                const SizedBox(height: AppDimens.space20 + 1),
                const PageHeader(
                  eyebrow: AppStrings.personaliseEyebrow,
                  title: AppStrings.experienceTitle,
                  subtitle: AppStrings.experienceSubtitle,
                ),
                const SizedBox(height: AppDimens.space48 + 14),
                for (final level in ExperienceLevel.values) ...<Widget>[
                  ChoiceCard(
                    title: level.title,
                    description: level.description,
                    icon: level.icon,
                    selected: _selected == level,
                    minHeight: 100,
                    onTap: () => setState(() => _selected = level),
                  ),
                  if (level != ExperienceLevel.values.last)
                    const SizedBox(height: AppDimens.space16),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
