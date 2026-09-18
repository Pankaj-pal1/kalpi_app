import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/kalpi_colors.dart';
import '../../../../core/theme/kalpi_icons.dart';
import '../../../../core/theme/kalpi_typography.dart';
import '../../../../core/widgets/surface_card.dart';
import '../../../strategies/domain/strategy_draft.dart';
import '../cubit/builder_cubit.dart';

/// Numbered summary of the four builder sections, each tappable to edit.
class ReviewSectionCard extends StatelessWidget {
  const ReviewSectionCard({
    super.key,
    required this.draft,
    required this.onEdit,
  });

  final StrategyDraft draft;
  final ValueChanged<BuilderStep> onEdit;

  @override
  Widget build(BuildContext context) {
    final rules = draft.rules;
    final filtersValue = rules.isEmpty
        ? AppStrings.noFilters
        : rules.map((r) => r.shortSummary).join(' · ');
    return SurfaceCard(
      radius: AppDimens.radiusCard,
      padding: const EdgeInsets.fromLTRB(
        0,
        AppDimens.space16 + 1,
        0,
        AppDimens.space16 - 1,
      ),
      child: Column(
        children: <Widget>[
          _Row(
            number: 1,
            label: AppStrings.sectionStocks,
            value: draft.universe.summaryLabel,
            onTap: () => onEdit(BuilderStep.universe),
          ),
          _Row(
            number: 2,
            label: AppStrings.sectionFilters,
            value: filtersValue,
            onTap: () => onEdit(BuilderStep.filters),
          ),
          _Row(
            number: 3,
            label: AppStrings.sectionRanking,
            value: draft.ranking.summary,
            onTap: () => onEdit(BuilderStep.ranking),
          ),
          _Row(
            number: 4,
            label: AppStrings.sectionAllocation,
            value: draft.allocation.label,
            onTap: () => onEdit(BuilderStep.allocation),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.number,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final int number;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: 'Edit $label: $value',
    child: InkWell(
      onTap: onTap,
      splashFactory: NoSplash.splashFactory,
      highlightColor: KalpiColors.surfaceSelected.withValues(alpha: 0.6),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 59),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimens.space16,
            AppDimens.space8,
            AppDimens.space20 + 1,
            AppDimens.space8,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: AppDimens.stepBadgeSize,
                height: AppDimens.stepBadgeSize,
                decoration: BoxDecoration(
                  color: KalpiColors.surfaceSelected,
                  borderRadius: BorderRadius.circular(
                    AppDimens.stepBadgeRadius,
                  ),
                ),
                alignment: Alignment.center,
                child: Text('$number', style: KalpiTextStyles.stepBadge),
              ),
              const SizedBox(width: AppDimens.space12 + 1),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(label, style: KalpiTextStyles.summaryLabel),
                    const SizedBox(height: 5),
                    Text(value, style: KalpiTextStyles.summaryValue),
                  ],
                ),
              ),
              const SizedBox(width: AppDimens.space12),
              const Icon(
                KalpiIcons.chevron,
                size: 13,
                color: KalpiColors.accent,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
