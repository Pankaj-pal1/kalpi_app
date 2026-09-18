import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_durations.dart';
import '../../../core/constants/app_storage_keys.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/id_generator.dart';
import '../domain/strategy.dart';
import '../domain/strategy_draft.dart';
import 'demo_failure_switch.dart';
import 'strategy_repository.dart';

/// Demo adapter that keeps strategies on the device.
///
/// It simulates request latency so busy states are visible, honours
/// idempotent request ids, and can be made to fail once through
/// [DemoFailureSwitch]. Replace with a real API client when a backend exists.
class LocalStrategyRepository implements StrategyRepository {
  LocalStrategyRepository(
    this._prefs, {
    required IdGenerator idGenerator,
    DemoFailureSwitch? failureSwitch,
    Duration latency = AppDurations.demoSaveDelay,
    Duration readLatency = AppDurations.demoLoadDelay,
    DateTime Function()? clock,
  }) : _ids = idGenerator,
       _failureSwitch = failureSwitch,
       _latency = latency,
       _readLatency = readLatency,
       _clock = clock ?? DateTime.now;

  final SharedPreferences _prefs;
  final IdGenerator _ids;
  final DemoFailureSwitch? _failureSwitch;
  final Duration _latency;
  final Duration _readLatency;
  final DateTime Function() _clock;

  final Map<String, Strategy> _completedWrites = <String, Strategy>{};
  final Set<String> _completedDeletes = <String>{};

  @override
  Future<List<Strategy>> list() async {
    await Future<void>.delayed(_readLatency);
    final items = _read();
    items.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return items;
  }

  @override
  Future<Strategy?> get(String id) async {
    await Future<void>.delayed(_readLatency);
    for (final s in _read()) {
      if (s.id == id) return s;
    }
    return null;
  }

  @override
  Future<Strategy> create(
    StrategyDraft draft, {
    required String requestId,
  }) async {
    final replay = _completedWrites[requestId];
    if (replay != null) return replay;
    await _simulateWrite();
    final now = _clock();
    final strategy = Strategy.fromDraft(
      draft,
      id: _ids.next(),
      createdAt: now,
      revision: _revisionFor(now),
    );
    final items = _read()..add(strategy);
    await _write(items);
    _completedWrites[requestId] = strategy;
    return strategy;
  }

  @override
  Future<Strategy> update(
    String id,
    StrategyDraft draft, {
    required String requestId,
    String? revision,
  }) async {
    final replay = _completedWrites[requestId];
    if (replay != null) return replay;
    await _simulateWrite();
    final items = _read();
    final index = items.indexWhere((s) => s.id == id);
    if (index == -1) throw StrategyNotFoundException(id);
    final existing = items[index];
    if (revision != null &&
        existing.revision != null &&
        existing.revision != revision) {
      throw const StaleRevisionException();
    }
    final now = _clock();
    final updated = Strategy.fromDraft(
      draft,
      id: existing.id,
      createdAt: existing.createdAt,
      updatedAt: now,
      revision: _revisionFor(now),
    );
    items[index] = updated;
    await _write(items);
    _completedWrites[requestId] = updated;
    return updated;
  }

  @override
  Future<void> delete(String id, {required String requestId}) async {
    if (_completedDeletes.contains(requestId)) return;
    await _simulateWrite();
    final items = _read();
    final before = items.length;
    items.removeWhere((s) => s.id == id);
    if (items.length == before) throw StrategyNotFoundException(id);
    await _write(items);
    _completedDeletes.add(requestId);
  }

  // ---- helpers ------------------------------------------------------------

  Future<void> _simulateWrite() async {
    await Future<void>.delayed(_latency);
    if (_failureSwitch?.consume() ?? false) {
      throw const StrategyRepositoryException(AppStrings.offlineErrorMessage);
    }
  }

  String _revisionFor(DateTime time) => time.microsecondsSinceEpoch.toString();

  List<Strategy> _read() {
    final raw = _prefs.getString(AppStorageKeys.strategies);
    if (raw == null || raw.isEmpty) return <Strategy>[];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((e) => Strategy.fromJson(e as Map<String, dynamic>))
          .toList();
    } on FormatException {
      return <Strategy>[];
    }
  }

  Future<void> _write(List<Strategy> items) async {
    final ok = await _prefs.setString(
      AppStorageKeys.strategies,
      jsonEncode(items.map((s) => s.toJson()).toList()),
    );
    if (!ok) {
      throw const StrategyRepositoryException(AppStrings.genericErrorMessage);
    }
  }
}
