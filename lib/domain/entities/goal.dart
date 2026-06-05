enum GoalCategory { health, mind, social, creative, learning }

class Goal {
  const Goal({
    required this.id,
    required this.title,
    required this.category,
    required this.xpReward,
    required this.isCompleted,
    required this.isDefault,
  });

  final String id;
  final String title;
  final GoalCategory category;
  final int xpReward;
  final bool isCompleted;
  final bool isDefault;

  Goal copyWith({
    String? id,
    String? title,
    GoalCategory? category,
    int? xpReward,
    bool? isCompleted,
    bool? isDefault,
  }) {
    return Goal(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      xpReward: xpReward ?? this.xpReward,
      isCompleted: isCompleted ?? this.isCompleted,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Goal &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          isCompleted == other.isCompleted;

  @override
  int get hashCode => Object.hash(id, isCompleted);
}

List<Goal> defaultGoals() => [
      const Goal(
        id: 'default_water',
        title: 'Drink 8 glasses of water',
        category: GoalCategory.health,
        xpReward: 10,
        isCompleted: false,
        isDefault: true,
      ),
      const Goal(
        id: 'default_exercise',
        title: 'Exercise for 30 minutes',
        category: GoalCategory.health,
        xpReward: 20,
        isCompleted: false,
        isDefault: true,
      ),
      const Goal(
        id: 'default_sleep',
        title: 'Get 8 hours of sleep',
        category: GoalCategory.health,
        xpReward: 15,
        isCompleted: false,
        isDefault: true,
      ),
      const Goal(
        id: 'default_meditate',
        title: 'Meditate for 10 minutes',
        category: GoalCategory.mind,
        xpReward: 15,
        isCompleted: false,
        isDefault: true,
      ),
      const Goal(
        id: 'default_breathe',
        title: 'Take a mindful breathing break',
        category: GoalCategory.mind,
        xpReward: 5,
        isCompleted: false,
        isDefault: true,
      ),
      const Goal(
        id: 'default_friend',
        title: 'Reach out to a friend',
        category: GoalCategory.social,
        xpReward: 10,
        isCompleted: false,
        isDefault: true,
      ),
      const Goal(
        id: 'default_kind',
        title: 'Do something kind for someone',
        category: GoalCategory.social,
        xpReward: 10,
        isCompleted: false,
        isDefault: true,
      ),
      const Goal(
        id: 'default_creative',
        title: 'Draw, doodle, or create something',
        category: GoalCategory.creative,
        xpReward: 10,
        isCompleted: false,
        isDefault: true,
      ),
      const Goal(
        id: 'default_read',
        title: 'Read for 15 minutes',
        category: GoalCategory.learning,
        xpReward: 15,
        isCompleted: false,
        isDefault: true,
      ),
      const Goal(
        id: 'default_learn',
        title: 'Learn something new today',
        category: GoalCategory.learning,
        xpReward: 10,
        isCompleted: false,
        isDefault: true,
      ),
    ];
