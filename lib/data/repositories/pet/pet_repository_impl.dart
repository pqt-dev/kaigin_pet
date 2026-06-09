import 'package:kaigin_pet/data/datasource/pet/pet_datasource.dart';
import 'package:kaigin_pet/data/mappers/pet_mapper.dart';
import 'package:kaigin_pet/data/models/pet_model.dart';
import 'package:kaigin_pet/domain/core/app_error.dart';
import 'package:kaigin_pet/domain/core/result.dart';
import 'package:kaigin_pet/domain/entities/pet.dart';
import 'package:kaigin_pet/domain/repositories/pet/pet_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: PetRepository)
class PetRepositoryImpl implements PetRepository {
  PetRepositoryImpl(this._datasource);

  final PetDatasource _datasource;

  static const _defaultPet = PetModel(
    name: 'Kaigin',
    totalXp: 0,
    mood: 'neutral',
  );

  @override
  Future<Result<Pet>> getPet() async {
    try {
      final model = await _datasource.getPet() ?? _defaultPet;
      return Success(model.toEntity());
    } catch (e) {
      return const Failure(UnexpectedError());
    }
  }

  @override
  Future<Result<Pet>> updatePet(Pet pet) async {
    try {
      await _datasource.savePet(pet.toModel());
      return Success(pet);
    } catch (e) {
      return const Failure(UnexpectedError());
    }
  }
}
