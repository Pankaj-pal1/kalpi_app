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
import '../../../../core/widgets/choice_card.dart';
import '../../../../core/widgets/count_pill.dart';
import '../../../../core/widgets/dropdown_field.dart';
import '../../../../core/widgets/info_banner.dart';
import '../../../../core/widgets/kalpi_button.dart';
import '../../../../core/widgets/kalpi_chip.dart';
import '../../../../core/widgets/kalpi_scaffold.dart';
import '../../../../core/widgets/kalpi_text_field.dart';
import '../../../../core/widgets/page_header.dart';
import '../../../strategies/domain/allocation_mode.dart';
import '../../../strategies/domain/stock_universe.dart';
import '../../../strategies/domain/strategy_narrator.dart';
import '../cubit/builder_cubit.dart';
import '../widgets/allocation_preview.dart';
import '../widgets/review_section_card.dart';
import '../widgets/rule_card.dart';
import '../widgets/rule_editor_sheet.dart';
import 'metric_picker_page.dart';

/// Shared callbacks the host page hands to each step.
class StepActions {
  const StepActions({required this.onPrimary, required this.onEditSection});

  /// Continue / Review changes.
  final VoidCallback onPrimary;

  /// From review: jump to a section.
  final ValueChanged<BuilderStep> onEditSection;
}

String _primaryLabel(BuilderState state, String continueLabel) =>
    state.returnToReview ? AppStrings.reviewChanges : continueLabel;

// ---------------------------------------------------------------------------
// 1 · Universe
// ---------------------------------------------------------------------------

class UniverseStep extends StatelessWidget {
  const UniverseStep({super.key, required this.state, required this.actions});

  final BuilderState state;
  final StepActions actions;

