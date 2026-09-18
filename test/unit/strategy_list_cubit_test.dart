import 'package:flutter_test/flutter_test.dart';
import 'package:kalpi_app/core/constants/app_strings.dart';
import 'package:kalpi_app/features/strategies/domain/strategy.dart';
import 'package:kalpi_app/features/strategies/domain/strategy_draft.dart';
import 'package:kalpi_app/features/strategies/presentation/cubit/strategy_list_cubit.dart';

import '../support/fakes.dart';

Strategy _strategy(String id, String name, {DateTime? updatedAt}) =>
    Strategy.fromDraft(
      StrategyDraft.illustrative().copyWith(name: name),
      id: id,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: updatedAt ?? DateTime(2026, 1, 1),
    );

void main() {
  late FakeStrategyRepository repo;
  late StrategyListCubit cubit;

  setUp(() {
    repo = FakeStrategyRepository(
      seed: <Strategy>[
        _strategy('s1', 'Quality first'),
        _strategy('s2', 'Momentum Mix', updatedAt: DateTime(2026, 2, 1)),
      ],
    );
    cubit = StrategyListCubit(
      repo,
      idGenerator: SequentialIdGenerator(),
      bannerDuration: const Duration(milliseconds: 20),
    );
  });

  tearDown(() => cubit.close());

  test('load returns the repository items', () async {
    await cubit.load();
    expect(cubit.state.isReady, isTrue);
    expect(cubit.state.strategies.length, 2);
  });

  test('search is case-insensitive and distinguishes no results', () async {
    await cubit.load();
    cubit.search('QUALITY');
    expect(cubit.state.filtered.map((s) => s.name), <String>['Quality first']);
    expect(cubit.state.hasNoResults, isFalse);
    cubit.search('momentum');
    expect(cubit.state.filtered.length, 1);
    cubit.search('zzz');
    expect(cubit.state.hasNoResults, isTrue);
    cubit.clearSearch();
    expect(cubit.state.filtered.length, 2);
  });

  test('delete removes only the selected record and shows a banner', () async {
    await cubit.load();
    final ok = await cubit.delete(cubit.state.byId('s1')!);
    expect(ok, isTrue);
    expect(cubit.state.strategies.map((s) => s.id), <String>['s2']);
    expect(
      cubit.state.banner?.message,
      AppStrings.deletedBanner('Quality first'),
    );
    await Future<void>.delayed(const Duration(milliseconds: 40));
    expect(cubit.state.banner, isNull, reason: 'banner clears itself');
  });

  test('failed delete keeps the record and surfaces an error', () async {
    await cubit.load();
    repo.failNextWrite = true;
    final ok = await cubit.delete(cubit.state.byId('s1')!);
    expect(ok, isFalse);
    expect(cubit.state.strategies.length, 2);
    expect(cubit.state.deleteError, AppStrings.deleteFailed);
    expect(cubit.state.pendingDeleteId, isNull);
  });

  test(
    'duplicate creates a distinct id with fresh rule ids and keeps the original',
    () async {
      await cubit.load();
      final original = cubit.state.byId('s1')!;
      final copy = await cubit.duplicate(original, 'Quality first — copy');
      expect(copy, isNotNull);
      expect(copy!.id, isNot(original.id));
      expect(copy.name, 'Quality first — copy');
      expect(copy.rules.length, original.rules.length);
      for (var i = 0; i < copy.rules.length; i++) {
        expect(copy.rules[i].id, isNot(original.rules[i].id));
        expect(copy.rules[i].metric, original.rules[i].metric);
        expect(copy.rules[i].value, original.rules[i].value);
      }
      expect(cubit.state.byId('s1'), original);
      expect(cubit.state.strategies.length, 3);
      expect(cubit.state.banner?.message, AppStrings.copyCreatedBanner);
    },
  );

  test(
    'onStrategySaved inserts new records and replaces edited ones',
    () async {
      await cubit.load();
      final created = _strategy(
        's3',
        'New idea',
        updatedAt: DateTime(2026, 3, 1),
      );
      cubit.onStrategySaved(created, wasEdit: false);
      expect(cubit.state.strategies.first.id, 's3');
      expect(cubit.state.banner?.message, AppStrings.savedBanner('New idea'));

      final edited = _strategy(
        's3',
        'New idea v2',
        updatedAt: DateTime(2026, 3, 2),
      );
      cubit.onStrategySaved(edited, wasEdit: true);
      expect(cubit.state.strategies.where((s) => s.id == 's3').length, 1);
      expect(cubit.state.byId('s3')!.name, 'New idea v2');
      expect(cubit.state.banner?.message, AppStrings.changesSavedBanner);
    },
  );
}
