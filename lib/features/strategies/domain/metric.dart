import 'package:flutter/widgets.dart';

import '../../../core/theme/kalpi_icons.dart';

/// Grouping used by the metric picker's filter chips.
enum MetricCategory {
  quality('Quality'),
  value('Value'),
  momentum('Momentum');

  const MetricCategory(this.label);

  final String label;
}

/// How a metric's numeric value is expressed.
enum MetricUnit {
  percent('%', 'percent'),
  ratio('ratio', 'ratio'),
  multiple('x', 'multiple');

  const MetricUnit(this.suffix, this.description);

  /// Short suffix shown beside the value field.
  final String suffix;
  final String description;

  /// Whether the suffix is appended directly to a formatted value.
  bool get appendsToValue => this == percent || this == multiple;
}

/// A fundamental or price-based measure a rule can test.
enum Metric {
  roe(
    key: 'roe',
    label: 'Return on equity',
    editorLabel: 'Return on equity (ROE)',
    shortLabel: 'ROE',
    description: 'Profit earned from shareholder money.',
    explanation:
        'ROE tells you how efficiently a company uses shareholder money to earn profit.',
    ruleCategoryLabel: 'PROFITABILITY',
    category: MetricCategory.quality,
    unit: MetricUnit.percent,
    icon: KalpiIcons.chart,
    searchTerms: 'roe return equity profit profitability',
  ),
  debtToEquity(
    key: 'debtToEquity',
    label: 'Debt-to-equity',
    editorLabel: 'Debt-to-equity',
    shortLabel: 'D/E',
    description: 'Debt relative to shareholder equity.',
    explanation:
        'Debt-to-equity compares what a company owes with the value owned by shareholders.',
    ruleCategoryLabel: 'FINANCIAL HEALTH',
    category: MetricCategory.quality,
    unit: MetricUnit.ratio,
    icon: KalpiIcons.shield,
    searchTerms: 'debt equity leverage financial health d/e',
  ),
  pe(
    key: 'pe',
    label: 'Price-to-earnings',
    editorLabel: 'Price-to-earnings (P/E)',
    shortLabel: 'P/E',
    description: 'Price paid for each rupee of earnings.',
    explanation:
        'P/E shows how much investors pay for each rupee a company earns. Lower can mean cheaper.',
    ruleCategoryLabel: 'VALUATION',
    category: MetricCategory.value,
    unit: MetricUnit.multiple,
    icon: KalpiIcons.flag,
    searchTerms: 'pe price earnings valuation value cheap multiple',
  ),
  momentum12m(
    key: 'momentum12m',
    label: '12-month momentum',
    editorLabel: '12-month momentum',
    shortLabel: 'Momentum',
    description: 'How a stock’s price changed over a year.',
    explanation:
        'Momentum measures how much a stock’s price has moved over the past twelve months.',
    ruleCategoryLabel: 'MOMENTUM',
    category: MetricCategory.momentum,
    unit: MetricUnit.percent,
    icon: KalpiIcons.clock,
    searchTerms: 'momentum price change trend year 12 month',
  );

  const Metric({
    required this.key,
    required this.label,
    required this.editorLabel,
    required this.shortLabel,
    required this.description,
    required this.explanation,
    required this.ruleCategoryLabel,
    required this.category,
    required this.unit,
    required this.icon,
    required this.searchTerms,
  });

  /// Stable key used for persistence.
  final String key;
  final String label;
  final String editorLabel;
  final String shortLabel;
  final String description;
  final String explanation;
  final String ruleCategoryLabel;
  final MetricCategory category;
  final MetricUnit unit;
  final IconData icon;
  final String searchTerms;

  static Metric fromKey(String key) =>
      Metric.values.firstWhere((m) => m.key == key, orElse: () => Metric.roe);

  bool matches(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return label.toLowerCase().contains(q) ||
        shortLabel.toLowerCase().contains(q) ||
        searchTerms.contains(q);
  }
}
