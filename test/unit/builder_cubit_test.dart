import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalpi_app/core/constants/app_strings.dart';
import 'package:kalpi_app/features/builder/presentation/cubit/builder_cubit.dart';
import 'package:kalpi_app/features/strategies/domain/metric.dart';
import 'package:kalpi_app/features/strategies/domain/rule.dart';
import 'package:kalpi_app/features/strategies/domain/rule_operator.dart';
import 'package:kalpi_app/features/strategies/domain/stock_universe.dart';
import 'package:kalpi_app/features/strategies/domain/strategy.dart';
import 'package:kalpi_app/features/strategies/domain/strategy_draft.dart';

import '../support/fakes.dart';

void main() {
  late FakeStrategyRepository repo;
  late SequentialIdGenerator ids;

  BuilderCubit build() => BuilderCubit(repo, idGenerator: ids);

  setUp(() {
    repo = FakeStrategyRepository();
    ids = SequentialIdGenerator();
  });

  group('draft editing', () {
    test('startCreate seeds the draft and is not dirty', () {
      final cubit = build()..startCreate(seed: StrategyDraft.illustrative());
      expect(cubit.state.isActive, isTrue);
      expect(cubit.state.isDirty, isFalse);
      expect(cubit.state.draft.name, 'Quality first');
    });

    test('a 3-stock custom universe clamps the ranking count to 3', () {
      final cubit = build()..startCreate(seed: StrategyDraft.illustrative());
      cubit.setCustomSymbols(<String>['A', 'B', 'C']);
      expect(cubit.state.draft.ranking.count, 3);
      expect(cubit.state.draft.universe, isA<CustomUniverse>());
      // Returning to a large index keeps the smaller count; presets re-enable.
      cubit.setUniverse(const IndexUniverse(MarketIndex.nifty500));
      expect(cubit.state.draft.ranking.count, 3);
    });

    test('upsertRule replaces by id and removeRule deletes only that rule', () {
      final cubit = build()..startCreate(seed: StrategyDraft.illustrative());
      const edited = Rule(
        id: 'rule-roe',
        metric: Metric.roe,
        operator: RuleOperator.gte,
        value: 20,
      );
      cubit.upsertRule(edited);
      expect(cubit.state.draft.rules.length, 2);
      expect(cubit.state.draft.rules.first, edited);
      cubit.removeRule('rule-debt');
      expect(cubit.state.draft.rules.map((r) => r.id), <String>['rule-roe']);
      expect(cubit.state.isDirty, isTrue);
    });
  });

  group('save', () {
    blocTest<BuilderCubit, BuilderState>(
      'blank name is rejected inline without calling the repository',
      build: build,
      act: (cubit) async {
        cubit.startCreate(seed: StrategyDraft.blank());
        await cubit.save();
      },
      verify: (cubit) {
        expect(cubit.state.nameError, AppStrings.nameRequiredError);
        expect(cubit.state.saveStatus, SaveStatus.idle);
        expect(repo.createCalls, 0);
      },
    );

    blocTest<BuilderCubit, BuilderState>(
      'successful create emits pending then success with the saved strategy',
      build: build,
      act: (cubit) async {
        cubit.startCreate(seed: StrategyDraft.illustrative());
        await cubit.save();
      },
      verify: (cubit) {
        expect(cubit.state.saveStatus, SaveStatus.success);
        expect(cubit.state.savedStrategy?.name, 'Quality first');
        expect(repo.items.length, 1);
      },
    );

    test(
      'failure preserves the draft and retry reuses the request id',
      () async {
        final cubit = build()..startCreate(seed: StrategyDraft.illustrative());
        repo.failNextWrite = true;
        await cubit.save();
        expect(cubit.state.saveStatus, SaveStatus.failure);
        expect(cubit.state.saveError, isNotNull);
        expect(cubit.state.draft.name, 'Quality first');
        expect(repo.items, isEmpty);

        await cubit.save();
        expect(cubit.state.saveStatus, SaveStatus.success);
        expect(repo.items.length, 1);
        expect(
          repo.requestIds.toSet().length,
          1,
          reason: 'retry must reuse the idempotency key',
        );
      },
    );

    test('double-tapping save produces exactly one strategy', () async {
      final cubit = build()..startCreate(seed: StrategyDraft.illustrative());
      final first = cubit.save();
      final second = cubit.save();
      await Future.wait(<Future<void>>[first, second]);
      expect(repo.createCalls, 1);
      expect(repo.items.length, 1);
    });

    test('edit updates the same id and does not add a record', () async {
      final existing = Strategy.fromDraft(
        StrategyDraft.illustrative(),
        id: 'strategy-1',
        createdAt: DateTime(2026),
      );
      repo = FakeStrategyRepository(seed: <Strategy>[existing]);
      final cubit = build()..startEdit(existing);
      expect(cubit.state.isDirty, isFalse);
      expect(cubit.state.shouldConfirmExit, isFalse);

      cubit.setName('Quality first v2');
      expect(cubit.state.shouldConfirmExit, isTrue);
      await cubit.save();

      expect(cubit.state.saveStatus, SaveStatus.success);
      expect(repo.items.length, 1);
      expect(repo.items.single.id, 'strategy-1');
      expect(repo.items.single.name, 'Quality first v2');
      expect(repo.updateCalls, 1);
      expect(repo.createCalls, 0);
    });

    test('reset ends the session and clears the draft', () async {
      final cubit = build()..startCreate(seed: StrategyDraft.illustrative());
      cubit.setName('Changed');
      cubit.reset();
      expect(cubit.state.isActive, isFalse);
      expect(cubit.state.draft.name, '');
    });
  });
}
