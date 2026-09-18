/// Formats a number without trailing zeros: 15 → `15`, 6.6667 → `6.67`.
String formatCompactNumber(double value, {int maxFractionDigits = 2}) {
  if (value == value.roundToDouble()) return value.toInt().toString();
  final fixed = value.toStringAsFixed(maxFractionDigits);
  return fixed.replaceFirst(RegExp(r'\.?0+$'), '');
}

/// Formats a percentage such as 6.6667 → `6.67%`.
String formatPercent(double value, {int maxFractionDigits = 2}) =>
    '${formatCompactNumber(value, maxFractionDigits: maxFractionDigits)}%';

/// Pluralises a simple English noun: (1, 'rule') → `1 rule`.
String pluralise(int count, String singular, [String? plural]) =>
    '$count ${count == 1 ? singular : (plural ?? '${singular}s')}';
