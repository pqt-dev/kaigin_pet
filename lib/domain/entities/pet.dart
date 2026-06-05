enum PetMood { ecstatic, happy, neutral, sad, tired }

class Pet {
  const Pet({
    required this.name,
    required this.totalXp,
    required this.mood,
  });

  final String name;
  final int totalXp;
  final PetMood mood;

  int get level => _levelFromXp(totalXp);

  int get currentLevelXp => totalXp - _xpThresholdForLevel(level);

  int get xpToNextLevel =>
      _xpThresholdForLevel(level + 1) - _xpThresholdForLevel(level);

  double get levelProgress => xpToNextLevel == 0
      ? 1.0
      : (currentLevelXp / xpToNextLevel).clamp(0.0, 1.0);

  static int _levelFromXp(int xp) {
    int lvl = 1;
    while (_xpThresholdForLevel(lvl + 1) <= xp) {
      lvl++;
    }
    return lvl;
  }

  static int _xpThresholdForLevel(int level) {
    if (level <= 1) return 0;
    // Each level requires level * 100 XP cumulative
    int total = 0;
    for (int i = 1; i < level; i++) {
      total += i * 100;
    }
    return total;
  }

  Pet copyWith({String? name, int? totalXp, PetMood? mood}) {
    return Pet(
      name: name ?? this.name,
      totalXp: totalXp ?? this.totalXp,
      mood: mood ?? this.mood,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pet &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          totalXp == other.totalXp &&
          mood == other.mood;

  @override
  int get hashCode => Object.hash(name, totalXp, mood);
}
