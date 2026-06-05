import 'package:kaigin_pet/domain/core/app_theme_mode.dart';

abstract class ThemeRepository {
  Future<void> save(AppThemeMode theme);

  Future<AppThemeMode> fetch();
}
