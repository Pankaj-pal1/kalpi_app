import 'package:equatable/equatable.dart';

import '../../../core/utils/number_format.dart';
import 'metric.dart';
import 'rule_operator.dart';

/// A single filter: `metric operator value`, combined with AND.
class Rule extends Equatable {
  const Rule({
    required this.id,
    required this.metric,
    required this.operator,
    required this.value,
  });

  final String id;
  final Metric metric;
  final RuleOperator operator;
  final double value;

  /// Value with its unit, e.g. `15%`, `1`, `25x`.
  String get formattedValue {
    final number = formatCompactNumber(value);
    return metric.unit.appendsToValue ? '$number${metric.unit.suffix}' : number;
  }

  /// Full sentence-case summary, e.g. `Return on equity > 15%`.
  String get title => '${metric.label} ${operator.symbol} $formattedValue';

  /// Compact summary, e.g. `ROE > 15%`.
  String get shortSummary =>
      '${metric.shortLabel} ${operator.symbol} $formattedValue';

  /// True when [other] tests the same condition with a different id.
  bool isSameConditionAs(Rule other) =>
      other.id != id &&
      other.metric == metric &&
      other.operator == operator &&
      other.value == value;

  Rule copyWith({Metric? metric, RuleOperator? operator, double? value}) =>
      Rule(
        id: id,
        metric: metric ?? this.metric,
        operator: operator ?? this.operator,
        value: value ?? this.value,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'metric': metric.key,
    'operator': operator.key,
    'value': value,
  };

  factory Rule.fromJson(Map<String, dynamic> json) => Rule(
    id: json['id'] as String,
    metric: Metric.fromKey(json['metric'] as String),
    operator: RuleOperator.fromKey(json['operator'] as String),
    value: (json['value'] as num).toDouble(),
  );

  @override
  List<Object?> get props => <Object?>[id, metric, operator, value];
}
