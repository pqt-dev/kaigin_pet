import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/core/app_theme_mode.dart';
import '../../domain/use_cases/theme/theme_use_case.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final ThemeUseCase _themeUseCase;

  ThemeCubit(this._themeUseCase) : super(ThemeMode.system);

  Future<void> loadTheme() async {
    final appThemeMode = await _themeUseCase.fetch();
    emit(_toThemeMode(appThemeMode));
  }

  Future<void> setTheme(ThemeMode theme) async {
    final appThemeMode = _toAppThemeMode(theme);
    await _themeUseCase.save(appThemeMode);
    emit(theme);
  }

  ThemeMode _toThemeMode(AppThemeMode mode) {
    return switch (mode) {
      AppThemeMode.light => ThemeMode.light,
      AppThemeMode.dark => ThemeMode.dark,
      AppThemeMode.system => ThemeMode.system,
    };
  }

  AppThemeMode _toAppThemeMode(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.light => AppThemeMode.light,
      ThemeMode.dark => AppThemeMode.dark,
      ThemeMode.system => AppThemeMode.system,
    };
  }
}
