import 'package:kaigin_pet/data/models/pet_model.dart';

abstract interface class PetDatasource {
  Future<PetModel?> getPet();
  Future<void> savePet(PetModel pet);
}
