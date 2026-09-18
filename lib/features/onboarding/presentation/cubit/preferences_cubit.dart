import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../strategies/data/demo_failure_switch.dart';
import '../../data/preferences_repository.dart';
import '../../domain/experience_level.dart';
import '../../domain/investing_intent.dart';
import '../../domain/user_preferences.dart';

part 'preferences_state.dart';

/// Owns onboarding progress and guidance preferences.
class PreferencesCubit extends Cubit<PreferencesState> {
  PreferencesCubit(this._repository, {DemoFailureSwitch? failureSwitch})
    : _failureSwitch = failureSwitch,
      super(const PreferencesState()) {
    _failureSwitch?.addListener(_syncFailureSwitch);
  }

  final PreferencesRepository _repository;
  final DemoFailureSwitch? _failureSwitch;

  Future<void> load() async {
    final prefs = await _repository.load();
    emit(state.copyWith(status: PreferencesStatus.ready, preferences: prefs));
  }

  Future<void> setExperience(ExperienceLevel level) =>
      _persist(state.preferences.copyWith(experience: level));

  Future<void> setIntent(InvestingIntent intent) =>
      _persist(state.preferences.copyWith(intent: intent));

  /// Marks onboarding done, filling any unset values with defaults.
  Future<void> completeOnboarding() => _persist(
    state.preferences.copyWith(
      experience:
          state.preferences.experience ??
          UserPreferences.skippedDefaults.experience,
      intent:
          state.preferences.intent ?? UserPreferences.skippedDefaults.intent,
      onboardingComplete: true,
    ),
  );

  /// Skip accepts defaults and opens the true empty/list state.
  Future<void> skipOnboarding() => completeOnboarding();

  void setSimulateSaveFailure(bool value) {
    _failureSwitch?.arm(value);
    emit(state.copyWith(simulateSaveFailure: value));
  }

  void _syncFailureSwitch() {
    final armed = _failureSwitch?.isArmed ?? false;
    if (armed != state.simulateSaveFailure) {
      emit(state.copyWith(simulateSaveFailure: armed));
    }
  }

  Future<void> _persist(UserPreferences next) async {
    emit(state.copyWith(preferences: next));
    await _repository.save(next);
  }

  @override
  Future<void> close() {
    _failureSwitch?.removeListener(_syncFailureSwitch);
    return super.close();
  }
}
