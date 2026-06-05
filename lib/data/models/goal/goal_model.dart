import 'package:json_annotation/json_annotation.dart';

part 'goal_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class GoalModel {
  const GoalModel({
    required this.id,
    required this.title,
    required this.category,
    required this.xpReward,
    required this.isCompleted,
    required this.isDefault,
  });

  final String id;
  final String title;
  final String category;
  final int xpReward;
  final bool isCompleted;
  final bool isDefault;

  factory GoalModel.fromJson(Map<String, dynamic> json) =>
      _$GoalModelFromJson(json);

  Map<String, dynamic> toJson() => _$GoalModelToJson(this);
}
