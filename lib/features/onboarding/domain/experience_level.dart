import 'package:flutter/widgets.dart';

import '../../../core/theme/kalpi_icons.dart';

/// How much investing experience the user reports. Adjusts explanations only.
enum ExperienceLevel {
  gettingStarted(
    key: 'getting-started',
    title: 'I’m getting started',
    description: 'Help me learn the basics.',
    summary: 'Getting started',
    icon: KalpiIcons.leaf,
  ),
  occasional(
    key: 'occasional',
    title: 'I invest sometimes',
    description: 'I know stocks, but rules are new.',
    summary: 'Occasional investor',
    icon: KalpiIcons.chart,
  ),
  experienced(
    key: 'experienced',
    title: 'I build my own strategies',
    description: 'Let me get straight to the details.',
    summary: 'Experienced investor',
    icon: KalpiIcons.rules,
  );

  const ExperienceLevel({
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

  static ExperienceLevel? fromKey(String? key) {
    for (final level in ExperienceLevel.values) {
      if (level.key == key) return level;
    }
    return null;
  }
}
