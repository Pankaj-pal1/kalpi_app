import 'package:equatable/equatable.dart';

import '../../../core/constants/app_config.dart';

/// Pre-defined index universes.
enum MarketIndex {
  nifty50(
    key: 'NIFTY50',
    label: 'Nifty 50',
    description: '50 of India’s largest companies.',
    constituentCount: AppConfig.nifty50Count,
  ),
  nifty500(
    key: 'NIFTY500',
    label: 'Nifty 500',
    description: 'A broader mix of large, mid and\nsmall companies.',
    constituentCount: AppConfig.nifty500Count,
  );

  const MarketIndex({
    required this.key,
    required this.label,
    required this.description,
    required this.constituentCount,
  });

  final String key;
  final String label;
  final String description;
  final int constituentCount;

  static MarketIndex fromKey(String key) => MarketIndex.values.firstWhere(
    (i) => i.key == key,
    orElse: () => MarketIndex.nifty500,
  );
}

/// The starting pool of stocks a strategy filters.
sealed class StockUniverse extends Equatable {
  const StockUniverse();

  /// Display label, e.g. `Nifty 500` or `Custom universe`.
  String get label;

  /// Label for chips and summaries, e.g. `Nifty 500` or `Custom · 3 stocks`.
  String get summaryLabel;

  /// Number of stocks in the pool.
  int get stockCount;

  bool get isCustom => this is CustomUniverse;

  Map<String, dynamic> toJson();

  factory StockUniverse.fromJson(Map<String, dynamic> json) {
    switch (json['kind']) {
      case 'custom':
        return CustomUniverse(
          List<String>.from(json['symbols'] as List<dynamic>),
        );
      default:
        return IndexUniverse(MarketIndex.fromKey(json['index'] as String));
    }
  }
}

class IndexUniverse extends StockUniverse {
  const IndexUniverse(this.index);

  final MarketIndex index;

  @override
  String get label => index.label;

  @override
  String get summaryLabel => index.label;

  @override
  int get stockCount => index.constituentCount;

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    'kind': 'index',
    'index': index.key,
  };

  @override
  List<Object?> get props => <Object?>[index];
}

class CustomUniverse extends StockUniverse {
  const CustomUniverse(this.symbols);

  final List<String> symbols;

  @override
  String get label => 'Custom universe';

  @override
  String get summaryLabel =>
      'Custom · ${symbols.length} ${symbols.length == 1 ? 'stock' : 'stocks'}';

  @override
  int get stockCount => symbols.length;

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    'kind': 'custom',
    'symbols': symbols,
  };

  @override
  List<Object?> get props => <Object?>[symbols];
}
