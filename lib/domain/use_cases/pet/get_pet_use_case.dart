import 'package:kaigin_pet/domain/core/result.dart';
import 'package:kaigin_pet/domain/entities/pet.dart';
import 'package:kaigin_pet/domain/repositories/pet/pet_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetPetUseCase {
  GetPetUseCase(this._repository);

  final PetRepository _repository;

  Future<Result<Pet>> call() => _repository.getPet();
}
