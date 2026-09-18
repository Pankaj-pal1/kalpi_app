import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../strategies/domain/strategy.dart';
import '../../strategies/domain/strategy_draft.dart';
import '../../strategies/presentation/cubit/strategy_list_cubit.dart';
import 'cubit/builder_cubit.dart';

/// Entry points into the builder so every caller seeds the draft the same way.
abstract final class BuilderLauncher {
  /// Starts a new strategy. The very first strategy (and the guide's
  /// "Try building it") is prefilled with the illustrative example; later
  /// strategies start from a blank name with no rules.
  static void startCreate(BuildContext context, {bool useExample = false}) {
    final hasStrategies = context
        .read<StrategyListCubit>()
        .state
        .strategies
        .isNotEmpty;
    final seed = (useExample || !hasStrategies)
        ? StrategyDraft.illustrative()
        : StrategyDraft.blank();
    context.read<BuilderCubit>().startCreate(seed: seed);
    context.go(AppRoutes.builderStep(BuilderStep.universe.path));
  }

  /// Opens the edit flow for [strategy] at the filters step.
  static void startEdit(
    BuildContext context,
    Strategy strategy, {
    bool isCopy = false,
    BuilderStep step = BuilderStep.filters,
  }) {
    context.read<BuilderCubit>().startEdit(strategy, isCopy: isCopy);
    context.push(AppRoutes.strategyEdit(strategy.id, step.path));
  }
}
