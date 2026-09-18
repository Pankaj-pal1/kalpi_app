part of 'preferences_cubit.dart';

enum PreferencesStatus { loading, ready }

class PreferencesState extends Equatable {
  const PreferencesState({
    this.status = PreferencesStatus.loading,
    this.preferences = UserPreferences.initial,
    this.simulateSaveFailure = false,
  });

  final PreferencesStatus status;
  final UserPreferences preferences;

  /// Demo-only: arms a one-shot failure for the next write.
  final bool simulateSaveFailure;

  bool get isReady => status == PreferencesStatus.ready;
  bool get onboardingComplete => preferences.onboardingComplete;
  ExperienceLevel? get experience => preferences.experience;
  InvestingIntent? get intent => preferences.intent;

  PreferencesState copyWith({
    PreferencesStatus? status,
    UserPreferences? preferences,
    bool? simulateSaveFailure,
  }) => PreferencesState(
    status: status ?? this.status,
    preferences: preferences ?? this.preferences,
    simulateSaveFailure: simulateSaveFailure ?? this.simulateSaveFailure,
  );

  @override
  List<Object?> get props => <Object?>[
    status,
    preferences,
    simulateSaveFailure,
  ];
}
