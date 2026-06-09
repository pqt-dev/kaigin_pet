import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaigin_pet/core/constants/storage_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final SharedPreferences _prefs;

  ThemeCubit(this._prefs) : super(ThemeMode.system);

  Future<void> loadTheme() async {
    final saved = _prefs.getString(StorageKeys.themeModeKey);
    final mode = switch (saved) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    emit(mode);
  }

  Future<void> setTheme(ThemeMode theme) async {
    final name = switch (theme) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await _prefs.setString(StorageKeys.themeModeKey, name);
    emit(theme);
  }
}
