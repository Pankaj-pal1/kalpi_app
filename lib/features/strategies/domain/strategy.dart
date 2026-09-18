import 'package:equatable/equatable.dart';

import 'allocation_mode.dart';
import 'ranking.dart';
import 'rule.dart';
import 'stock_universe.dart';
import 'strategy_draft.dart';

/// A saved strategy definition. Saving never places trades.
class Strategy extends Equatable {
  const Strategy({
    required this.id,
    required this.name,
    required this.universe,
    required this.rules,
    required this.ranking,
    required this.allocation,
    required this.createdAt,
    required this.updatedAt,
    this.revision,
  });

  factory Strategy.fromDraft(
    StrategyDraft draft, {
    required String id,
    required DateTime createdAt,
    DateTime? updatedAt,
    String? revision,
  }) => Strategy(
    id: id,
    name: draft.trimmedName,
    universe: draft.universe,
    rules: List<Rule>.unmodifiable(draft.rules),
    ranking: draft.ranking,
    allocation: draft.allocation,
    createdAt: createdAt,
    updatedAt: updatedAt ?? createdAt,
    revision: revision,
  );

  final String id;
  final String name;
  final StockUniverse universe;
  final List<Rule> rules;
  final Ranking ranking;
  final AllocationMode allocation;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Optional concurrency token from a real backend.
  final String? revision;

  StrategyDraft toDraft() => StrategyDraft(
    name: name,
    universe: universe,
    rules: List<Rule>.from(rules),
    ranking: ranking,
    allocation: allocation,
  );

  Strategy copyWith({
    String? name,
    StockUniverse? universe,
    List<Rule>? rules,
    Ranking? ranking,
    AllocationMode? allocation,
    DateTime? updatedAt,
    String? revision,
  }) => Strategy(
    id: id,
    name: name ?? this.name,
    universe: universe ?? this.universe,
    rules: rules ?? this.rules,
    ranking: ranking ?? this.ranking,
    allocation: allocation ?? this.allocation,
    createdAt: createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    revision: revision ?? this.revision,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    ...toDraft().toJson(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    if (revision != null) 'revision': revision,
  };

  factory Strategy.fromJson(Map<String, dynamic> json) {
    final draft = StrategyDraft.fromJson(json);
    return Strategy.fromDraft(
      draft,
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      revision: json['revision'] as String?,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    id,
    name,
    universe,
    rules,
    ranking,
    allocation,
    createdAt,
    updatedAt,
    revision,
  ];
}
