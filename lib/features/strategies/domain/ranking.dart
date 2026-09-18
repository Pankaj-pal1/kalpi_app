import 'package:equatable/equatable.dart';

import 'metric.dart';

enum RankDirection {
  desc('desc', 'Highest first', 'Highest'),
  asc('asc', 'Lowest first', 'Lowest');

  const RankDirection(this.key, this.label, this.adjective);

  final String key;
  final String label;
  final String adjective;

  static RankDirection fromKey(String key) => RankDirection.values.firstWhere(
    (d) => d.key == key,
    orElse: () => RankDirection.desc,
  );
}

/// How the filtered stocks are ordered and how many are kept.
class Ranking extends Equatable {
  const Ranking({
    required this.metric,
    required this.direction,
    required this.count,
  });

  final Metric metric;
  final RankDirection direction;

  /// Target number of holdings. Actual holdings may be fewer.
  final int count;

  /// e.g. `Highest ROE · top 15`
  String get summary =>
      '${direction.adjective} ${metric.shortLabel} · top $count';

  /// e.g. `Top 15 by ROE`
  String get detailSummary => 'Top $count by ${metric.shortLabel}';

  Ranking copyWith({Metric? metric, RankDirection? direction, int? count}) =>
      Ranking(
        metric: metric ?? this.metric,
        direction: direction ?? this.direction,
        count: count ?? this.count,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'metric': metric.key,
    'direction': direction.key,
    'count': count,
  };

  factory Ranking.fromJson(Map<String, dynamic> json) => Ranking(
    metric: Metric.fromKey(json['metric'] as String),
    direction: RankDirection.fromKey(json['direction'] as String),
    count: json['count'] as int,
  );

  @override
  List<Object?> get props => <Object?>[metric, direction, count];
}