  Future<void> _pickCustom(BuildContext context) async {
    final symbols = await context.push<List<String>>(AppRoutes.customUniverse);
    if (symbols != null && symbols.isNotEmpty && context.mounted) {
      context.read<BuilderCubit>().setCustomSymbols(symbols);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BuilderCubit>();
    final universe = state.draft.universe;
    final custom = universe is CustomUniverse ? universe : null;
    return ScrollableWithFooter(
      footer: ActionFooter(
        child: KalpiButton(
          label: _primaryLabel(state, AppStrings.continueToFilters),
          icon: KalpiIcons.arrow,
          onPressed: actions.onPrimary,
        ),
      ),
      children: <Widget>[
        const SizedBox(height: AppDimens.space24 + 3),
        const PageHeader(
          title: AppStrings.universeTitle,
          subtitle: AppStrings.universeSubtitle,
        ),
        const SizedBox(height: AppDimens.space48 - 1),
        for (final index in MarketIndex.values) ...<Widget>[
          ChoiceCard(
            title: index.label,
            description: index.description,
            icon: KalpiIcons.grid,
            selected: universe is IndexUniverse && universe.index == index,
            onTap: () => cubit.setUniverse(IndexUniverse(index)),
          ),
          const SizedBox(height: AppDimens.space16),
        ],
        ChoiceCard(
          title: AppStrings.customUniverse,
          description: custom == null
              ? AppStrings.customUniverseDescription
              : AppStrings.customUniverseSelected(custom.symbols.length),
          icon: KalpiIcons.edit,
          selected: custom != null,
          onTap: () => _pickCustom(context),
        ),
        const SizedBox(height: AppDimens.space24),
        const InfoBanner(text: AppStrings.universeHint),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 2 · Filters
// ---------------------------------------------------------------------------

class FiltersStep extends StatelessWidget {
  const FiltersStep({super.key, required this.state, required this.actions});

  final BuilderState state;
  final StepActions actions;

  Future<void> _openEditor(BuildContext context, {String? ruleId}) async {
    final cubit = context.read<BuilderCubit>();
    final rules = cubit.state.draft.rules;
    final existing = ruleId == null
        ? null
        : rules.firstWhere((r) => r.id == ruleId);
    final result = await showRuleEditorSheet(
      context,
      existing: existing,
      newRuleId: existing == null ? cubit.newRuleId() : null,
      otherRules: rules.where((r) => r.id != ruleId).toList(),
    );
    if (!context.mounted || result == null) return;
    switch (result) {
      case RuleSaved(:final rule):
        cubit.upsertRule(rule);
      case RuleRemoved(:final ruleId):
        cubit.removeRule(ruleId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final rules = state.draft.rules;
    return ScrollableWithFooter(
      footer: ActionFooter(
        child: KalpiButton(
          label: _primaryLabel(state, AppStrings.continueToRanking),
          icon: KalpiIcons.arrow,
          onPressed: actions.onPrimary,
        ),
      ),
      children: <Widget>[
        const SizedBox(height: AppDimens.space24 + 3),
        const PageHeader(
          title: AppStrings.filtersTitle,
          subtitle: AppStrings.filtersSubtitle,
        ),
        const SizedBox(height: AppDimens.space32 + 4),
        Row(
          children: <Widget>[
            KalpiChip(
              label: state.draft.universe.summaryLabel,
              horizontalPadding: 27,
            ),
            const SizedBox(width: AppDimens.space16 + 1),
            Text(
              AppStrings.matchAllRules,
              style: KalpiTextStyles.fieldLabelSmall,
            ),
          ],
        ),
        const SizedBox(height: AppDimens.space24),
        for (var i = 0; i < rules.length; i++) ...<Widget>[
          if (i > 0) ...<Widget>[
            const SizedBox(height: AppDimens.space8 + 2),
            Padding(
              padding: const EdgeInsets.only(left: AppDimens.space16 + 2),
              child: Text(AppStrings.and, style: KalpiTextStyles.andLabel),
            ),
            const SizedBox(height: AppDimens.space16 + 1),
          ],
          RuleCard(
            rule: rules[i],
            onTap: () => _openEditor(context, ruleId: rules[i].id),
          ),
        ],
        if (rules.isNotEmpty) const SizedBox(height: AppDimens.space20),
        KalpiButton.secondary(
          label: rules.isEmpty
              ? AppStrings.addFirstRule
              : AppStrings.addAnotherRule,
          icon: KalpiIcons.plus,
          onPressed: () => _openEditor(context),
        ),
        const SizedBox(height: AppDimens.space20),
        InfoBanner(
          title: rules.isEmpty ? null : AppStrings.plainEnglishTitle,
          text: rules.isEmpty
              ? AppStrings.noRulesHint
              : StrategyNarrator.rulesSentence(rules),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 3 · Ranking
// ---------------------------------------------------------------------------

class RankingStep extends StatelessWidget {
  const RankingStep({super.key, required this.state, required this.actions});

  final BuilderState state;
  final StepActions actions;

  Future<void> _pickMetric(BuildContext context) async {
    final choice = await context.push<RankingChoice>(
      '${AppRoutes.metricPicker}?${AppRoutes.queryMode}=${AppRoutes.modeRanking}',
    );
    if (choice != null && context.mounted) {
      final cubit = context.read<BuilderCubit>();
      cubit.setRankingMetric(choice.metric);
      cubit.setRankingDirection(choice.direction);
    }
  }

  List<int> _options() {
    final max = state.draft.universe.stockCount;
    final options = AppConfig.holdingPresets.toList();
    final current = state.draft.ranking.count;
    if (!options.contains(current)) options.add(current);
    if (max > 0 && !options.contains(max) && options.every((o) => o > max)) {
      options.add(max);
    }
    options.sort();
    return options;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BuilderCubit>();
    final ranking = state.draft.ranking;
    final max = state.draft.universe.stockCount;
    final options = _options();
    return ScrollableWithFooter(
      footer: ActionFooter(
        child: KalpiButton(
          label: _primaryLabel(state, AppStrings.continueToAllocation),
          icon: KalpiIcons.arrow,
          onPressed: actions.onPrimary,
        ),
      ),
      children: <Widget>[
        const SizedBox(height: AppDimens.space24 + 3),
        const PageHeader(
          title: AppStrings.rankingTitle,
          subtitle: AppStrings.rankingSubtitle,
        ),
        const SizedBox(height: AppDimens.space40 - 2),
        Text(AppStrings.rankBy, style: KalpiTextStyles.fieldLabel),
        const SizedBox(height: AppDimens.space12),
        DropdownField(
          value: ranking.metric.label,
          subtitle: ranking.direction.label,
          height: 75,
          color: KalpiColors.surface,
          textStyle: KalpiTextStyles.cardTitle,
          leading: Icon(
            ranking.metric.icon,
            size: AppDimens.iconLarge,
            color: KalpiColors.accent,
          ),
          semanticLabel:
              '${AppStrings.rankBy} ${ranking.metric.label}, ${ranking.direction.label}',
          onTap: () => _pickMetric(context),
        ),
        const SizedBox(height: AppDimens.space32),
        Text(AppStrings.holdingsQuestion, style: KalpiTextStyles.cardTitle),
        const SizedBox(height: AppDimens.space20 - 1),
        Row(
          children: <Widget>[
            for (var i = 0; i < options.length; i++) ...<Widget>[
              if (i > 0) const SizedBox(width: AppDimens.space12),
              Expanded(
                child: CountPill(
                  label: '${options[i]}',
                  selected: ranking.count == options[i],
                  enabled: max == 0 || options[i] <= max,
                  onTap: () => cubit.setRankingCount(options[i]),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: AppDimens.space24 - 1),
        Text(
          AppStrings.holdingsHint(ranking.count),
          style: KalpiTextStyles.helper,
        ),
        const SizedBox(height: AppDimens.space40 - 2),
        InfoBanner(
          title: AppStrings.logicSoFarTitle,
          text: StrategyNarrator.logicSoFar(state.draft),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 4 · Allocation
// ---------------------------------------------------------------------------

class AllocationStep extends StatelessWidget {
  const AllocationStep({super.key, required this.state, required this.actions});

  final BuilderState state;
  final StepActions actions;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BuilderCubit>();
    final draft = state.draft;
    final holdings = draft.effectiveHoldings;
    return ScrollableWithFooter(
      footer: ActionFooter(
        child: KalpiButton(
          label: _primaryLabel(state, AppStrings.reviewMyStrategy),
          icon: KalpiIcons.arrow,
          onPressed: actions.onPrimary,
        ),
      ),
      children: <Widget>[
        const SizedBox(height: AppDimens.space24 + 3),
        const PageHeader(
          title: AppStrings.allocationTitle,
          subtitle: AppStrings.allocationSubtitle,
        ),
        const SizedBox(height: AppDimens.space48 - 1),
        ChoiceCard(
          title: AllocationMode.equal.label,
          description: AppStrings.equalWeightDescription(holdings),
          icon: KalpiIcons.grid,
          selected: draft.allocation == AllocationMode.equal,
          onTap: () => cubit.setAllocation(AllocationMode.equal),
        ),
        const SizedBox(height: AppDimens.space16),
        ChoiceCard(
          title: AllocationMode.marketCap.label,
          description: AppStrings.marketCapDescription,
          icon: KalpiIcons.chart,
          selected: draft.allocation == AllocationMode.marketCap,
          onTap: () => cubit.setAllocation(AllocationMode.marketCap),
        ),
        const SizedBox(height: AppDimens.space24 + 2),
        AllocationPreview(holdings: holdings, mode: draft.allocation),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 5 · Review
// ---------------------------------------------------------------------------

class ReviewStep extends StatefulWidget {
  const ReviewStep({super.key, required this.state, required this.actions});

  final BuilderState state;
  final StepActions actions;

  @override
  State<ReviewStep> createState() => _ReviewStepState();
}

class _ReviewStepState extends State<ReviewStep> {
  late final TextEditingController _name;
  final FocusNode _nameFocus = FocusNode();
  int _seenAttempt = 0;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.state.draft.name);
    _seenAttempt = widget.state.saveAttempt;
  }

  @override
  void didUpdateWidget(covariant ReviewStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    final s = widget.state;
    if (s.draft.name != _name.text) {
      _name.value = TextEditingValue(
        text: s.draft.name,
        selection: TextSelection.collapsed(offset: s.draft.name.length),
      );
    }
    // Focus the name field when a save attempt was rejected for its name.
    if (s.saveAttempt != _seenAttempt) {
      _seenAttempt = s.saveAttempt;
      if (s.nameError != null) _nameFocus.requestFocus();
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _nameFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final cubit = context.read<BuilderCubit>();
    final isEdit = state.isEdit;
    final saving = state.isSaving;
    return ScrollableWithFooter(
      footer: ActionFooter(
        child: KalpiButton(
          label: isEdit ? AppStrings.saveChanges : AppStrings.saveStrategy,
          busyLabel: isEdit
              ? AppStrings.savingChanges
              : AppStrings.savingStrategy,
          busy: saving,
          icon: KalpiIcons.check,
          onPressed: cubit.save,
        ),
      ),
      children: <Widget>[
        const SizedBox(height: AppDimens.space24 - 1),
        PageHeader(
          title: isEdit ? AppStrings.editReviewTitle : AppStrings.reviewTitle,
          subtitle: isEdit
              ? AppStrings.editReviewSubtitle
              : AppStrings.reviewSubtitle,
        ),
        const SizedBox(height: AppDimens.space40 + 1),
        KalpiTextField(
          controller: _name,
          focusNode: _nameFocus,
          label: state.nameError == null
              ? AppStrings.strategyNameLabel
              : AppStrings.strategyNameRequiredLabel,
          hint: AppStrings.strategyNameHint,
          errorText: state.nameError,
          maxLength: AppConfig.nameMaxLength,
          textInputAction: TextInputAction.done,
          onChanged: cubit.setName,
        ),
        const SizedBox(height: AppDimens.space20 + 2),
        ReviewSectionCard(
          draft: state.draft,
          onEdit: saving ? (_) {} : widget.actions.onEditSection,
        ),
        if (state.validationError != null) ...<Widget>[
          const SizedBox(height: AppDimens.space12),
          Semantics(
            liveRegion: true,
            child: Text(
              state.validationError!,
              style: KalpiTextStyles.fieldErrorRegular,
            ),
          ),
        ],
        const SizedBox(height: AppDimens.space20 + 2),
        Text(
          saving ? AppStrings.savingFootnote : AppStrings.reviewFootnote,
          style: KalpiTextStyles.helper,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Save recovery
// ---------------------------------------------------------------------------

class SaveRecoveryView extends StatelessWidget {
  const SaveRecoveryView({super.key, required this.state});

  final BuilderState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BuilderCubit>();
    final draft = state.draft;
    return ScrollableWithFooter(
      footer: ActionFooter(
        child: Column(
          children: <Widget>[
            KalpiButton.secondary(
              label: AppStrings.backToReview,
              icon: KalpiIcons.back,
              onPressed: cubit.dismissSaveError,
            ),
            const SizedBox(height: AppDimens.space16),
            KalpiButton(
              label: AppStrings.trySavingAgain,
              icon: KalpiIcons.check,
              busy: state.isSaving,
              busyLabel: state.isEdit
                  ? AppStrings.savingChanges
                  : AppStrings.savingStrategy,
              onPressed: cubit.save,
            ),
          ],
        ),
      ),
      children: <Widget>[
        const SizedBox(height: AppDimens.space40 + 5),
        const PageHeader(
          title: AppStrings.saveErrorTitle,
          subtitle: AppStrings.saveErrorSubtitle,
        ),
        const SizedBox(height: AppDimens.space48 + 18),
        Container(
          padding: const EdgeInsets.fromLTRB(
            AppDimens.space16 + 2,
            AppDimens.space24 + 1,
            AppDimens.space16 + 2,
            AppDimens.space16 + 1,
          ),
          decoration: BoxDecoration(
            color: KalpiColors.surface,
            borderRadius: BorderRadius.circular(AppDimens.radiusCard),
            border: Border.all(color: KalpiColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(left: 2),
                child: Icon(
                  KalpiIcons.info,
                  size: AppDimens.iconXLarge,
                  color: KalpiColors.dangerText,
                ),
              ),
              const SizedBox(height: AppDimens.space24 - 1),
              Text(
                state.saveError ?? AppStrings.saveErrorCardTitle,
                style: KalpiTextStyles.errorTitle,
              ),
              const SizedBox(height: AppDimens.space20 + 1),
              Text(
                AppStrings.saveErrorCardBody,
                style: KalpiTextStyles.subtitle,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimens.space32 + 4),
        InfoBanner(
          title: draft.trimmedName,
          text: StrategyNarrator.compactSummary(draft),
        ),
      ],
    );
  }
}
