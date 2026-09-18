import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalpi_app/app/router/app_routes.dart';
import 'package:kalpi_app/core/constants/app_strings.dart';
import 'package:kalpi_app/features/builder/presentation/cubit/builder_cubit.dart';
import 'package:kalpi_app/features/strategies/domain/strategy.dart';
import 'package:kalpi_app/features/strategies/domain/strategy_draft.dart';

import 'golden_harness.dart';

Strategy _qualityFirst() => Strategy.fromDraft(
  StrategyDraft.illustrative(),
  id: 'quality-first',
  createdAt: DateTime(2026, 9, 18, 9),
);

void main() {
  setUpAll(loadAppFonts);

  group('onboarding', () {
    testWidgets('welcome', (tester) async {
      await pumpKalpi(tester, location: AppRoutes.welcome, onboarded: false);
      await snap(tester, 'welcome');
    });

    testWidgets('experience', (tester) async {
      await pumpKalpi(tester, location: AppRoutes.experience, onboarded: false);
      await snap(tester, 'experience');
    });

    testWidgets('intent', (tester) async {
      await pumpKalpi(tester, location: AppRoutes.intent, onboarded: false);
      await snap(tester, 'goal');
    });
  });

  group('strategies', () {
    testWidgets('empty', (tester) async {
      await pumpKalpi(tester, location: AppRoutes.strategies);
      await snap(tester, 'empty');
    });

    testWidgets('list idle', (tester) async {
      await pumpKalpi(
        tester,
        location: AppRoutes.strategies,
        strategies: <Strategy>[_qualityFirst()],
      );
      await snap(tester, 'list_idle');
    });

    testWidgets('list with saved banner', (tester) async {
      final app = await pumpKalpi(
        tester,
        location: AppRoutes.strategies,
        strategies: <Strategy>[_qualityFirst()],
      );
      app.strategies.showBanner(AppStrings.savedBanner('Quality first'));
      await tester.pump();
      await snap(tester, 'list');
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('search result and no results', (tester) async {
      await pumpKalpi(
        tester,
        location: AppRoutes.strategies,
        strategies: <Strategy>[_qualityFirst()],
      );
      await tester.enterText(find.byType(TextField), 'quality');
      await tester.pumpAndSettle();
      await snap(tester, 'search_result');
      await tester.enterText(find.byType(TextField), 'momentum');
      await tester.pumpAndSettle();
      await snap(tester, 'search_empty');
    });

    testWidgets('detail', (tester) async {
      await pumpKalpi(
        tester,
        location: AppRoutes.strategyDetail('quality-first'),
        strategies: <Strategy>[_qualityFirst()],
      );
      await snap(tester, 'detail');
    });

    testWidgets('manage and delete sheets', (tester) async {
      await pumpKalpi(
        tester,
        location: AppRoutes.strategyDetail('quality-first'),
        strategies: <Strategy>[_qualityFirst()],
      );
      await tester.tap(find.bySemanticsLabel(AppStrings.moreActions));
      await tester.pumpAndSettle();
      await snap(tester, 'manage');
      await tester.tap(find.text(AppStrings.deleteStrategy));
      await tester.pumpAndSettle();
      await snap(tester, 'delete');
    });

    testWidgets('duplicate', (tester) async {
      await pumpKalpi(
        tester,
        location: AppRoutes.strategyDuplicate('quality-first'),
        strategies: <Strategy>[_qualityFirst()],
      );
      await snap(tester, 'duplicate');
    });
  });

  group('builder', () {
    Future<void> pumpStep(
      WidgetTester tester,
      BuilderStep step, {
      String? name,
    }) async {
      await pumpKalpi(
        tester,
        location: AppRoutes.builderStep(step.path),
        beforeNavigate: (app) => app.builder.startCreate(
          seed: name == null
              ? StrategyDraft.illustrative()
              : StrategyDraft.illustrative().copyWith(name: name),
        ),
      );
    }

    testWidgets('universe', (tester) async {
      await pumpStep(tester, BuilderStep.universe);
      await snap(tester, 'universe');
    });

    testWidgets('filters and rule editor', (tester) async {
      await pumpStep(tester, BuilderStep.filters);
      await snap(tester, 'filters');
      await tester.tap(find.text(AppStrings.addAnotherRule));
      await tester.pumpAndSettle();
      await snap(tester, 'rule');
      await tester.enterText(find.byType(TextField), '');
      await tester.tap(find.text(AppStrings.saveRule));
      await tester.pumpAndSettle();
      await snap(tester, 'rule_invalid');
    });

    testWidgets('ranking', (tester) async {
      await pumpStep(tester, BuilderStep.ranking);
      await snap(tester, 'ranking');
    });

    testWidgets('allocation', (tester) async {
      await pumpStep(tester, BuilderStep.allocation);
      await snap(tester, 'allocation');
    });

    testWidgets('review, required name and save recovery', (tester) async {
      await pumpStep(tester, BuilderStep.review, name: '');
      await tester.tap(find.text(AppStrings.saveStrategy));
      await tester.pumpAndSettle();
      await snap(tester, 'name_invalid');
      await tester.enterText(find.byType(TextField), 'Quality first');
      await tester.pumpAndSettle();
      await snap(tester, 'review');
    });

    testWidgets('save failure shows recovery', (tester) async {
      final app = await pumpKalpi(
        tester,
        location: AppRoutes.builderStep(BuilderStep.review.path),
        beforeNavigate: (app) =>
            app.builder.startCreate(seed: StrategyDraft.illustrative()),
      );
      app.repo.failNextWrite = true;
      await tester.tap(find.text(AppStrings.saveStrategy));
      await tester.pumpAndSettle();
      await snap(tester, 'error');
    });

    testWidgets('exit confirmation', (tester) async {
      await pumpStep(tester, BuilderStep.universe);
      await tester.tap(find.text(AppStrings.exit));
      await tester.pumpAndSettle();
      await snap(tester, 'exit');
    });

    testWidgets('custom universe and metric picker', (tester) async {
      await pumpKalpi(
        tester,
        location: AppRoutes.customUniverse,
        beforeNavigate: (app) =>
            app.builder.startCreate(seed: StrategyDraft.illustrative()),
      );
      await tester.tap(find.text('HDFCBANK'));
      await tester.tap(find.text('INFY'));
      await tester.tap(find.text('RELIANCE'));
      await tester.pumpAndSettle();
      await snap(tester, 'custom');
    });

    testWidgets('metric picker', (tester) async {
      await pumpKalpi(
        tester,
        location: AppRoutes.metricPicker,
        beforeNavigate: (app) =>
            app.builder.startCreate(seed: StrategyDraft.illustrative()),
      );
      await snap(tester, 'metrics');
    });

    testWidgets('edit flow', (tester) async {
      final strategy = _qualityFirst();
      await pumpKalpi(
        tester,
        location: AppRoutes.strategyEdit(strategy.id, BuilderStep.filters.path),
        strategies: <Strategy>[strategy],
        beforeNavigate: (app) => app.builder.startEdit(strategy),
      );
      await snap(tester, 'edit_filters');
      await tester.tap(find.text(AppStrings.reviewChanges));
      await tester.pumpAndSettle();
      await snap(tester, 'edit_review');
    });
  });

  group('learn and preferences', () {
    testWidgets('learn', (tester) async {
      await pumpKalpi(tester, location: AppRoutes.learn);
      await snap(tester, 'learn');
    });

    testWidgets('preferences', (tester) async {
      await pumpKalpi(tester, location: AppRoutes.preferences);
      await snap(tester, 'profile');
    });
  });
}
