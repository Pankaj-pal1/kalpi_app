import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/id_generator.dart';
import '../../../strategies/data/strategy_repository.dart';
import '../../../strategies/domain/allocation_mode.dart';
import '../../../strategies/domain/metric.dart';
import '../../../strategies/domain/ranking.dart';
import '../../../strategies/domain/rule.dart';
import '../../../strategies/domain/stock_universe.dart';
import '../../../strategies/domain/strategy.dart';
import '../../../strategies/domain/strategy_draft.dart';
import '../../../strategies/domain/strategy_validation.dart';

part 'builder_state.dart';

/// Holds one shared draft above all builder step routes.
///
/// The draft survives navigation between steps, back/forward, and metric or
/// stock pickers. Create and edit are distinct modes: edit updates the same
/// id, create produces a new one.
class BuilderCubit extends Cubit<BuilderState> {
  BuilderCubit(this._repository, {required IdGenerator idGenerator})
    : _ids = idGenerator,
      super(BuilderState.inactive());

  final StrategyRepository _repository;
  final IdGenerator _ids;

  /// Idempotency key for the in-flight save; reused across retries.
  String? _saveRequestId;

  // ---- Session lifecycle -----------------------------------------------------

  void startCreate({required StrategyDraft seed}) {
    _saveRequestId = null;
    emit(
      BuilderState(
        isActive: true,
        mode: BuilderMode.create,
        draft: seed,
        original: seed,
      ),
    );
  }

  void startEdit(Strategy strategy, {bool isCopy = false}) {
    _saveRequestId = null;
    final draft = strategy.toDraft();
    emit(
      BuilderState(
        isActive: true,
        mode: BuilderMode.edit,
        editingId: strategy.id,
        editingRevision: strategy.revision,
        editingName: strategy.name,
        isCopy: isCopy,
        draft: draft,
        original: draft,
        returnToReview: true,
      ),
    );
  }

  /// Discards the draft and ends the session.
  void reset() {
    _saveRequestId = null;
    emit(BuilderState.inactive());
  }

  void setReturnToReview(bool value) {
    if (state.returnToReview != value) {
      emit(state.copyWith(returnToReview: value));
    }
  }

  // ---- Draft mutations -----------------------------------------------------------

  void setUniverse(StockUniverse universe) {
    final ranking = _clampRanking(state.draft.ranking, universe);
    _update(state.draft.copyWith(universe: universe, ranking: ranking));
  }

  void setCustomSymbols(List<String> symbols) =>
      setUniverse(CustomUniverse(List<String>.unmodifiable(symbols)));

  /// Adds or replaces a rule by id.
  void upsertRule(Rule rule) {
    final rules = List<Rule>.from(state.draft.rules);
    final index = rules.indexWhere((r) => r.id == rule.id);
    if (index == -1) {
      rules.add(rule);
    } else {
      rules[index] = rule;
    }
    _update(state.draft.copyWith(rules: List<Rule>.unmodifiable(rules)));
  }

  void removeRule(String ruleId) {
    final rules = state.draft.rules.where((r) => r.id != ruleId).toList();
    _update(state.draft.copyWith(rules: List<Rule>.unmodifiable(rules)));
  }

  String newRuleId() => _ids.next();

  void setRankingMetric(Metric metric) => _update(
    state.draft.copyWith(ranking: state.draft.ranking.copyWith(metric: metric)),
  );

  void setRankingDirection(RankDirection direction) => _update(
    state.draft.copyWith(
      ranking: state.draft.ranking.copyWith(direction: direction),
    ),
  );

  void setRankingCount(int count) {
    final clamped = _clampRanking(
      state.draft.ranking.copyWith(count: count),
      state.draft.universe,
    );
    _update(state.draft.copyWith(ranking: clamped));
  }

  void setAllocation(AllocationMode mode) =>
      _update(state.draft.copyWith(allocation: mode));

  void setName(String name) {
    emit(
      state.copyWith(
        draft: state.draft.copyWith(name: name),
        clearNameError: true,
        clearValidationError: true,
      ),
    );
  }

  // ---- Saving ------------------------------------------------------------------------

  /// Validates and saves. Repeated calls while pending are ignored, and a
  /// retry after failure reuses the same request id.
  Future<void> save() async {
    if (state.isSaving) return;

    final nameError = StrategyValidation.validateName(state.draft.name);
    if (nameError != null) {
      emit(
        state.copyWith(
          nameError: nameError,
          saveAttempt: state.saveAttempt + 1,
        ),
      );
      return;
    }
    final draftError = StrategyValidation.validateForSave(state.draft);
    if (draftError != null) {
      emit(
        state.copyWith(
          validationError: draftError.message,
          saveAttempt: state.saveAttempt + 1,
        ),
      );
      return;
    }

    _saveRequestId ??= _ids.next();
    emit(
      state.copyWith(
        saveStatus: SaveStatus.pending,
        clearSaveError: true,
        clearNameError: true,
        clearValidationError: true,
        saveAttempt: state.saveAttempt + 1,
      ),
    );

    try {
      final draft = state.draft.copyWith(name: state.draft.trimmedName);
      final Strategy saved;
      if (state.isEdit) {
        saved = await _repository.update(
          state.editingId!,
          draft,
          requestId: _saveRequestId!,
          revision: state.editingRevision,
        );
      } else {
        saved = await _repository.create(draft, requestId: _saveRequestId!);
      }
      _saveRequestId = null;
      emit(
        state.copyWith(saveStatus: SaveStatus.success, savedStrategy: saved),
      );
    } on StrategyRepositoryException catch (e) {
      emit(
        state.copyWith(saveStatus: SaveStatus.failure, saveError: e.message),
      );
    } on Exception {
      emit(
        state.copyWith(
          saveStatus: SaveStatus.failure,
          saveError: AppStrings.genericErrorMessage,
        ),
      );
    }
  }

  /// Returns from the recovery screen to review, keeping the draft.
  void dismissSaveError() =>
      emit(state.copyWith(saveStatus: SaveStatus.idle, clearSaveError: true));

  // ---- helpers ----------------------------------------------------------------------------

  void _update(StrategyDraft draft) =>
      emit(state.copyWith(draft: draft, clearValidationError: true));

  Ranking _clampRanking(Ranking ranking, StockUniverse universe) {
    if (universe.stockCount > 0 && ranking.count > universe.stockCount) {
      return ranking.copyWith(count: universe.stockCount);
    }
    return ranking;
  }
}
