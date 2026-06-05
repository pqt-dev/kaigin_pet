import 'package:kaigin_pet/domain/core/result.dart';
import 'package:kaigin_pet/domain/entities/goal.dart';
import 'package:kaigin_pet/domain/repositories/goal/goal_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class CompleteGoalUseCase {
  CompleteGoalUseCase(this._repository);

  final GoalRepository _repository;

  Future<Result<List<Goal>>> call({
    required List<Goal> goals,
    required String goalId,
  }) async {
    final updated = goals.map((g) {
      return g.id == goalId ? g.copyWith(isCompleted: true) : g;
    }).toList();
    return _repository.saveGoals(updated);
  }
}
