import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_storage_keys.dart';
import '../domain/user_preferences.dart';

/// Persists guidance preferences.
abstract interface class PreferencesRepository {
  Future<UserPreferences> load();
  Future<void> save(UserPreferences preferences);
}

/// Stores preferences in the platform key-value store. Device-local only.
class LocalPreferencesRepository implements PreferencesRepository {
  LocalPreferencesRepository(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<UserPreferences> load() async {
    final raw = _prefs.getString(AppStorageKeys.preferences);
    if (raw == null || raw.isEmpty) return UserPreferences.initial;
    try {
      return UserPreferences.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on FormatException {
      return UserPreferences.initial;
    }
  }

  @override
  Future<void> save(UserPreferences preferences) => _prefs.setString(
    AppStorageKeys.preferences,
    jsonEncode(preferences.toJson()),
  );
}
