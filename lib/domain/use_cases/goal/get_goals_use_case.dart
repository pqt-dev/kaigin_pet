import 'package:kaigin_pet/domain/core/result.dart';
import 'package:kaigin_pet/domain/entities/goal.dart';
import 'package:kaigin_pet/domain/repositories/goal/goal_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetGoalsUseCase {
  GetGoalsUseCase(this._repository);

  final GoalRepository _repository;

  Future<Result<List<Goal>>> call() => _repository.getGoals();
}
