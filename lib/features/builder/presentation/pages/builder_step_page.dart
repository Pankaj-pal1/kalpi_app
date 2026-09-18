import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/kalpi_typography.dart';
import '../../../../core/widgets/kalpi_scaffold.dart';
import '../../../../core/widgets/kalpi_top_bar.dart';
import '../../../../core/widgets/step_progress.dart';
import '../../../strategies/domain/strategy_draft.dart';
import '../../../strategies/presentation/cubit/strategy_list_cubit.dart';
import '../../../strategies/presentation/widgets/strategy_sheets.dart';
import '../cubit/builder_cubit.dart';
import 'builder_steps.dart';

/// Hosts one builder step. The draft lives in [BuilderCubit] above the
/// route, so moving between steps never loses input.
class BuilderStepPage extends StatefulWidget {
  const BuilderStepPage({super.key, required this.step, this.editingId});

  final BuilderStep step;

  /// Present for `/strategies/:id/edit/:step` routes.
  final String? editingId;

  @override
  State<BuilderStepPage> createState() => _BuilderStepPageState();
}

class _BuilderStepPageState extends State<BuilderStepPage> {
  bool _redirecting = false;

  @override
  void initState() {
    super.initState();
    _ensureSession();
  }

  /// Recovers from deep links or restarts that land here without a session.
  void _ensureSession() {
    final builder = context.read<BuilderCubit>();
    final state = builder.state;
    final editingId = widget.editingId;
    if (editingId != null) {
      if (state.isActive && state.isEdit && state.editingId == editingId) {
        return;
      }
      final strategy = context.read<StrategyListCubit>().state.byId(editingId);
      if (strategy != null) {
        builder.startEdit(strategy);
      } else {
        _redirecting = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            context.go(AppRoutes.strategies);
          }
        });
      }
      return;
    }
    if (!state.isActive || state.isEdit) {
      final hasStrategies = context
          .read<StrategyListCubit>()
          .state
          .strategies
          .isNotEmpty;
      builder.startCreate(
        seed: hasStrategies
            ? StrategyDraft.blank()
            : StrategyDraft.illustrative(),
      );
    }
  }

  String _pathFor(BuilderStep step) {
    final id = widget.editingId;
    return id == null
        ? AppRoutes.builderStep(step.path)
        : AppRoutes.strategyEdit(id, step.path);
  }

  void _goTo(BuilderStep step) => context.go(_pathFor(step));

  Future<void> _leave() async {
    final builder = context.read<BuilderCubit>();
    if (builder.state.shouldConfirmExit) {
      final discard = await showExitConfirmationSheet(context);
      if (!discard || !mounted) return;
    }
    final editingId = widget.editingId;
    builder.reset();
    if (!mounted) return;
    if (editingId != null) {
      context.go(AppRoutes.strategyDetail(editingId));
    } else {
      context.go(AppRoutes.strategies);
    }
  }

  void _onBack() {
    final state = context.read<BuilderCubit>().state;
    final step = widget.step;
    if (step == BuilderStep.review) {
      if (state.isEdit) {
        _leave();
      } else {
        _goTo(BuilderStep.allocation);
      }
      return;
    }
    if (state.returnToReview) {
      _goTo(BuilderStep.review);
      return;
    }
    final previous = step.previous;
    if (previous == null) {
      _leave();
    } else {
      _goTo(previous);
    }
  }

  void _onPrimary() {
    final state = context.read<BuilderCubit>().state;
    if (state.returnToReview) {
      _goTo(BuilderStep.review);
      return;
    }
    final next = widget.step.next;
    if (next != null) {
      _goTo(next);
    }
  }

  void _onEditSection(BuilderStep step) {
    context.read<BuilderCubit>().setReturnToReview(true);
    _goTo(step);
  }

  void _onSaved(BuildContext context, BuilderState state) {
    final saved = state.savedStrategy!;
    context.read<StrategyListCubit>().onStrategySaved(
      saved,
      wasEdit: state.isEdit,
    );
    context.read<BuilderCubit>().reset();
    context.go(AppRoutes.strategies);
  }

  @override
  Widget build(BuildContext context) {
    if (_redirecting) return const KalpiScaffold(body: SizedBox.shrink());
    return BlocConsumer<BuilderCubit, BuilderState>(
      listenWhen: (previous, current) =>
          previous.saveStatus != current.saveStatus &&
          current.saveStatus == SaveStatus.success,
      listener: _onSaved,
      builder: (context, state) {
        if (!state.isActive) {
          return const KalpiScaffold(body: SizedBox.shrink());
        }
        final step = widget.step;
        final showRecovery =
            step == BuilderStep.review &&
            state.saveStatus == SaveStatus.failure;
        final actions = StepActions(
          onPrimary: _onPrimary,
          onEditSection: _onEditSection,
        );
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) {
              _onBack();
            }
          },
          child: KalpiScaffold(
            body: Column(
              children: <Widget>[
                KalpiTopBar(
                  title: _title(state, step, showRecovery),
                  onBack: showRecovery
                      ? context.read<BuilderCubit>().dismissSaveError
                      : _onBack,
                  trailing: _trailing(state, step),
                ),
                if (step.number != null) ...<Widget>[
                  const SizedBox(height: AppDimens.space12 - 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.gutter,
                    ),
                    child: StepProgress(current: step.number!),
                  ),
                ],
                Expanded(child: _body(state, step, showRecovery, actions)),
              ],
            ),
          ),
        );
      },
    );
  }

  String _title(BuilderState state, BuilderStep step, bool showRecovery) {
    if (state.isEdit) {
      return state.isCopy
          ? AppStrings.editCopyTopBar
          : AppStrings.editStepTitle(state.editingName);
    }
    if (step == BuilderStep.review || showRecovery) {
      return AppStrings.reviewTopBar;
    }
    return AppStrings.buildStepTitle(step.number!, BuilderStep.numberedCount);
  }

  Widget? _trailing(BuilderState state, BuilderStep step) {
    if (state.isEdit) {
      final n = step.number;
      if (n == null) return null;
      return Padding(
        padding: const EdgeInsets.only(right: AppDimens.space8),
        child: Text(
          AppStrings.stepCounter(n, BuilderStep.numberedCount),
          style: KalpiTextStyles.topBarExit,
        ),
      );
    }
    if (state.saveStatus == SaveStatus.failure) return null;
    return TopBarTextAction(
      label: AppStrings.exit,
      minWidth: 74,
      style: KalpiTextStyles.topBarExit,
      onPressed: _leave,
    );
  }

  Widget _body(
    BuilderState state,
    BuilderStep step,
    bool showRecovery,
    StepActions actions,
  ) {
    if (showRecovery) return SaveRecoveryView(state: state);
    return switch (step) {
      BuilderStep.universe => UniverseStep(state: state, actions: actions),
      BuilderStep.filters => FiltersStep(state: state, actions: actions),
      BuilderStep.ranking => RankingStep(state: state, actions: actions),
      BuilderStep.allocation => AllocationStep(state: state, actions: actions),
      BuilderStep.review => ReviewStep(state: state, actions: actions),
    };
  }
}
