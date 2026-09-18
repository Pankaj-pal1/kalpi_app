import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/kalpi_colors.dart';
import '../../../../core/theme/kalpi_icons.dart';
import '../../../../core/theme/kalpi_typography.dart';
import '../../../../core/widgets/kalpi_button.dart';
import '../../../../core/widgets/kalpi_icon_button.dart';
import '../../../../core/widgets/kalpi_scaffold.dart';
import '../../../../core/widgets/kalpi_top_bar.dart';
import '../../../../core/widgets/list_tile_row.dart';
import '../../../../core/widgets/page_header.dart';
import '../../../../core/widgets/surface_card.dart';
import '../../../builder/presentation/builder_launcher.dart';
import '../../domain/strategy.dart';
import '../../domain/strategy_narrator.dart';
import '../cubit/strategy_list_cubit.dart';
import '../widgets/delete_strategy_sheet.dart';
import '../widgets/strategy_sheets.dart';

/// Read-only view of one saved strategy.
class StrategyDetailPage extends StatelessWidget {
  const StrategyDetailPage({super.key, required this.strategyId});

  final String strategyId;

  Future<void> _showActions(BuildContext context, Strategy strategy) async {
    final action = await showStrategyActionsSheet(context, strategy);
    if (!context.mounted || action == null) return;
    switch (action) {
      case StrategyAction.edit:
        BuilderLauncher.startEdit(context, strategy);
      case StrategyAction.duplicate:
        context.push(AppRoutes.strategyDuplicate(strategy.id));
      case StrategyAction.delete:
        final deleted = await showDeleteStrategySheet(context, strategy);
        if (deleted && context.mounted) context.go(AppRoutes.strategies);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StrategyListCubit, StrategyListState>(
      builder: (context, state) {
        final strategy = state.byId(strategyId);
        if (strategy == null) return const _NotFound();
        final draft = strategy.toDraft();
        return KalpiScaffold(
          body: Column(
            children: <Widget>[
              KalpiTopBar(
                title: AppStrings.myStrategies,
                onBack: () => context.pop(),
                trailing: KalpiIconButton(
                  icon: KalpiIcons.more,
                  semanticLabel: AppStrings.moreActions,
                  size: AppDimens.iconDefault,
                  hitSize: 48,
                  onPressed: () => _showActions(context, strategy),
                ),
              ),
              Expanded(
                child: ScrollableWithFooter(
                  footer: ActionFooter(
                    child: KalpiButton(
                      label: AppStrings.editStrategy,
                      icon: KalpiIcons.edit,
                      onPressed: () =>
                          BuilderLauncher.startEdit(context, strategy),
                    ),
                  ),
                  children: <Widget>[
                    const SizedBox(height: AppDimens.space24 + 2),
                    const EyebrowPill(label: AppStrings.savedStrategyEyebrow),
                    const SizedBox(height: AppDimens.space20),
                    Semantics(
                      header: true,
                      child: Text(
                        strategy.name,
                        style: KalpiTextStyles.pageTitleLarge,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      StrategyNarrator.description(draft),
                      style: KalpiTextStyles.subtitle,
                    ),
                    const SizedBox(height: AppDimens.space32 + 6),
                    _StatTiles(strategy: strategy),
                    const SizedBox(height: AppDimens.space32 - 1),
                    Text(
                      AppStrings.rulesBehindIt,
                      style: KalpiTextStyles.sectionHeading,
                    ),
                    const SizedBox(height: AppDimens.space16 - 1),
                    SurfaceCard(
                      radius: AppDimens.radiusChoice,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.space16,
                      ),
                      child: Column(
                        children: <Widget>[
                          KeyValueRow(
                            label: AppStrings.stockUniverseKey,
                            value: strategy.universe.summaryLabel,
                          ),
                          const HairlineDivider(),
                          KeyValueRow(
                            label: AppStrings.mustMatchAllKey,
                            value: strategy.rules.isEmpty
                                ? AppStrings.noFilters
                                : strategy.rules.first.shortSummary,
                            secondaryValues: strategy.rules
                                .skip(1)
                                .map((r) => r.title)
                                .toList(),
                          ),
                          const HairlineDivider(),
                          KeyValueRow(
                            label: AppStrings.allocationKey,
                            value: strategy.allocation.label,
                          ),
                          const HairlineDivider(),
                          KeyValueRow(
                            label: AppStrings.rankingKey,
                            value: strategy.ranking.detailSummary,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimens.space20),
                    Text(
                      AppStrings.detailFootnote,
                      style: KalpiTextStyles.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatTiles extends StatelessWidget {
  const _StatTiles({required this.strategy});

  final Strategy strategy;

  @override
  Widget build(BuildContext context) => Container(
    height: 74,
    padding: const EdgeInsets.fromLTRB(
      AppDimens.space16,
      AppDimens.space12 + 2,
      AppDimens.space16,
      0,
    ),
    decoration: BoxDecoration(
      color: KalpiColors.surfaceSelected,
      borderRadius: BorderRadius.circular(AppDimens.radiusChoice),
    ),
    child: Row(
      children: <Widget>[
        _Stat(
          value: '${strategy.universe.stockCount}',
          label: AppStrings.startingStocks,
        ),
        _Stat(value: '${strategy.rules.length}', label: AppStrings.filtersStat),
        _Stat(
          value: '${strategy.ranking.count}',
          label: AppStrings.targetHoldings,
        ),
      ],
    ),
  );
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(value, style: KalpiTextStyles.statValue),
        const SizedBox(height: 1),
        Text(
          label,
          style: KalpiTextStyles.statLabel,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );
}

class _NotFound extends StatelessWidget {
  const _NotFound();

  @override
  Widget build(BuildContext context) => KalpiScaffold(
    body: Column(
      children: <Widget>[
        KalpiTopBar(
          title: AppStrings.myStrategies,
          onBack: () => context.go(AppRoutes.strategies),
        ),
        Expanded(
          child: ScrollableWithFooter(
            footer: ActionFooter(
              child: KalpiButton(
                label: AppStrings.backToMyStrategies,
                icon: KalpiIcons.check,
                onPressed: () => context.go(AppRoutes.strategies),
              ),
            ),
            children: <Widget>[
              const SizedBox(height: AppDimens.space40),
              Text(
                AppStrings.strategyNotFoundTitle,
                style: KalpiTextStyles.pageTitle,
              ),
              const SizedBox(height: AppDimens.space12),
              Text(
                AppStrings.strategyNotFoundBody,
                style: KalpiTextStyles.subtitle,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
