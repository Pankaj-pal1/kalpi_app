part of 'strategy_list_cubit.dart';

enum StrategyListStatus { initial, loading, ready, failure }

/// A short-lived success message shown at the top of the list.
class ListBanner extends Equatable {
  const ListBanner(this.message, this.token);

  final String message;

  /// Unique per emission so identical messages still re-trigger timers.
  final int token;

  @override
  List<Object?> get props => <Object?>[message, token];
}

class StrategyListState extends Equatable {
  const StrategyListState({
    this.status = StrategyListStatus.initial,
    this.strategies = const <Strategy>[],
    this.query = '',
    this.banner,
    this.errorMessage,
    this.pendingDeleteId,
    this.deleteError,
    this.pendingDuplicate = false,
    this.duplicateError,
  });

  final StrategyListStatus status;
  final List<Strategy> strategies;
  final String query;
  final ListBanner? banner;
  final String? errorMessage;
  final String? pendingDeleteId;
  final String? deleteError;
  final bool pendingDuplicate;
  final String? duplicateError;

  bool get isLoading =>
      status == StrategyListStatus.loading ||
      status == StrategyListStatus.initial;
  bool get isReady => status == StrategyListStatus.ready;
  bool get hasQuery => query.trim().isNotEmpty;
  bool get isEmpty => isReady && strategies.isEmpty;

  /// Case-insensitive name match on the current query.
  List<Strategy> get filtered {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return strategies;
    return strategies.where((s) => s.name.toLowerCase().contains(q)).toList();
  }

  bool get hasNoResults => isReady && hasQuery && filtered.isEmpty;

  Strategy? byId(String id) {
    for (final s in strategies) {
      if (s.id == id) return s;
    }
    return null;
  }

  StrategyListState copyWith({
    StrategyListStatus? status,
    List<Strategy>? strategies,
    String? query,
    ListBanner? banner,
    bool clearBanner = false,
    String? errorMessage,
    bool clearError = false,
    String? pendingDeleteId,
    bool clearPendingDelete = false,
    String? deleteError,
    bool clearDeleteError = false,
    bool? pendingDuplicate,
    String? duplicateError,
    bool clearDuplicateError = false,
  }) => StrategyListState(
    status: status ?? this.status,
    strategies: strategies ?? this.strategies,
    query: query ?? this.query,
    banner: clearBanner ? null : (banner ?? this.banner),
    errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    pendingDeleteId: clearPendingDelete
        ? null
        : (pendingDeleteId ?? this.pendingDeleteId),
    deleteError: clearDeleteError ? null : (deleteError ?? this.deleteError),
    pendingDuplicate: pendingDuplicate ?? this.pendingDuplicate,
    duplicateError: clearDuplicateError
        ? null
        : (duplicateError ?? this.duplicateError),
  );

  @override
  List<Object?> get props => <Object?>[
    status,
    strategies,
    query,
    banner,
    errorMessage,
    pendingDeleteId,
    deleteError,
    pendingDuplicate,
    duplicateError,
  ];
}
