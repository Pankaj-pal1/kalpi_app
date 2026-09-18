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
import '../../domain/investing_intent.dart';
import '../cubit/preferences_cubit.dart';
import 'preference_page_mode.dart';

/// Onboarding step 3 / Preferences · investing intent.
class IntentPage extends StatefulWidget {
  const IntentPage({super.key, required this.mode});

  final PreferencePageMode mode;

  @override
  State<IntentPage> createState() => _IntentPageState();
}

class _IntentPageState extends State<IntentPage> {
  InvestingIntent? _selected;

  bool get _isOnboarding => widget.mode == PreferencePageMode.onboarding;

  @override
  void initState() {
    super.initState();
    _selected =
        context.read<PreferencesCubit>().state.intent ??
        (_isOnboarding ? InvestingIntent.build : null);
  }

  Future<void> _continue() async {
    final cubit = context.read<PreferencesCubit>();
    final intent = _selected;
    if (intent != null) await cubit.setIntent(intent);
    if (_isOnboarding) await cubit.completeOnboarding();
    if (!mounted) return;
    if (!_isOnboarding) {
      context.pop();
      return;
    }
    if (intent == InvestingIntent.learn) {
      context.go(AppRoutes.learn);
    } else {
      context.go(AppRoutes.strategies);
    }
  }

  Future<void> _skip() async {
    await context.read<PreferencesCubit>().skipOnboarding();
    if (mounted) context.go(AppRoutes.strategies);
  }

  void _back() {
    if (_isOnboarding) {
      context.go(AppRoutes.experience);
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ctaLabel = !_isOnboarding
        ? AppStrings.savePreference
        : (_selected == InvestingIntent.learn
              ? AppStrings.intentCtaLearn
              : AppStrings.intentCta);
    return KalpiScaffold(
      body: Column(
        children: <Widget>[
          KalpiTopBar(
            title: AppStrings.intentTopBar,
            onBack: _back,
            trailing: _isOnboarding
                ? TopBarTextAction(label: AppStrings.skip, onPressed: _skip)
                : null,
          ),
          Expanded(
            child: ScrollableWithFooter(
              footer: ActionFooter(
                child: KalpiButton(
                  label: ctaLabel,
                  icon: KalpiIcons.arrow,
                  enabled: _selected != null,
                  onPressed: _continue,
                ),
              ),
              children: <Widget>[
                const SizedBox(height: AppDimens.space40 + 1),
                const PageHeader(
                  title: AppStrings.intentTitle,
                  subtitle: AppStrings.intentSubtitle,
                ),
                const SizedBox(height: AppDimens.space48 + 15),
                for (final intent in InvestingIntent.values) ...<Widget>[
                  ChoiceCard(
                    title: intent.title,
                    description: intent.description,
                    icon: intent.icon,
                    selected: _selected == intent,
                    minHeight: 100,
                    onTap: () => setState(() => _selected = intent),
                  ),
                  if (intent != InvestingIntent.values.last)
                    const SizedBox(height: AppDimens.space16),
                ],
                const SizedBox(height: AppDimens.space24 + 4),
                Text(AppStrings.intentFootnote, style: KalpiTextStyles.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
