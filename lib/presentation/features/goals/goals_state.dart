import 'package:kaigin_pet/domain/entities/goal.dart';

sealed class GoalsState {
  const GoalsState();
}

final class GoalsInitial extends GoalsState {
  const GoalsInitial();
}

final class GoalsLoading extends GoalsState {
  const GoalsLoading();
}

final class GoalsLoaded extends GoalsState {
  const GoalsLoaded({
    required this.goals,
    required this.lifetimeCompletedCount,
    this.lastCompletedGoalXp,
  });

  final List<Goal> goals;
  final int lifetimeCompletedCount;
  final int? lastCompletedGoalXp;

  int get completedCount => goals.where((g) => g.isCompleted).length;
  int get totalCount => goals.length;
  bool get allDone => totalCount > 0 && completedCount == totalCount;

  List<Goal> get healthGoals =>
      goals.where((g) => g.category == GoalCategory.health).toList();
  List<Goal> get mindGoals =>
      goals.where((g) => g.category == GoalCategory.mind).toList();
  List<Goal> get socialGoals =>
      goals.where((g) => g.category == GoalCategory.social).toList();
  List<Goal> get creativeGoals =>
      goals.where((g) => g.category == GoalCategory.creative).toList();
  List<Goal> get learningGoals =>
      goals.where((g) => g.category == GoalCategory.learning).toList();

  GoalsLoaded copyWith({
    List<Goal>? goals,
    int? lifetimeCompletedCount,
    int? lastCompletedGoalXp,
    bool clearXp = false,
  }) {
    return GoalsLoaded(
      goals: goals ?? this.goals,
      lifetimeCompletedCount:
          lifetimeCompletedCount ?? this.lifetimeCompletedCount,
      lastCompletedGoalXp:
          clearXp ? null : (lastCompletedGoalXp ?? this.lastCompletedGoalXp),
    );
  }
}

final class GoalsError extends GoalsState {
  const GoalsError(this.message);

  final String message;
}
