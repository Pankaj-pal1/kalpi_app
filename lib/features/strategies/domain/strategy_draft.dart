import 'package:equatable/equatable.dart';

import 'allocation_mode.dart';
import 'metric.dart';
import 'ranking.dart';
import 'rule.dart';
import 'rule_operator.dart';
import 'stock_universe.dart';

/// Everything needed to describe a strategy before it is saved.
///
/// All rules are combined with AND (`match: all`).
class StrategyDraft extends Equatable {
  const StrategyDraft({
    required this.name,
    required this.universe,
    required this.rules,
    required this.ranking,
    required this.allocation,
  });

  /// The illustrative example used throughout onboarding and the guide.
  /// Clone per session — never share a mutable instance.
  factory StrategyDraft.illustrative() => const StrategyDraft(
    name: 'Quality first',
    universe: IndexUniverse(MarketIndex.nifty500),
    rules: <Rule>[
      Rule(
        id: 'rule-roe',
        metric: Metric.roe,
        operator: RuleOperator.gt,
        value: 15,
      ),
      Rule(
        id: 'rule-debt',
        metric: Metric.debtToEquity,
        operator: RuleOperator.lt,
        value: 1,
      ),
    ],
    ranking: Ranking(
      metric: Metric.roe,
      direction: RankDirection.desc,
      count: 15,
    ),
    allocation: AllocationMode.equal,
  );

  /// A blank draft with sensible defaults and no name.
  factory StrategyDraft.blank() => const StrategyDraft(
    name: '',
    universe: IndexUniverse(MarketIndex.nifty500),
    rules: <Rule>[],
    ranking: Ranking(
      metric: Metric.roe,
      direction: RankDirection.desc,
      count: 15,
    ),
    allocation: AllocationMode.equal,
  );

  final String name;
  final StockUniverse universe;
  final List<Rule> rules;
  final Ranking ranking;
  final AllocationMode allocation;

  String get trimmedName => name.trim();

  /// Holdings the strategy can actually target: the smaller of the ranking
  /// count and the universe size.
  int get effectiveHoldings =>
      ranking.count < universe.stockCount ? ranking.count : universe.stockCount;

  /// Equal weight per holding as a percentage (0 when nothing selected).
  double get equalWeightPercent =>
      effectiveHoldings == 0 ? 0 : 100 / effectiveHoldings;

  StrategyDraft copyWith({
    String? name,
    StockUniverse? universe,
    List<Rule>? rules,
    Ranking? ranking,
    AllocationMode? allocation,
  }) => StrategyDraft(
    name: name ?? this.name,
    universe: universe ?? this.universe,
    rules: rules ?? List<Rule>.unmodifiable(this.rules),
    ranking: ranking ?? this.ranking,
    allocation: allocation ?? this.allocation,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'name': name,
    'universe': universe.toJson(),
    'rules': rules.map((r) => r.toJson()).toList(),
    'match': 'all',
    'ranking': ranking.toJson(),
    'allocation': allocation.key,
  };

  factory StrategyDraft.fromJson(Map<String, dynamic> json) => StrategyDraft(
    name: json['name'] as String,
    universe: StockUniverse.fromJson(json['universe'] as Map<String, dynamic>),
    rules: (json['rules'] as List<dynamic>)
        .map((r) => Rule.fromJson(r as Map<String, dynamic>))
        .toList(),
    ranking: Ranking.fromJson(json['ranking'] as Map<String, dynamic>),
    allocation: AllocationMode.fromKey(json['allocation'] as String),
  );

  @override
  List<Object?> get props => <Object?>[
    name,
    universe,
    rules,
    ranking,
    allocation,
  ];
}
