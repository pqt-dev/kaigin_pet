import 'package:kaigin_pet/domain/entities/pet.dart';

sealed class PetState {
  const PetState();
}

final class PetInitial extends PetState {
  const PetInitial();
}

final class PetLoading extends PetState {
  const PetLoading();
}

final class PetLoaded extends PetState {
  const PetLoaded({
    required this.pet,
    required this.completedGoals,
    required this.totalGoals,
    this.justLeveledUp = false,
    this.xpGained,
  });

  final Pet pet;
  final int completedGoals;
  final int totalGoals;
  final bool justLeveledUp;
  final int? xpGained;

  PetLoaded copyWith({
    Pet? pet,
    int? completedGoals,
    int? totalGoals,
    bool? justLeveledUp,
    int? xpGained,
  }) {
    return PetLoaded(
      pet: pet ?? this.pet,
      completedGoals: completedGoals ?? this.completedGoals,
      totalGoals: totalGoals ?? this.totalGoals,
      justLeveledUp: justLeveledUp ?? this.justLeveledUp,
      xpGained: xpGained,
    );
  }
}

final class PetError extends PetState {
  const PetError(this.message);

  final String message;
}
