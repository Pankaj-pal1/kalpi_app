import 'package:flutter_test/flutter_test.dart';
import 'package:kalpi_app/core/constants/app_strings.dart';
import 'package:kalpi_app/features/strategies/domain/metric.dart';
import 'package:kalpi_app/features/strategies/domain/rule.dart';
import 'package:kalpi_app/features/strategies/domain/rule_operator.dart';
import 'package:kalpi_app/features/strategies/domain/stock_universe.dart';
import 'package:kalpi_app/features/strategies/domain/strategy_draft.dart';
import 'package:kalpi_app/features/strategies/domain/strategy_validation.dart';

void main() {
  group('validateName', () {
    test('rejects empty and whitespace-only names', () {
      expect(StrategyValidation.validateName(''), AppStrings.nameRequiredError);
      expect(
        StrategyValidation.validateName('   '),
        AppStrings.nameRequiredError,
      );
    });

    test('rejects names over 60 characters after trimming', () {
      expect(
        StrategyValidation.validateName('a' * 61),
        AppStrings.nameTooLongError,
      );
      expect(StrategyValidation.validateName('  ${'a' * 60}  '), isNull);
    });

    test('accepts a normal name', () {
      expect(StrategyValidation.validateName('Quality first'), isNull);
    });
  });

  group('parseRuleValue', () {
    test('parses percentages and strips thousands separators', () {
      final r = StrategyValidation.parseRuleValue(
        Metric.roe,
        RuleOperator.gt,
        '15',
      );
      expect(r.isValid, isTrue);
      expect(r.value, 15);
      expect(
        StrategyValidation.parseRuleValue(
          Metric.roe,
          RuleOperator.lt,
          '1,000',
        ).value,
        1000,
      );
    });

    test('rejects empty, malformed and non-finite input', () {
      expect(
        StrategyValidation.parseRuleValue(
          Metric.roe,
          RuleOperator.gt,
          '',
        ).error,
        AppStrings.ruleValuePositiveError,
      );
      expect(
        StrategyValidation.parseRuleValue(
          Metric.debtToEquity,
          RuleOperator.lt,
          '',
        ).error,
        AppStrings.ruleValueRequiredError,
      );
      expect(
        StrategyValidation.parseRuleValue(
          Metric.roe,
          RuleOperator.gt,
          'abc',
        ).error,
        AppStrings.ruleValueNumberError,
      );
      expect(
        StrategyValidation.parseRuleValue(
          Metric.roe,
          RuleOperator.gt,
          'NaN',
        ).error,
        AppStrings.ruleValueNumberError,
      );
    });

    test('percent thresholds with greater-than must be positive', () {
      expect(
        StrategyValidation.parseRuleValue(
          Metric.roe,
          RuleOperator.gt,
          '0',
        ).error,
        AppStrings.ruleValuePositiveError,
      );
      expect(
        StrategyValidation.parseRuleValue(
          Metric.roe,
          RuleOperator.gt,
          '-5',
        ).error,
        AppStrings.ruleValuePositiveError,
      );
    });

    test('ratios are validated as ratios, not percentages', () {
      expect(
        StrategyValidation.parseRuleValue(
          Metric.debtToEquity,
          RuleOperator.lt,
          '1',
        ).value,
        1,
      );
      expect(
        StrategyValidation.parseRuleValue(
          Metric.debtToEquity,
          RuleOperator.lt,
          '0.5',
        ).value,
        0.5,
      );
      expect(
        StrategyValidation.parseRuleValue(
          Metric.debtToEquity,
          RuleOperator.lt,
          '-1',
        ).error,
        AppStrings.ruleValueNonNegativeError,
      );
      expect(
        StrategyValidation.parseRuleValue(
          Metric.debtToEquity,
          RuleOperator.lt,
          '0',
        ).error,
        AppStrings.ruleValuePositiveError,
      );
    });
  });

  group('duplicate rules', () {
    const roe = Rule(
      id: 'a',
      metric: Metric.roe,
      operator: RuleOperator.gt,
      value: 15,
    );

    test('same condition under another id is a duplicate', () {
      const candidate = Rule(
        id: 'b',
        metric: Metric.roe,
        operator: RuleOperator.gt,
        value: 15,
      );
      expect(
        StrategyValidation.isDuplicateRule(<Rule>[roe], candidate),
        isTrue,
      );
    });

    test('editing the same rule id is not a duplicate', () {
      expect(StrategyValidation.isDuplicateRule(<Rule>[roe], roe), isFalse);
    });

    test('a different value is not a duplicate', () {
      const candidate = Rule(
        id: 'b',
        metric: Metric.roe,
        operator: RuleOperator.gt,
        value: 20,
      );
      expect(
        StrategyValidation.isDuplicateRule(<Rule>[roe], candidate),
        isFalse,
      );
    });
  });

  group('holding count', () {
    test('cannot exceed a custom universe', () {
      const universe = CustomUniverse(<String>['A', 'B', 'C']);
      expect(
        StrategyValidation.validateHoldingCount(15, universe),
        AppStrings.holdingsExceedUniverseError(3),
      );
      expect(StrategyValidation.validateHoldingCount(3, universe), isNull);
    });

    test('must be positive', () {
      expect(
        StrategyValidation.validateHoldingCount(
          0,
          const IndexUniverse(MarketIndex.nifty50),
        ),
        AppStrings.holdingsPositiveError,
      );
    });
  });

  group('validateForSave', () {
    test('reports the name first', () {
      final error = StrategyValidation.validateForSave(StrategyDraft.blank());
      expect(error?.field, DraftField.name);
    });

    test('rejects an empty custom universe', () {
      final draft = StrategyDraft.illustrative().copyWith(
        universe: const CustomUniverse(<String>[]),
      );
      expect(
        StrategyValidation.validateForSave(draft)?.field,
        DraftField.universe,
      );
    });

    test('accepts the illustrative draft', () {
      expect(
        StrategyValidation.validateForSave(StrategyDraft.illustrative()),
        isNull,
      );
    });
  });

  group('Rule formatting', () {
    test('formats percent and ratio values', () {
      const roe = Rule(
        id: 'a',
        metric: Metric.roe,
        operator: RuleOperator.gt,
        value: 15,
      );
      const de = Rule(
        id: 'b',
        metric: Metric.debtToEquity,
        operator: RuleOperator.lt,
        value: 1,
      );
      expect(roe.title, 'Return on equity > 15%');
      expect(roe.shortSummary, 'ROE > 15%');
      expect(de.title, 'Debt-to-equity < 1');
      expect(de.shortSummary, 'D/E < 1');
    });
  });
}
