import 'package:kaigin_pet/domain/core/result.dart';
import 'package:kaigin_pet/domain/entities/pet.dart';
import 'package:kaigin_pet/domain/repositories/pet/pet_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddXpUseCase {
  AddXpUseCase(this._repository);

  final PetRepository _repository;

  Future<Result<Pet>> call({required int xpAmount}) async {
    final result = await _repository.getPet();
    if (result is Failure) return result;

    final current = (result as Success<Pet>).value;
    final updated = current.copyWith(totalXp: current.totalXp + xpAmount);
    return _repository.updatePet(updated);
  }
}
