import 'package:equatable/equatable.dart';

import 'experience_level.dart';
import 'investing_intent.dart';

/// Non-sensitive guidance preferences. Never affects suitability or risk.
class UserPreferences extends Equatable {
  const UserPreferences({
    this.experience,
    this.intent,
    this.onboardingComplete = false,
  });

  static const UserPreferences initial = UserPreferences();

  /// Defaults applied when onboarding is skipped.
  static const UserPreferences skippedDefaults = UserPreferences(
    experience: ExperienceLevel.gettingStarted,
    intent: InvestingIntent.build,
    onboardingComplete: true,
  );

  final ExperienceLevel? experience;
  final InvestingIntent? intent;
  final bool onboardingComplete;

  UserPreferences copyWith({
    ExperienceLevel? experience,
    InvestingIntent? intent,
    bool? onboardingComplete,
  }) => UserPreferences(
    experience: experience ?? this.experience,
    intent: intent ?? this.intent,
    onboardingComplete: onboardingComplete ?? this.onboardingComplete,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'experience': experience?.key,
    'intent': intent?.key,
    'onboardingComplete': onboardingComplete,
  };

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      UserPreferences(
        experience: ExperienceLevel.fromKey(json['experience'] as String?),
        intent: InvestingIntent.fromKey(json['intent'] as String?),
        onboardingComplete: json['onboardingComplete'] as bool? ?? false,
      );

  @override
  List<Object?> get props => <Object?>[experience, intent, onboardingComplete];
}
