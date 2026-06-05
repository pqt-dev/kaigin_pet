import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaigin_pet/domain/core/result.dart';
import 'package:kaigin_pet/domain/use_cases/goal/get_goals_use_case.dart';
import 'package:kaigin_pet/domain/use_cases/pet/add_xp_use_case.dart';
import 'package:kaigin_pet/domain/use_cases/pet/get_pet_use_case.dart';
import 'package:kaigin_pet/domain/use_cases/pet/update_pet_mood_use_case.dart';
import 'package:kaigin_pet/presentation/features/pet/pet_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class PetCubit extends Cubit<PetState> {
  PetCubit(
    this._getPet,
    this._getGoals,
    this._addXp,
    this._updateMood,
  ) : super(const PetInitial());

  final GetPetUseCase _getPet;
  final GetGoalsUseCase _getGoals;
  final AddXpUseCase _addXp;
  final UpdatePetMoodUseCase _updateMood;

  Future<void> load() async {
    emit(const PetLoading());

    final petResult = await _getPet();
    if (petResult is Failure) {
      emit(const PetError('Failed to load pet'));
      return;
    }

    final goalsResult = await _getGoals();
    final goals = goalsResult is Success ? (goalsResult as dynamic).value : [];
    final completed = (goals as List).where((g) => g.isCompleted).length;
    final total = goals.length;

    emit(PetLoaded(
      pet: (petResult as Success).value,
      completedGoals: completed,
      totalGoals: total,
    ));
  }

  Future<void> gainXp(int amount) async {
    final current = state;
    if (current is! PetLoaded) return;

    final prevLevel = current.pet.level;
    final result = await _addXp(xpAmount: amount);
    if (result is Failure) return;

    final newPet = (result as Success).value;
    final leveledUp = newPet.level > prevLevel;

    await _updateMood(
      completedGoals: current.completedGoals,
      totalGoals: current.totalGoals,
    );

    emit(current.copyWith(
      pet: newPet,
      justLeveledUp: leveledUp,
      xpGained: amount,
    ));
  }

  Future<void> refreshGoalProgress(int completed, int total) async {
    final current = state;
    if (current is! PetLoaded) return;

    final moodResult = await _updateMood(
      completedGoals: completed,
      totalGoals: total,
    );

    final pet = moodResult is Success
        ? (moodResult as Success).value
        : current.pet;

    emit(current.copyWith(
      pet: pet,
      completedGoals: completed,
      totalGoals: total,
      justLeveledUp: false,
      xpGained: null,
    ));
  }

  void clearLevelUp() {
    final current = state;
    if (current is PetLoaded) {
      emit(current.copyWith(justLeveledUp: false, xpGained: null));
    }
  }
}
