import 'package:flutter_test/flutter_test.dart';
import 'package:kalpi_app/features/strategies/data/demo_failure_switch.dart';
import 'package:kalpi_app/features/strategies/data/local_strategy_repository.dart';
import 'package:kalpi_app/features/strategies/data/strategy_repository.dart';
import 'package:kalpi_app/features/strategies/domain/strategy_draft.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../support/fakes.dart';

void main() {
  late LocalStrategyRepository repo;
  late DemoFailureSwitch failure;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final prefs = await SharedPreferences.getInstance();
    failure = DemoFailureSwitch();
    repo = LocalStrategyRepository(
      prefs,
      idGenerator: SequentialIdGenerator(),
      failureSwitch: failure,
      latency: Duration.zero,
      readLatency: Duration.zero,
    );
  });

  test(
    'create persists and list returns the strategy after a reload',
    () async {
      final created = await repo.create(
        StrategyDraft.illustrative(),
        requestId: 'r1',
      );
      expect(created.id, 'id-1');
      final prefs = await SharedPreferences.getInstance();
      final reloaded = LocalStrategyRepository(
        prefs,
        idGenerator: SequentialIdGenerator(),
        latency: Duration.zero,
        readLatency: Duration.zero,
      );
      final items = await reloaded.list();
      expect(items.single.name, 'Quality first');
      expect(items.single.rules.length, 2);
    },
  );

  test('replaying the same request id does not duplicate', () async {
    final a = await repo.create(
      StrategyDraft.illustrative(),
      requestId: 'same',
    );
    final b = await repo.create(
      StrategyDraft.illustrative(),
      requestId: 'same',
    );
    expect(a.id, b.id);
    expect((await repo.list()).length, 1);
  });

  test('update keeps the id and bumps the revision', () async {
    final created = await repo.create(
      StrategyDraft.illustrative(),
      requestId: 'r1',
    );
    final updated = await repo.update(
      created.id,
      created.toDraft().copyWith(name: 'Renamed'),
      requestId: 'r2',
      revision: created.revision,
    );
    expect(updated.id, created.id);
    expect(updated.name, 'Renamed');
    expect(updated.revision, isNot(created.revision));
    expect((await repo.list()).length, 1);
  });

  test('updating with a stale revision is rejected', () async {
    final created = await repo.create(
      StrategyDraft.illustrative(),
      requestId: 'r1',
    );
    await repo.update(
      created.id,
      created.toDraft(),
      requestId: 'r2',
      revision: created.revision,
    );
    expect(
      () => repo.update(
        created.id,
        created.toDraft(),
        requestId: 'r3',
        revision: created.revision,
      ),
      throwsA(isA<StaleRevisionException>()),
    );
  });

  test('delete removes the record and unknown ids throw', () async {
    final created = await repo.create(
      StrategyDraft.illustrative(),
      requestId: 'r1',
    );
    await repo.delete(created.id, requestId: 'd1');
    expect(await repo.list(), isEmpty);
    expect(
      () => repo.delete(created.id, requestId: 'd2'),
      throwsA(isA<StrategyNotFoundException>()),
    );
  });

  test('the demo failure switch fails exactly one write', () async {
    failure.arm(true);
    expect(
      () => repo.create(StrategyDraft.illustrative(), requestId: 'r1'),
      throwsA(isA<StrategyRepositoryException>()),
    );
    await Future<void>.delayed(Duration.zero);
    expect(failure.isArmed, isFalse);
    final created = await repo.create(
      StrategyDraft.illustrative(),
      requestId: 'r1',
    );
    expect(created.name, 'Quality first');
  });
}
