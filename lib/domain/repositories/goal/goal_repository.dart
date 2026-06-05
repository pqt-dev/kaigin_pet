import 'package:kaigin_pet/domain/core/result.dart';
import 'package:kaigin_pet/domain/entities/goal.dart';

abstract interface class GoalRepository {
  Future<Result<List<Goal>>> getGoals();
  Future<Result<List<Goal>>> saveGoals(List<Goal> goals);
  Future<Result<DateTime?>> getLastResetDate();
  Future<Result<void>> setLastResetDate(DateTime date);
}
