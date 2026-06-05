import 'package:flutter/material.dart';
import 'package:kaigin_pet/domain/entities/goal.dart';

class GoalItemCard extends StatelessWidget {
  const GoalItemCard({
    required this.goal,
    required this.onTap,
    super.key,
  });

  final Goal goal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final completed = goal.isCompleted;

    return GestureDetector(
      onTap: completed ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: completed
              ? scheme.primaryContainer.withValues(alpha: 0.5)
              : scheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: completed
                ? scheme.primary.withValues(alpha: 0.4)
                : scheme.outlineVariant,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            _CategoryIcon(category: goal.category, completed: completed),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goal.title,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: completed
                          ? scheme.onSurface.withValues(alpha: 0.5)
                          : scheme.onSurface,
                      decoration:
                          completed ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '+${goal.xpReward} XP',
                    style: textTheme.labelSmall?.copyWith(
                      color: completed
                          ? scheme.onSurface.withValues(alpha: 0.3)
                          : scheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _CheckBox(completed: completed),
          ],
        ),
      ),
    );
  }
}

class _CheckBox extends StatelessWidget {
  const _CheckBox({required this.completed});

  final bool completed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: completed ? scheme.primary : Colors.transparent,
        border: Border.all(
          color: completed ? scheme.primary : scheme.outline,
          width: 2,
        ),
      ),
      child: completed
          ? const Icon(Icons.check, size: 16, color: Colors.white)
          : null,
    );
  }
}

class _CategoryIcon extends StatelessWidget {
  const _CategoryIcon({required this.category, required this.completed});

  final GoalCategory category;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    final icon = switch (category) {
      GoalCategory.health => Icons.favorite_rounded,
      GoalCategory.mind => Icons.self_improvement_rounded,
      GoalCategory.social => Icons.people_rounded,
      GoalCategory.creative => Icons.palette_rounded,
      GoalCategory.learning => Icons.menu_book_rounded,
    };

    final color = switch (category) {
      GoalCategory.health => const Color(0xFFEF5350),
      GoalCategory.mind => const Color(0xFF7E57C2),
      GoalCategory.social => const Color(0xFF26A69A),
      GoalCategory.creative => const Color(0xFFFF7043),
      GoalCategory.learning => const Color(0xFF42A5F5),
    };

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: completed ? 0.1 : 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: color.withValues(alpha: completed ? 0.4 : 1.0),
        size: 20,
      ),
    );
  }
}
