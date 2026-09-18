import 'package:kalpi_app/core/utils/id_generator.dart';
import 'package:kalpi_app/features/strategies/data/strategy_repository.dart';
import 'package:kalpi_app/features/strategies/domain/strategy.dart';
import 'package:kalpi_app/features/strategies/domain/strategy_draft.dart';

/// Deterministic ids: id-1, id-2, ...
class SequentialIdGenerator implements IdGenerator {
  int _n = 0;

  @override
  String next() => 'id-${++_n}';
}

/// In-memory repository with controllable failures and request logging.
class FakeStrategyRepository implements StrategyRepository {
  FakeStrategyRepository({List<Strategy>? seed})
    : items = List<Strategy>.from(seed ?? const <Strategy>[]);

  final List<Strategy> items;
  final List<String> requestIds = <String>[];
  final Map<String, Strategy> _completed = <String, Strategy>{};
  int createCalls = 0;
  int updateCalls = 0;
  int deleteCalls = 0;

  /// When true the next write throws and resets to false.
  bool failNextWrite = false;
  DateTime now = DateTime(2026, 9, 18, 12);
  int _seq = 0;

  void _maybeFail() {
    if (failNextWrite) {
      failNextWrite = false;
      throw const StrategyRepositoryException('Connection interrupted');
    }
  }

  @override
  Future<List<Strategy>> list() async => List<Strategy>.from(items);

  @override
  Future<Strategy?> get(String id) async {
    for (final s in items) {
      if (s.id == id) return s;
    }
    return null;
  }

  @override
  Future<Strategy> create(
    StrategyDraft draft, {
    required String requestId,
  }) async {
    requestIds.add(requestId);
    final replay = _completed[requestId];
    if (replay != null) return replay;
    createCalls++;
    _maybeFail();
    final s = Strategy.fromDraft(
      draft,
      id: 'strategy-${++_seq}',
      createdAt: now,
    );
    items.add(s);
    _completed[requestId] = s;
    return s;
  }

  @override
  Future<Strategy> update(
    String id,
    StrategyDraft draft, {
    required String requestId,
    String? revision,
  }) async {
    requestIds.add(requestId);
    final replay = _completed[requestId];
    if (replay != null) return replay;
    updateCalls++;
    _maybeFail();
    final index = items.indexWhere((s) => s.id == id);
    if (index == -1) throw StrategyNotFoundException(id);
    final updated = Strategy.fromDraft(
      draft,
      id: id,
      createdAt: items[index].createdAt,
      updatedAt: now.add(const Duration(minutes: 1)),
    );
    items[index] = updated;
    _completed[requestId] = updated;
    return updated;
  }

  @override
  Future<void> delete(String id, {required String requestId}) async {
    requestIds.add(requestId);
    deleteCalls++;
    _maybeFail();
    final before = items.length;
    items.removeWhere((s) => s.id == id);
    if (items.length == before) throw StrategyNotFoundException(id);
  }
}
