import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/kalpi_colors.dart';
import '../../../../core/theme/kalpi_icons.dart';
import '../../../../core/theme/kalpi_typography.dart';
import '../../../../core/widgets/kalpi_button.dart';
import '../../../../core/widgets/kalpi_scaffold.dart';
import '../../../../core/widgets/kalpi_search_field.dart';
import '../../../../core/widgets/kalpi_top_bar.dart';
import '../../../../core/widgets/page_header.dart';
import '../../../../core/widgets/surface_card.dart';
import '../../../strategies/data/stock_catalog.dart';
import '../../../strategies/domain/stock.dart';
import '../../../strategies/domain/stock_universe.dart';
import '../cubit/builder_cubit.dart';

/// Search and pick stocks for a custom universe. Pops with the chosen symbols.
class CustomUniversePage extends StatefulWidget {
  const CustomUniversePage({super.key});

  @override
  State<CustomUniversePage> createState() => _CustomUniversePageState();
}

class _CustomUniversePageState extends State<CustomUniversePage> {
  final TextEditingController _search = TextEditingController();
  final Set<String> _selected = <String>{};
  String _query = '';

  @override
  void initState() {
    super.initState();
    final universe = context.read<BuilderCubit>().state.draft.universe;
    if (universe is CustomUniverse) _selected.addAll(universe.symbols);
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<Stock> get _visible {
    if (_query.trim().isNotEmpty) return StockCatalog.search(_query);
    final selected = <Stock>[];
    final rest = <Stock>[];
    for (final stock in StockCatalog.stocks) {
      (_selected.contains(stock.symbol) ? selected : rest).add(stock);
    }
    return <Stock>[...selected, ...rest];
  }

  void _toggle(Stock stock) => setState(() {
    if (!_selected.remove(stock.symbol)) _selected.add(stock.symbol);
  });

  void _useSelection() {
    // Preserve catalogue order so summaries are stable.
    final ordered = StockCatalog.stocks
        .where((s) => _selected.contains(s.symbol))
        .map((s) => s.symbol)
        .toList();
    context.pop(ordered);
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visible;
    return KalpiScaffold(
      body: Column(
        children: <Widget>[
          KalpiTopBar(
            title: AppStrings.chooseStocksTopBar,
            onBack: () => context.pop(),
          ),
          Expanded(
            child: ScrollableWithFooter(
              footer: ActionFooter(
                child: KalpiButton(
                  label: AppStrings.useSelectedStocks,
                  icon: KalpiIcons.arrow,
                  enabled: _selected.isNotEmpty,
                  onPressed: _useSelection,
                ),
              ),
              children: <Widget>[
                const SizedBox(height: AppDimens.space24 + 4),
                const PageHeader(
                  title: AppStrings.customTitle,
                  subtitle: AppStrings.customSubtitle,
                ),
                const SizedBox(height: AppDimens.space40 + 4),
                KalpiSearchField(
                  controller: _search,
                  hint: AppStrings.searchStocksHint,
                  height: AppDimens.compactSearchFieldHeight,
                  onChanged: (q) => setState(() => _query = q),
                ),
                const SizedBox(height: AppDimens.space24 + 5),
                Semantics(
                  liveRegion: true,
                  child: Text(
                    _selected.isEmpty
                        ? AppStrings.noStocksSelected
                        : AppStrings.stocksSelected(_selected.length),
                    style: KalpiTextStyles.linkSmall.copyWith(
                      color: _selected.isEmpty
                          ? KalpiColors.textSecondary
                          : KalpiColors.accent,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimens.space20 - 1),
                if (visible.isEmpty)
                  Text(
                    AppStrings.noStocksFound,
                    style: KalpiTextStyles.subtitle,
                  )
                else
                  for (final stock in visible) ...<Widget>[
                    _StockRow(
                      stock: stock,
                      selected: _selected.contains(stock.symbol),
                      onTap: () => _toggle(stock),
                    ),
                    const SizedBox(height: AppDimens.space16),
                  ],
                const SizedBox(height: AppDimens.space8),
                Text(AppStrings.customFootnote, style: KalpiTextStyles.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StockRow extends StatelessWidget {
  const _StockRow({
    required this.stock,
    required this.selected,
    required this.onTap,
  });

  final Stock stock;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: selected,
    label: '${stock.symbol}, ${stock.name}',
    child: SurfaceCard(
      radius: AppDimens.radiusTile,
      borderColor: selected ? KalpiColors.accent : KalpiColors.border,
      onTap: onTap,
      child: SizedBox(
        height: 72,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimens.space16,
            0,
            AppDimens.space20 - 1,
            0,
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(stock.symbol, style: KalpiTextStyles.listTitle),
                    const SizedBox(height: 7),
                    Text(stock.name, style: KalpiTextStyles.cardSubtitle),
                  ],
                ),
              ),
              Icon(
                selected ? KalpiIcons.check : KalpiIcons.circle,
                size: AppDimens.iconMedium,
                color: selected ? KalpiColors.accent : KalpiColors.border,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
