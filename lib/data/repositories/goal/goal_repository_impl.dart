import 'package:kaigin_pet/data/datasource/goal/goal_datasource.dart';
import 'package:kaigin_pet/data/mappers/goal_mapper.dart';
import 'package:kaigin_pet/domain/core/app_error.dart';
import 'package:kaigin_pet/domain/core/result.dart';
import 'package:kaigin_pet/domain/entities/goal.dart';
import 'package:kaigin_pet/domain/repositories/goal/goal_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: GoalRepository)
class GoalRepositoryImpl implements GoalRepository {
  GoalRepositoryImpl(this._datasource);

  final GoalDatasource _datasource;

  @override
  Future<Result<List<Goal>>> getGoals() async {
    try {
      final models = await _datasource.getGoals();
      return Success(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return const Failure(UnexpectedError());
    }
  }

  @override
  Future<Result<List<Goal>>> saveGoals(List<Goal> goals) async {
    try {
      final models = goals.map((g) => g.toModel()).toList();
      await _datasource.saveGoals(models);
      return Success(goals);
    } catch (e) {
      return const Failure(UnexpectedError());
    }
  }

  @override
  Future<Result<DateTime?>> getLastResetDate() async {
    try {
      final date = await _datasource.getLastResetDate();
      return Success(date);
    } catch (e) {
      return const Failure(UnexpectedError());
    }
  }

  @override
  Future<Result<void>> setLastResetDate(DateTime date) async {
    try {
      await _datasource.setLastResetDate(date);
      return const Success(null);
    } catch (e) {
      return const Failure(UnexpectedError());
    }
  }
}
