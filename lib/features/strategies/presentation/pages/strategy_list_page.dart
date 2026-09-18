import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/kalpi_colors.dart';
import '../../../../core/theme/kalpi_icons.dart';
import '../../../../core/theme/kalpi_typography.dart';
import '../../../../core/widgets/info_banner.dart';
import '../../../../core/widgets/kalpi_bottom_nav.dart';
import '../../../../core/widgets/kalpi_button.dart';
import '../../../../core/widgets/kalpi_chip.dart';
import '../../../../core/widgets/kalpi_icon_button.dart';
import '../../../../core/widgets/kalpi_scaffold.dart';
import '../../../../core/widgets/kalpi_search_field.dart';
import '../../../builder/presentation/builder_launcher.dart';
import '../../domain/strategy.dart';
import '../cubit/strategy_list_cubit.dart';
import '../widgets/delete_strategy_sheet.dart';
import '../widgets/empty_state_card.dart';
import '../widgets/strategy_card.dart';
import '../widgets/strategy_sheets.dart';

/// My strategies — owns the empty, list, search and feedback states.
class StrategyListPage extends StatefulWidget {
  const StrategyListPage({super.key});

  @override
  State<StrategyListPage> createState() => _StrategyListPageState();
}

class _StrategyListPageState extends State<StrategyListPage> {
  late final TextEditingController _search;
  final FocusNode _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _search = TextEditingController(
      text: context.read<StrategyListCubit>().state.query,
    );
  }

  @override
  void dispose() {
    _search.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _onTab(KalpiTab tab) {
    switch (tab) {
      case KalpiTab.strategies:
        break;
      case KalpiTab.build:
        BuilderLauncher.startCreate(context);
      case KalpiTab.learn:
        context.push(AppRoutes.learn);
    }
  }

  void _clearSearch() {
    _search.clear();
    context.read<StrategyListCubit>().clearSearch();
    _searchFocus.requestFocus();
  }

  Future<void> _showActions(Strategy strategy) async {
    final action = await showStrategyActionsSheet(context, strategy);
    if (!mounted || action == null) return;
    switch (action) {
      case StrategyAction.edit:
        BuilderLauncher.startEdit(context, strategy);
      case StrategyAction.duplicate:
        context.push(AppRoutes.strategyDuplicate(strategy.id));
      case StrategyAction.delete:
        await showDeleteStrategySheet(context, strategy);
    }
  }

  @override
  Widget build(BuildContext context) {
    return KalpiScaffold(
      bottomNavigationBar: KalpiBottomNav(
        current: KalpiTab.strategies,
        onSelect: _onTab,
      ),
      body: BlocBuilder<StrategyListCubit, StrategyListState>(
        builder: (context, state) {
          return ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(scrollbars: false),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppDimens.gutter,
                AppDimens.space20,
                AppDimens.gutter,
                AppDimens.space24,
              ),
              children: <Widget>[
                _Header(onProfile: () => context.push(AppRoutes.preferences)),
                if (state.isLoading)
                  const _LoadingBlock()
                else if (state.status == StrategyListStatus.failure)
                  _LoadFailed(
                    onRetry: () => context.read<StrategyListCubit>().load(),
                  )
                else if (state.isEmpty)
                  ..._emptyChildren(context, state)
                else
                  ..._listChildren(context, state),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _emptyChildren(BuildContext context, StrategyListState state) =>
      <Widget>[
        if (state.banner != null) ...<Widget>[
          const SizedBox(height: AppDimens.space8),
          StatusBanner(message: state.banner!.message),
          const SizedBox(height: AppDimens.space12),
        ] else
          const SizedBox(height: AppDimens.space32 + 4),
        EmptyStateCard(onBuild: () => BuilderLauncher.startCreate(context)),
        const SizedBox(height: AppDimens.space24),
        LearnPromoCard(onTap: () => context.push(AppRoutes.learn)),
      ];

  List<Widget> _listChildren(BuildContext context, StrategyListState state) {
    final cubit = context.read<StrategyListCubit>();
    final visible = state.filtered;
    return <Widget>[
      const SizedBox(height: AppDimens.space16 + 2),
      SizedBox(
        height: 49,
        child: state.banner != null
            ? StatusBanner(message: state.banner!.message)
            : Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppStrings.strategyCountSummary(state.strategies.length),
                  style: KalpiTextStyles.body(
                    13,
                    weight: FontWeight.w600,
                    color: KalpiColors.textSecondary,
                  ),
                ),
              ),
      ),
      const SizedBox(height: AppDimens.space24 + 2),
      KalpiSearchField(
        controller: _search,
        focusNode: _searchFocus,
        hint: AppStrings.searchStrategiesHint,
        onChanged: cubit.search,
        onClear: () => _searchFocus.requestFocus(),
      ),
      if (state.hasNoResults) ...<Widget>[
        const SizedBox(height: AppDimens.space40 * 2 - 1),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                AppStrings.noMatchingTitle,
                style: KalpiTextStyles.statValue,
              ),
              const SizedBox(height: AppDimens.space32 - 2),
              Text(AppStrings.noMatchingBody, style: KalpiTextStyles.subtitle),
            ],
          ),
        ),
        const SizedBox(height: AppDimens.space40 + 4),
        KalpiButton(
          label: AppStrings.clearSearch,
          icon: KalpiIcons.check,
          onPressed: _clearSearch,
        ),
        const SizedBox(height: AppDimens.space48 * 2 + 11),
      ] else ...<Widget>[
        const SizedBox(height: AppDimens.space20 + 1),
        Row(
          children: <Widget>[
            KalpiChip(
              label: '${AppStrings.filterAll}  ${state.strategies.length}',
              style: KalpiChipStyle.primary,
              horizontalPadding: 28,
            ),
            const SizedBox(width: 11),
            KalpiChip(
              label: '${AppStrings.filterSaved}  ${state.strategies.length}',
              style: KalpiChipStyle.muted,
              horizontalPadding: 28,
            ),
          ],
        ),
        const SizedBox(height: AppDimens.space24 + 5),
        for (final strategy in visible) ...<Widget>[
          StrategyCard(
            strategy: strategy,
            onOpen: () => context.push(AppRoutes.strategyDetail(strategy.id)),
            onMore: () => _showActions(strategy),
          ),
          const SizedBox(height: AppDimens.space16),
        ],
        const SizedBox(height: AppDimens.space20 + 1),
        KalpiButton(
          label: AppStrings.createStrategy,
          icon: KalpiIcons.plus,
          onPressed: () => BuilderLauncher.startCreate(context),
        ),
      ],
      const SizedBox(height: AppDimens.space20 + 1),
      Text(
        AppStrings.listFootnote,
        textAlign: TextAlign.center,
        style: KalpiTextStyles.caption,
      ),
    ];
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onProfile});

  final VoidCallback onProfile;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(AppStrings.notebookEyebrow, style: KalpiTextStyles.eyebrow),
            const SizedBox(height: AppDimens.space16 + 1),
            Semantics(
              header: true,
              child: Text(
                AppStrings.myStrategies,
                style: KalpiTextStyles.pageTitleLarge,
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: AppDimens.space4 - 4),
        child: KalpiIconButton(
          icon: KalpiIcons.user,
          semanticLabel: AppStrings.profile,
          onPressed: onProfile,
          hitSize: 48,
        ),
      ),
    ],
  );
}

class _LoadingBlock extends StatelessWidget {
  const _LoadingBlock();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.only(top: 120),
    child: Center(
      child: SizedBox(
        width: 28,
        height: 28,
        child: CircularProgressIndicator(strokeWidth: 2.5),
      ),
    ),
  );
}

class _LoadFailed extends StatelessWidget {
  const _LoadFailed({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const SizedBox(height: AppDimens.space40),
      Text(AppStrings.loadFailedTitle, style: KalpiTextStyles.errorTitle),
      const SizedBox(height: AppDimens.space12),
      Text(AppStrings.loadFailedBody, style: KalpiTextStyles.subtitle),
      const SizedBox(height: AppDimens.space32),
      KalpiButton(
        label: AppStrings.retry,
        icon: KalpiIcons.arrow,
        onPressed: onRetry,
      ),
    ],
  );
}
