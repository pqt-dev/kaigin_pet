import 'package:injectable/injectable.dart';
import 'package:kaigin_pet/domain/core/result.dart';
import 'package:kaigin_pet/domain/entities/goal.dart';
import 'package:kaigin_pet/domain/repositories/goal/goal_repository.dart';

@injectable
class SaveGoalsUseCase {
  SaveGoalsUseCase(this._repository);

  final GoalRepository _repository;

  Future<Result<List<Goal>>> call(List<Goal> goals) =>
      _repository.saveGoals(goals);
}
