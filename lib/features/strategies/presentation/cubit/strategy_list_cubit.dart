import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_durations.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/id_generator.dart';
import '../../data/strategy_repository.dart';
import '../../domain/strategy.dart';
import '../../domain/rule.dart';
import '../../domain/strategy_draft.dart';

part 'strategy_list_state.dart';

/// Owns the saved-strategy list: loading, search, delete and duplicate.
class StrategyListCubit extends Cubit<StrategyListState> {
  StrategyListCubit(
    this._repository, {
    required IdGenerator idGenerator,
    Duration bannerDuration = AppDurations.toast,
  }) : _ids = idGenerator,
       _bannerDuration = bannerDuration,
       super(const StrategyListState());

  final StrategyRepository _repository;
  final IdGenerator _ids;
  final Duration _bannerDuration;

  Timer? _bannerTimer;
  int _bannerToken = 0;
  String? _pendingDuplicateRequestId;
  final Map<String, String> _deleteRequestIds = <String, String>{};

  Future<void> load() async {
    emit(state.copyWith(status: StrategyListStatus.loading, clearError: true));
    try {
      final items = await _repository.list();
      emit(state.copyWith(status: StrategyListStatus.ready, strategies: items));
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: StrategyListStatus.failure,
          errorMessage: e is StrategyRepositoryException
              ? e.message
              : AppStrings.genericErrorMessage,
        ),
      );
    }
  }

  void search(String query) => emit(state.copyWith(query: query));

  void clearSearch() => emit(state.copyWith(query: ''));

  /// Called after the builder saved or updated a strategy.
  void onStrategySaved(Strategy strategy, {required bool wasEdit}) {
    final items = List<Strategy>.from(state.strategies);
    final index = items.indexWhere((s) => s.id == strategy.id);
    if (index == -1) {
      items.insert(0, strategy);
    } else {
      items[index] = strategy;
    }
    _sort(items);
    emit(state.copyWith(strategies: items, status: StrategyListStatus.ready));
    showBanner(
      wasEdit
          ? AppStrings.changesSavedBanner
          : AppStrings.savedBanner(strategy.name),
    );
  }

  void showBanner(String message) {
    _bannerTimer?.cancel();
    _bannerToken++;
    emit(state.copyWith(banner: ListBanner(message, _bannerToken)));
    _bannerTimer = Timer(_bannerDuration, () {
      if (!isClosed) emit(state.copyWith(clearBanner: true));
    });
  }

  void dismissBanner() {
    _bannerTimer?.cancel();
    emit(state.copyWith(clearBanner: true));
  }

  /// Deletes [strategy]. Returns true on success so the caller can dismiss.
  Future<bool> delete(Strategy strategy) async {
    if (state.pendingDeleteId != null) return false;
    final requestId = _deleteRequestIds.putIfAbsent(
      strategy.id,
      () => _ids.next(),
    );
    emit(state.copyWith(pendingDeleteId: strategy.id, clearDeleteError: true));
    try {
      await _repository.delete(strategy.id, requestId: requestId);
      _deleteRequestIds.remove(strategy.id);
      final items = state.strategies.where((s) => s.id != strategy.id).toList();
      emit(state.copyWith(strategies: items, clearPendingDelete: true));
      showBanner(AppStrings.deletedBanner(strategy.name));
      return true;
    } on StrategyNotFoundException {
      _deleteRequestIds.remove(strategy.id);
      final items = state.strategies.where((s) => s.id != strategy.id).toList();
      emit(state.copyWith(strategies: items, clearPendingDelete: true));
      return true;
    } on Exception {
      emit(
        state.copyWith(
          clearPendingDelete: true,
          deleteError: AppStrings.deleteFailed,
        ),
      );
      return false;
    }
  }

  void clearDeleteError() => emit(state.copyWith(clearDeleteError: true));

  /// Creates an independent copy of [source] named [name].
  /// Returns the new strategy, or null on failure.
  Future<Strategy?> duplicate(Strategy source, String name) async {
    if (state.pendingDuplicate) return null;
    _pendingDuplicateRequestId ??= _ids.next();
    emit(state.copyWith(pendingDuplicate: true, clearDuplicateError: true));
    final draft = _copyDraft(source, name);
    try {
      final created = await _repository.create(
        draft,
        requestId: _pendingDuplicateRequestId!,
      );
      _pendingDuplicateRequestId = null;
      final items = List<Strategy>.from(state.strategies)..insert(0, created);
      _sort(items);
      emit(state.copyWith(strategies: items, pendingDuplicate: false));
      showBanner(AppStrings.copyCreatedBanner);
      return created;
    } on Exception {
      emit(
        state.copyWith(
          pendingDuplicate: false,
          duplicateError: AppStrings.duplicateFailed,
        ),
      );
      return null;
    }
  }

  void clearDuplicateError() => emit(state.copyWith(clearDuplicateError: true));

  StrategyDraft _copyDraft(Strategy source, String name) {
    // Rules get fresh ids so the copy never shares identity with the original.
    final rules = source.rules
        .map(
          (r) => Rule(
            id: _ids.next(),
            metric: r.metric,
            operator: r.operator,
            value: r.value,
          ),
        )
        .toList();
    return source.toDraft().copyWith(name: name.trim(), rules: rules);
  }

  void _sort(List<Strategy> items) =>
      items.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

  @override
  Future<void> close() {
    _bannerTimer?.cancel();
    return super.close();
  }
}
