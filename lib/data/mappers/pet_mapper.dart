import 'package:kaigin_pet/data/models/pet/pet_model.dart';
import 'package:kaigin_pet/domain/entities/pet.dart';

extension PetModelX on PetModel {
  Pet toEntity() => Pet(
        name: name,
        totalXp: totalXp,
        mood: _moodFromString(mood),
      );

  PetMood _moodFromString(String value) =>
      PetMood.values.firstWhere(
        (m) => m.name == value,
        orElse: () => PetMood.neutral,
      );
}

extension PetX on Pet {
  PetModel toModel() => PetModel(
        name: name,
        totalXp: totalXp,
        mood: mood.name,
      );
}
