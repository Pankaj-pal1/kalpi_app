/// Comparison applied by a rule.
enum RuleOperator {
  gt('gt', 'Greater than', '>'),
  gte('gte', 'At least', '≥'),
  lt('lt', 'Less than', '<'),
  lte('lte', 'At most', '≤');

  const RuleOperator(this.key, this.label, this.symbol);

  final String key;
  final String label;
  final String symbol;

  static RuleOperator fromKey(String key) => RuleOperator.values.firstWhere(
    (o) => o.key == key,
    orElse: () => RuleOperator.gt,
  );
}
