// End-to-end journey on a real device or emulator:
// onboarding → build → save → list → detail → edit → save changes →
// duplicate → delete → empty state.
//
// Run:  flutter test integration_test -d <device-id>

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kalpi_app/app/di/app_dependencies.dart';
import 'package:kalpi_app/app/kalpi_app.dart';
import 'package:kalpi_app/core/constants/app_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _settle(WidgetTester tester) async {
  // The list cubit and repository use short simulated delays.
  await tester.pumpAndSettle(const Duration(milliseconds: 100));
}

/// Polls until [text] appears; banners are transient so a fixed wait races.
Future<void> _waitForText(
  WidgetTester tester,
  String text, {
  Duration timeout = const Duration(seconds: 8),
}) async {
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 100));
    if (find.text(text).evaluate().isNotEmpty) return;
  }
  fail('Timed out waiting for "$text"');
}

Future<void> _tapText(WidgetTester tester, String text) async {
  final finder = find.text(text);
  expect(finder, findsWidgets, reason: 'expected "$text" on screen');
  await tester.ensureVisible(finder.first);
  await tester.tap(finder.first);
  await _settle(tester);
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('full strategy lifecycle', (tester) async {
    // Start from a clean install.
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final deps = await AppDependencies.create();
    await tester.pumpWidget(KalpiApp(dependencies: deps));
    await _settle(tester);

    // Onboarding.
    expect(find.text(AppStrings.welcomeCta), findsOneWidget);
    await _tapText(tester, AppStrings.welcomeCta);
    expect(find.text(AppStrings.experienceTopBar), findsOneWidget);
    await _tapText(tester, 'I invest sometimes');
    await _tapText(tester, AppStrings.continueLabel);
    expect(find.text(AppStrings.intentTopBar), findsOneWidget);
    await _tapText(tester, AppStrings.intentCta);

    // Empty state → builder with the illustrative example.
    expect(find.text(AppStrings.emptyTitle), findsOneWidget);
    await _tapText(tester, AppStrings.emptyCta);
    expect(find.text(AppStrings.buildStepTitle(1, 4)), findsOneWidget);
    await _tapText(tester, 'Nifty 50');
    await _tapText(tester, AppStrings.continueToFilters);

    // Filters: add a third rule through the sheet.
    expect(find.text(AppStrings.buildStepTitle(2, 4)), findsOneWidget);
    await _tapText(tester, AppStrings.addAnotherRule);
    expect(find.text(AppStrings.addRuleTitle), findsOneWidget);
    await tester.enterText(find.byType(TextField).last, '25');
    await _tapText(tester, AppStrings.saveRule);
    expect(find.text('Return on equity > 25%'), findsOneWidget);
    await _tapText(tester, AppStrings.continueToRanking);

    // Ranking and allocation.
    expect(find.text(AppStrings.buildStepTitle(3, 4)), findsOneWidget);
    await _tapText(tester, '10');
    await _tapText(tester, AppStrings.continueToAllocation);
    expect(find.text(AppStrings.buildStepTitle(4, 4)), findsOneWidget);
    await _tapText(tester, AppStrings.reviewMyStrategy);

    // Review: blank name is rejected inline, then save succeeds.
    expect(find.text(AppStrings.reviewTopBar), findsOneWidget);
    await tester.enterText(find.byType(TextField), '');
    await _tapText(tester, AppStrings.saveStrategy);
    expect(find.text(AppStrings.nameRequiredError), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Lifecycle test');
    await _tapText(tester, AppStrings.saveStrategy);
    await _waitForText(tester, AppStrings.savedBanner('Lifecycle test'));
    await _settle(tester);
    expect(find.text('Lifecycle test'), findsWidgets);

    // Detail → edit → save changes.
    await _tapText(tester, AppStrings.viewStrategy);
    expect(find.text(AppStrings.rulesBehindIt), findsOneWidget);
    expect(find.text('Top 10 by ROE'), findsOneWidget);
    await _tapText(tester, AppStrings.editStrategy);
    expect(
      find.text(AppStrings.editStepTitle('Lifecycle test')),
      findsOneWidget,
    );
    await _tapText(tester, AppStrings.reviewChanges);
    await tester.enterText(find.byType(TextField), 'Lifecycle test v2');
    await _tapText(tester, AppStrings.saveChanges);
    await _waitForText(tester, AppStrings.changesSavedBanner);
    await _settle(tester);
    expect(find.text('Lifecycle test v2'), findsWidgets);

    // Duplicate via the card's More action.
    await tester.tap(
      find.bySemanticsLabel(RegExp('^${AppStrings.moreActions}')).first,
    );
    await _settle(tester);
    await _tapText(tester, AppStrings.duplicateStrategy);
    expect(find.text(AppStrings.newStrategyName), findsOneWidget);
    await _tapText(tester, AppStrings.createCopy);
    await _waitForText(tester, AppStrings.copyCreatedBanner);
    await _settle(tester);
    expect(find.text('Lifecycle test v2 — copy'), findsOneWidget);

    // Delete both, ending in the true empty state.
    for (final name in <String>[
      'Lifecycle test v2 — copy',
      'Lifecycle test v2',
    ]) {
      await tester.tap(
        find.bySemanticsLabel('${AppStrings.moreActions} for $name'),
      );
      await _settle(tester);
      await _tapText(tester, AppStrings.deleteStrategy);
      expect(find.text(AppStrings.deleteTitle(name)), findsOneWidget);
      await _tapText(tester, AppStrings.deleteStrategy);
      await _waitForText(tester, AppStrings.deletedBanner(name));
      await _settle(tester);
    }
    expect(find.text(AppStrings.emptyTitle), findsOneWidget);
  });
}
