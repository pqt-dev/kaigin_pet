import 'package:kaigin_pet/domain/core/app_theme_mode.dart';
import 'package:kaigin_pet/domain/repositories/theme/theme_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ThemeUseCase {
  final ThemeRepository repository;

  ThemeUseCase(this.repository);

  Future<AppThemeMode> fetch() async {
    return repository.fetch();
  }

  Future<void> save(AppThemeMode theme) async {
    return repository.save(theme);
  }
}
