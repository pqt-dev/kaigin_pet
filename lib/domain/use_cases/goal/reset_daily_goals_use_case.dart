import 'package:kaigin_pet/domain/core/result.dart';
import 'package:kaigin_pet/domain/entities/goal.dart';
import 'package:kaigin_pet/domain/repositories/goal/goal_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ResetDailyGoalsUseCase {
  ResetDailyGoalsUseCase(this._repository);

  final GoalRepository _repository;

  Future<Result<List<Goal>>> call(List<Goal> goals) async {
    final reset = goals.map((g) => g.copyWith(isCompleted: false)).toList();
    final saveResult = await _repository.saveGoals(reset);
    if (saveResult is Failure) return saveResult;
    await _repository.setLastResetDate(DateTime.now());
    return saveResult;
  }
}
