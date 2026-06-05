import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaigin_pet/domain/core/result.dart';
import 'package:kaigin_pet/domain/entities/goal.dart';
import 'package:kaigin_pet/domain/use_cases/goal/add_custom_goal_use_case.dart';
import 'package:kaigin_pet/domain/use_cases/goal/complete_goal_use_case.dart';
import 'package:kaigin_pet/domain/use_cases/goal/get_goals_use_case.dart';
import 'package:kaigin_pet/domain/use_cases/goal/reset_daily_goals_use_case.dart';
import 'package:kaigin_pet/presentation/features/goals/goals_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class GoalsCubit extends Cubit<GoalsState> {
  GoalsCubit(
    this._getGoals,
    this._completeGoal,
    this._addCustomGoal,
    this._resetDailyGoals,
  ) : super(const GoalsInitial());

  final GetGoalsUseCase _getGoals;
  final CompleteGoalUseCase _completeGoal;
  final AddCustomGoalUseCase _addCustomGoal;
  final ResetDailyGoalsUseCase _resetDailyGoals;

  Future<void> load() async {
    emit(const GoalsLoading());
    final result = await _getGoals();
    if (result is Failure) {
      emit(const GoalsError('Failed to load goals'));
      return;
    }
    var goals = (result as Success<List<Goal>>).value;
    if (goals.isEmpty) {
      // First launch: seed with defaults
      goals = defaultGoals();
      await _saveGoals(goals);
    }
    emit(GoalsLoaded(goals: goals));
  }

  Future<int?> completeGoal(String goalId) async {
    final current = state;
    if (current is! GoalsLoaded) return null;

    final goal = current.goals.firstWhere((g) => g.id == goalId,
        orElse: () => current.goals.first);
    if (goal.isCompleted) return null;

    final result = await _completeGoal(
      goals: current.goals,
      goalId: goalId,
    );
    if (result is Failure) return null;

    final updated = (result as Success<List<Goal>>).value;
    emit(current.copyWith(goals: updated, lastCompletedGoalXp: goal.xpReward));
    return goal.xpReward;
  }

  Future<void> addCustomGoal(String title, GoalCategory category) async {
    final current = state;
    if (current is! GoalsLoaded) return;

    final result = await _addCustomGoal(
      currentGoals: current.goals,
      title: title,
      category: category,
    );
    if (result is Failure) return;

    final updated = (result as Success<List<Goal>>).value;
    emit(current.copyWith(goals: updated));
  }

  Future<void> resetForNewDay() async {
    final current = state;
    if (current is! GoalsLoaded) return;

    final result = await _resetDailyGoals(current.goals);
    if (result is Failure) return;

    final reset = (result as Success<List<Goal>>).value;
    emit(current.copyWith(goals: reset, lastCompletedGoalXp: null));
  }

  Future<void> _saveGoals(List<Goal> goals) async {
    // Use completeGoal flow to persist — actually directly call resetDailyGoals
    // to seed: reset on empty list gives us the defaults.
    // Simpler: just call completeGoal with no-op.
    // Actually we need to just save the default goals via the complete flow.
    // Use resetDailyGoals on defaultGoals (already uncompleted).
    await _resetDailyGoals(goals);
  }
}
