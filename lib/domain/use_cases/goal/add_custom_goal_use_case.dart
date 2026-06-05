import 'package:kaigin_pet/domain/core/result.dart';
import 'package:kaigin_pet/domain/entities/goal.dart';
import 'package:kaigin_pet/domain/repositories/goal/goal_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddCustomGoalUseCase {
  AddCustomGoalUseCase(this._repository);

  final GoalRepository _repository;

  Future<Result<List<Goal>>> call({
    required List<Goal> currentGoals,
    required String title,
    required GoalCategory category,
  }) async {
    final newGoal = Goal(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      category: category,
      xpReward: 10,
      isCompleted: false,
      isDefault: false,
    );
    final updated = [...currentGoals, newGoal];
    return _repository.saveGoals(updated);
  }
}
