import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaigin_pet/domain/core/result.dart';
import 'package:kaigin_pet/domain/entities/goal.dart';
import 'package:kaigin_pet/domain/use_cases/goal/add_custom_goal_use_case.dart';
import 'package:kaigin_pet/domain/use_cases/goal/complete_goal_use_case.dart';
import 'package:kaigin_pet/domain/use_cases/goal/get_goals_use_case.dart';
import 'package:kaigin_pet/domain/use_cases/goal/get_last_reset_date_use_case.dart';
import 'package:kaigin_pet/domain/use_cases/goal/get_lifetime_goals_use_case.dart';
import 'package:kaigin_pet/domain/use_cases/goal/increment_lifetime_goals_use_case.dart';
import 'package:kaigin_pet/domain/use_cases/goal/reset_daily_goals_use_case.dart';
import 'package:kaigin_pet/domain/use_cases/goal/save_goals_use_case.dart';
import 'package:kaigin_pet/presentation/features/goals/goals_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class GoalsCubit extends Cubit<GoalsState> {
  GoalsCubit(
    this._getGoals,
    this._completeGoal,
    this._addCustomGoal,
    this._resetDailyGoals,
    this._saveGoals,
    this._getLastResetDate,
    this._getLifetimeGoals,
    this._incrementLifetimeGoals,
  ) : super(const GoalsInitial());

  final GetGoalsUseCase _getGoals;
  final CompleteGoalUseCase _completeGoal;
  final AddCustomGoalUseCase _addCustomGoal;
  final ResetDailyGoalsUseCase _resetDailyGoals;
  final SaveGoalsUseCase _saveGoals;
  final GetLastResetDateUseCase _getLastResetDate;
  final GetLifetimeGoalsUseCase _getLifetimeGoals;
  final IncrementLifetimeGoalsUseCase _incrementLifetimeGoals;

  Future<void> load() async {
    emit(const GoalsLoading());
    final result = await _getGoals();
    if (result is Failure) {
      emit(const GoalsError('Failed to load goals'));
      return;
    }
    var goals = (result as Success<List<Goal>>).value;
    if (goals.isEmpty) {
      goals = defaultGoals();
      await _saveGoals(goals);
    } else {
      final dateResult = await _getLastResetDate();
      if (dateResult is Success<DateTime?>) {
        final lastReset = dateResult.value;
        if (_isNewDay(lastReset)) {
          final resetResult = await _resetDailyGoals(goals);
          if (resetResult is Success<List<Goal>>) {
            goals = resetResult.value;
          }
        }
      }
    }

    final lifetimeResult = await _getLifetimeGoals();
    final lifetime =
        lifetimeResult is Success<int> ? lifetimeResult.value : 0;

    emit(GoalsLoaded(goals: goals, lifetimeCompletedCount: lifetime));
  }

  bool _isNewDay(DateTime? lastReset) {
    if (lastReset == null) return true;
    final now = DateTime.now();
    return lastReset.year != now.year ||
        lastReset.month != now.month ||
        lastReset.day != now.day;
  }

  Future<int?> completeGoal(String goalId) async {
    final current = state;
    if (current is! GoalsLoaded) return null;

    final goal = current.goals.where((g) => g.id == goalId).firstOrNull;
    if (goal == null || goal.isCompleted) return null;

    final result = await _completeGoal(
      goals: current.goals,
      goalId: goalId,
    );
    if (result is Failure) return null;

    final updated = (result as Success<List<Goal>>).value;
    await _incrementLifetimeGoals(1);

    emit(current.copyWith(
      goals: updated,
      lifetimeCompletedCount: current.lifetimeCompletedCount + 1,
      lastCompletedGoalXp: goal.xpReward,
    ));
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

  void clearXpNotification() {
    final current = state;
    if (current is! GoalsLoaded) return;
    emit(current.copyWith(clearXp: true));
  }

  Future<void> resetForNewDay() async {
    final current = state;
    if (current is! GoalsLoaded) return;

    final result = await _resetDailyGoals(current.goals);
    if (result is Failure) return;

    final reset = (result as Success<List<Goal>>).value;
    emit(current.copyWith(goals: reset, clearXp: true));
  }
}
