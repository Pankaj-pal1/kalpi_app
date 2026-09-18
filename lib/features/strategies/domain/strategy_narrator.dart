import 'allocation_mode.dart';
import 'metric.dart';
import 'ranking.dart';
import 'rule.dart';
import 'rule_operator.dart';
import 'strategy_draft.dart';

/// Turns a draft into the plain-English sentences shown in banners and the
/// detail header. Everything here is derived from data, never hardcoded.
abstract final class StrategyNarrator {
  /// e.g. `Profitable companies with less debt.`
  static String rulesSentence(List<Rule> rules) {
    if (rules.isEmpty) {
      return 'Every stock in your universe moves on to ranking.';
    }
    final phrases = rules.map((r) => _rulePhrase(r, banner: true)).toList();
    final first = _capitalise(phrases.first);
    if (phrases.length == 1) return '$first.';
    return '$first with ${_joinNatural(phrases.sublist(1))}.';
  }

  /// e.g. `Profitable companies, lower debt, and an equal share for every stock.`
  static String description(StrategyDraft draft) {
    final parts = <String>[
      ...draft.rules.map(_rulePhrase),
      _allocationPhrase(draft.allocation),
    ];
    return '${_capitalise(_joinNatural(parts, oxford: true))}.';
  }

  /// e.g. `Filter for quality, then prioritise the most profitable companies.`
  static String logicSoFar(StrategyDraft draft) {
    final categories = draft.rules
        .map((r) => r.metric.category.label.toLowerCase())
        .toSet();
    final priority = _rankingPhrase(draft.ranking);
    if (categories.isEmpty) {
      return 'Take every stock in ${draft.universe.label}, then prioritise $priority.';
    }
    return 'Filter for ${_joinNatural(categories.toList())}, then prioritise $priority.';
  }

  /// e.g. `Nifty 500 · 2 rules · 15 stocks`
  static String compactSummary(StrategyDraft draft) {
    final rules = draft.rules.length;
    return '${draft.universe.summaryLabel} · $rules ${rules == 1 ? 'rule' : 'rules'} · '
        '${draft.ranking.count} stocks';
  }

  /// Word used in "Edit … rule" sheet titles.
  static String ruleWord(Metric metric) => switch (metric) {
    Metric.roe => 'profitability',
    Metric.debtToEquity => 'debt',
    Metric.pe => 'valuation',
    Metric.momentum12m => 'momentum',
  };

  static String _rulePhrase(Rule rule, {bool banner = false}) {
    final upward =
        rule.operator == RuleOperator.gt || rule.operator == RuleOperator.gte;
    switch (rule.metric) {
      case Metric.roe:
        return upward ? 'profitable companies' : 'lower-return companies';
      case Metric.debtToEquity:
        if (upward) return 'more leverage';
        return banner ? 'less debt' : 'lower debt';
      case Metric.pe:
        return upward ? 'richer valuations' : 'reasonable valuations';
      case Metric.momentum12m:
        return upward ? 'rising prices' : 'falling prices';
    }
  }

  static String _allocationPhrase(AllocationMode mode) => switch (mode) {
    AllocationMode.equal => 'an equal share for every stock',
    AllocationMode.marketCap => 'larger shares for larger companies',
  };

  static String _rankingPhrase(Ranking ranking) {
    final highest = ranking.direction == RankDirection.desc;
    return switch (ranking.metric) {
      Metric.roe =>
        highest
            ? 'the most profitable companies'
            : 'the least profitable companies',
      Metric.debtToEquity =>
        highest
            ? 'the most leveraged companies'
            : 'the least indebted companies',
      Metric.pe =>
        highest ? 'the most expensive companies' : 'the cheapest companies',
      Metric.momentum12m =>
        highest ? 'the strongest price momentum' : 'the weakest price momentum',
    };
  }

  static String _joinNatural(List<String> items, {bool oxford = false}) {
    if (items.isEmpty) return '';
    if (items.length == 1) return items.first;
    if (items.length == 2) return '${items[0]} and ${items[1]}';
    final head = items.sublist(0, items.length - 1).join(', ');
    return '$head${oxford ? ',' : ''} and ${items.last}';
  }

  static String _capitalise(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}
