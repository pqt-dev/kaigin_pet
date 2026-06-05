import 'package:kaigin_pet/data/models/goal/goal_model.dart';
import 'package:kaigin_pet/domain/entities/goal.dart';

extension GoalModelX on GoalModel {
  Goal toEntity() => Goal(
        id: id,
        title: title,
        category: _categoryFromString(category),
        xpReward: xpReward,
        isCompleted: isCompleted,
        isDefault: isDefault,
      );

  GoalCategory _categoryFromString(String value) =>
      GoalCategory.values.firstWhere(
        (c) => c.name == value,
        orElse: () => GoalCategory.health,
      );
}

extension GoalX on Goal {
  GoalModel toModel() => GoalModel(
        id: id,
        title: title,
        category: category.name,
        xpReward: xpReward,
        isCompleted: isCompleted,
        isDefault: isDefault,
      );
}
