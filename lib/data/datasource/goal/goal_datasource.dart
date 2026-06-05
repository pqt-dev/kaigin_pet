import 'package:kaigin_pet/data/models/goal/goal_model.dart';

abstract interface class GoalDatasource {
  Future<List<GoalModel>> getGoals();
  Future<void> saveGoals(List<GoalModel> goals);
  Future<DateTime?> getLastResetDate();
  Future<void> setLastResetDate(DateTime date);
}
