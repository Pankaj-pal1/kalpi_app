import 'package:flutter/widgets.dart';

import '../../../core/theme/kalpi_icons.dart';

/// What the user wants to do first. Adjusts the landing route and copy only.
enum InvestingIntent {
  build(
    key: 'build',
    title: 'Build a repeatable approach',
    description: 'Turn my ideas into investing rules.',
    summary: 'Build a repeatable approach',
    icon: KalpiIcons.rules,
  ),
  learn(
    key: 'learn',
    title: 'Understand strategy building',
    description: 'Learn by exploring an example.',
    summary: 'Learn strategy building',
    icon: KalpiIcons.book,
  ),
  organise(
    key: 'organise',
    title: 'Organise my ideas',
    description: 'Keep my strategies in one place.',
    summary: 'Organise my ideas',
    icon: KalpiIcons.stack,
  );

  const InvestingIntent({
    required this.key,
    required this.title,
    required this.description,
    required this.summary,
    required this.icon,
  });

  final String key;
  final String title;
  final String description;
  final String summary;
  final IconData icon;

  static InvestingIntent? fromKey(String? key) {
    for (final intent in InvestingIntent.values) {
      if (intent.key == key) return intent;
    }
    return null;
  }
}
