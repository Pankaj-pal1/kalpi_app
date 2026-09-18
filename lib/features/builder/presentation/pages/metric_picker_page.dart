import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/kalpi_colors.dart';
import '../../../../core/theme/kalpi_icons.dart';
import '../../../../core/theme/kalpi_typography.dart';
import '../../../../core/widgets/kalpi_chip.dart';
import '../../../../core/widgets/kalpi_scaffold.dart';
import '../../../../core/widgets/kalpi_search_field.dart';
import '../../../../core/widgets/kalpi_top_bar.dart';
import '../../../../core/widgets/page_header.dart';
import '../../../../core/widgets/surface_card.dart';
import '../../../strategies/domain/metric.dart';
import '../../../strategies/domain/ranking.dart';
import '../cubit/builder_cubit.dart';

/// Result when picking a ranking metric: metric plus sort direction.
class RankingChoice {
  const RankingChoice(this.metric, this.direction);

  final Metric metric;
  final RankDirection direction;
}

/// "What matters to you?" — metric picker for rules and for ranking.
///
/// Pops a [Metric] in rule mode, or a [RankingChoice] when [forRanking].
class MetricPickerPage extends StatefulWidget {
  const MetricPickerPage({super.key, this.forRanking = false});

  final bool forRanking;

  @override
  State<MetricPickerPage> createState() => _MetricPickerPageState();
}

class _MetricPickerPageState extends State<MetricPickerPage> {
  final TextEditingController _search = TextEditingController();
  String _query = '';
  MetricCategory? _category;
  late RankDirection _direction;
  late Metric _currentRankingMetric;

  @override
  void initState() {
    super.initState();
    final ranking = context.read<BuilderCubit>().state.draft.ranking;
    _direction = ranking.direction;
    _currentRankingMetric = ranking.metric;
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<Metric> get _visible => Metric.values
      .where((m) => _category == null || m.category == _category)
      .where((m) => m.matches(_query))
      .toList();

  void _select(Metric metric) {
    if (widget.forRanking) {
      context.pop(RankingChoice(metric, _direction));
    } else {
      context.pop(metric);
    }
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visible;
    return KalpiScaffold(
      body: Column(
        children: <Widget>[
          KalpiTopBar(
            title: widget.forRanking
                ? AppStrings.chooseRankingMetricTopBar
                : AppStrings.chooseMetricTopBar,
            onBack: () => context.pop(),
          ),
          Expanded(
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(
                context,
              ).copyWith(scrollbars: false),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppDimens.gutter,
                  AppDimens.space24 + 3,
                  AppDimens.gutter,
                  AppDimens.space32,
                ),
                children: <Widget>[
                  const PageHeader(title: AppStrings.metricsTitle),
                  const SizedBox(height: AppDimens.space24 + 1),
                  KalpiSearchField(
                    controller: _search,
                    hint: AppStrings.searchMetricsHint,
                    height: AppDimens.compactSearchFieldHeight,
                    onChanged: (q) => setState(() => _query = q),
                  ),
                  const SizedBox(height: AppDimens.space20 + 2),
                  Wrap(
                    spacing: 11,
                    runSpacing: AppDimens.space8,
                    children: <Widget>[
                      KalpiChip(
                        label: AppStrings.filterAll,
                        selected: _category == null,
                        onTap: () => setState(() => _category = null),
                      ),
                      for (final c in MetricCategory.values)
                        KalpiChip(
                          label: c.label,
                          style: KalpiChipStyle.accent,
                          selected: _category == c ? true : null,
                          onTap: () => setState(
                            () => _category = _category == c ? null : c,
                          ),
                        ),
                    ],
                  ),
                  if (widget.forRanking) ...<Widget>[
                    const SizedBox(height: AppDimens.space20),
                    Wrap(
                      spacing: 11,
                      runSpacing: AppDimens.space8,
                      children: <Widget>[
                        for (final d in RankDirection.values)
                          KalpiChip(
                            label: d.label,
                            selected: _direction == d,
                            onTap: () => setState(() => _direction = d),
                          ),
                      ],
                    ),
                  ],
                  const SizedBox(height: AppDimens.space32 + 1),
                  if (visible.isEmpty)
                    Text(
                      AppStrings.noMetricsFound,
                      style: KalpiTextStyles.subtitle,
                    )
                  else
                    for (final metric in visible) ...<Widget>[
                      _MetricRow(metric: metric, onTap: () => _select(metric)),
                      if (widget.forRanking &&
                          metric == _currentRankingMetric) ...<Widget>[
                        const SizedBox(height: AppDimens.space16),
                        Text(
                          AppStrings.rankingMetricNote(metric.label),
                          style: KalpiTextStyles.caption,
                        ),
                        const SizedBox(height: AppDimens.space24),
                      ] else
                        const SizedBox(height: AppDimens.space16),
                    ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.metric, required this.onTap});

  final Metric metric;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => SurfaceCard(
    radius: AppDimens.radiusTile,
    onTap: onTap,
    semanticLabel: '${metric.label}. ${metric.description}',
    child: SizedBox(
      height: 84,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppDimens.space16,
          0,
          AppDimens.space20 + 1,
          0,
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(metric.label, style: KalpiTextStyles.cardTitle),
                  const SizedBox(height: 9),
                  Text(metric.description, style: KalpiTextStyles.cardSubtitle),
                ],
              ),
            ),
            const Icon(KalpiIcons.chevron, size: 14, color: KalpiColors.accent),
          ],
        ),
      ),
    ),
  );
}
