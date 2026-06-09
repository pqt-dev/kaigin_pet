import 'package:json_annotation/json_annotation.dart';

part 'pet_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PetModel {
  const PetModel({
    required this.name,
    required this.totalXp,
    required this.mood,
  });

  final String name;
  final int totalXp;
  final String mood;

  factory PetModel.fromJson(Map<String, dynamic> json) =>
      _$PetModelFromJson(json);

  Map<String, dynamic> toJson() => _$PetModelToJson(this);
}
