import 'package:kaigin_pet/domain/core/result.dart';
import 'package:kaigin_pet/domain/entities/pet.dart';

abstract interface class PetRepository {
  Future<Result<Pet>> getPet();
  Future<Result<Pet>> updatePet(Pet pet);
}
