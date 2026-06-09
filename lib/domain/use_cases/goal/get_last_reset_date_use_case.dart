import 'package:injectable/injectable.dart';
import 'package:kaigin_pet/domain/core/result.dart';
import 'package:kaigin_pet/domain/repositories/goal/goal_repository.dart';

@injectable
class GetLastResetDateUseCase {
  GetLastResetDateUseCase(this._repository);

  final GoalRepository _repository;

  Future<Result<DateTime?>> call() => _repository.getLastResetDate();
}
