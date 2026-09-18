import '../../../core/constants/app_config.dart';
import '../../../core/constants/app_strings.dart';
import 'metric.dart';
import 'rule.dart';
import 'rule_operator.dart';
import 'stock_universe.dart';
import 'strategy_draft.dart';

/// Pure validation helpers shared by cubits and forms.
abstract final class StrategyValidation {
  /// Returns an error message, or null when the name is acceptable.
  static String? validateName(String raw) {
    final trimmed = raw.trim();
    if (trimmed.length < AppConfig.nameMinLength) {
      return AppStrings.nameRequiredError;
    }
    if (trimmed.length > AppConfig.nameMaxLength) {
      return AppStrings.nameTooLongError;
    }
    return null;
  }

  /// Parses and validates a rule value typed by the user.
  static RuleValueResult parseRuleValue(
    Metric metric,
    RuleOperator operator,
    String raw,
  ) {
    final cleaned = raw.trim().replaceAll(',', '');
    if (cleaned.isEmpty) {
      final needsPositive =
          metric.unit == MetricUnit.percent &&
          (operator == RuleOperator.gt || operator == RuleOperator.gte);
      return RuleValueResult.invalid(
        needsPositive
            ? AppStrings.ruleValuePositiveError
            : AppStrings.ruleValueRequiredError,
      );
    }
    final parsed = double.tryParse(cleaned);
    if (parsed == null || parsed.isNaN || parsed.isInfinite) {
      return const RuleValueResult.invalid(AppStrings.ruleValueNumberError);
    }
    switch (metric.unit) {
      case MetricUnit.percent:
        if (parsed <= 0 &&
            (operator == RuleOperator.gt || operator == RuleOperator.gte)) {
          return const RuleValueResult.invalid(
            AppStrings.ruleValuePositiveError,
          );
        }
        if (parsed < -100 || parsed > 1000) {
          return const RuleValueResult.invalid(
            AppStrings.ruleValuePercentRangeError,
          );
        }
      case MetricUnit.ratio:
      case MetricUnit.multiple:
        if (parsed < 0) {
          return const RuleValueResult.invalid(
            AppStrings.ruleValueNonNegativeError,
          );
        }
        if (parsed == 0 && (operator == RuleOperator.lt)) {
          return const RuleValueResult.invalid(
            AppStrings.ruleValuePositiveError,
          );
        }
        if (parsed > 10000) {
          return const RuleValueResult.invalid(
            AppStrings.ruleValueTooLargeError,
          );
        }
    }
    return RuleValueResult.valid(parsed);
  }

  /// True when an identical condition already exists under a different id.
  static bool isDuplicateRule(List<Rule> rules, Rule candidate) =>
      rules.any(candidate.isSameConditionAs);

  /// Returns an error when the ranking count cannot be satisfied by the
  /// universe, or null when it is fine.
  static String? validateHoldingCount(int count, StockUniverse universe) {
    if (count <= 0) return AppStrings.holdingsPositiveError;
    if (universe.stockCount > 0 && count > universe.stockCount) {
      return AppStrings.holdingsExceedUniverseError(universe.stockCount);
    }
    return null;
  }

  static String? validateCustomUniverse(CustomUniverse universe) =>
      universe.symbols.isEmpty ? AppStrings.customUniverseEmptyError : null;

  /// Validates the whole draft before saving. Returns the first error found
  /// as a (field, message) pair, or null when the draft can be saved.
  static DraftError? validateForSave(StrategyDraft draft) {
    final nameError = validateName(draft.name);
    if (nameError != null) return DraftError(DraftField.name, nameError);
    final universe = draft.universe;
    if (universe is CustomUniverse) {
      final e = validateCustomUniverse(universe);
      if (e != null) return DraftError(DraftField.universe, e);
    }
    final holdingsError = validateHoldingCount(draft.ranking.count, universe);
    if (holdingsError != null) {
      return DraftError(DraftField.ranking, holdingsError);
    }
    return null;
  }
}

enum DraftField { name, universe, filters, ranking, allocation }

class DraftError {
  const DraftError(this.field, this.message);

  final DraftField field;
  final String message;
}

class RuleValueResult {
  const RuleValueResult.valid(this.value) : error = null;
  const RuleValueResult.invalid(this.error) : value = null;

  final double? value;
  final String? error;

  bool get isValid => error == null;
}
