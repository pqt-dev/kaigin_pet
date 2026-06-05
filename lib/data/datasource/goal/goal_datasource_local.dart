import 'dart:convert';

import 'package:kaigin_pet/data/datasource/goal/goal_datasource.dart';
import 'package:kaigin_pet/data/models/goal/goal_model.dart';
import 'package:kaigin_pet/infrastructure/constants/storage_keys.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Injectable(as: GoalDatasource)
class GoalDatasourceLocal implements GoalDatasource {
  GoalDatasourceLocal(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<List<GoalModel>> getGoals() async {
    final raw = _prefs.getString(StorageKeys.goalsDataKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => GoalModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveGoals(List<GoalModel> goals) async {
    final json = goals.map((g) => g.toJson()).toList();
    await _prefs.setString(StorageKeys.goalsDataKey, jsonEncode(json));
  }

  @override
  Future<DateTime?> getLastResetDate() async {
    final ms = _prefs.getInt(StorageKeys.lastResetDateKey);
    if (ms == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(ms);
  }

  @override
  Future<void> setLastResetDate(DateTime date) async {
    await _prefs.setInt(
        StorageKeys.lastResetDateKey, date.millisecondsSinceEpoch);
  }
}
