import 'package:kaigin_pet/domain/core/result.dart';
import 'package:kaigin_pet/domain/entities/pet.dart';
import 'package:kaigin_pet/domain/repositories/pet/pet_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdatePetMoodUseCase {
  UpdatePetMoodUseCase(this._repository);

  final PetRepository _repository;

  Future<Result<Pet>> call({
    required int completedGoals,
    required int totalGoals,
  }) async {
    final result = await _repository.getPet();
    if (result is Failure) return result;

    final current = (result as Success<Pet>).value;
    final mood = _calculateMood(completedGoals, totalGoals);
    final updated = current.copyWith(mood: mood);
    return _repository.updatePet(updated);
  }

  PetMood _calculateMood(int completed, int total) {
    if (total == 0) return PetMood.neutral;
    final ratio = completed / total;
    if (ratio >= 1.0) return PetMood.ecstatic;
    if (ratio >= 0.7) return PetMood.happy;
    if (ratio >= 0.3) return PetMood.neutral;
    if (ratio > 0) return PetMood.sad;
    return PetMood.tired;
  }
}
