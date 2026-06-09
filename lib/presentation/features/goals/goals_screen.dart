import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaigin_pet/domain/entities/goal.dart';
import 'package:kaigin_pet/generated/locale_keys.g.dart';
import 'package:kaigin_pet/core/constants/storage_keys.dart';
import 'package:kaigin_pet/core/di/injection.dart';
import 'package:kaigin_pet/presentation/features/goals/goals_cubit.dart';
import 'package:kaigin_pet/presentation/features/goals/goals_state.dart';
import 'package:kaigin_pet/presentation/features/goals/widgets/goal_item_card.dart';
import 'package:kaigin_pet/presentation/features/pet/pet_cubit.dart';
import 'package:kaigin_pet/presentation/widgets/coach_mark_content.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _GoalsView();
  }
}

class _GoalsView extends StatefulWidget {
  const _GoalsView();

  @override
  State<_GoalsView> createState() => _GoalsViewState();
}

class _GoalsViewState extends State<_GoalsView> {
  final _progressKey = GlobalKey();
  final _fabKey = GlobalKey();
  final _firstGoalKey = GlobalKey();
  bool _coachMarkTriggered = false;

  void _maybeShowCoachMark(BuildContext context, GoalsLoaded state) {
    if (_coachMarkTriggered) return;
    _coachMarkTriggered = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final prefs = getIt<SharedPreferences>();
      if (prefs.getBool(StorageKeys.goalsCoachMarkSeenKey) ?? false) return;

      final allGoals = [
        ...state.healthGoals,
        ...state.mindGoals,
        ...state.socialGoals,
        ...state.creativeGoals,
        ...state.learningGoals,
      ];
      final hasGoals = allGoals.isNotEmpty;

      final targets = <TargetFocus>[
        TargetFocus(
          identify: 'progress-bar',
          keyTarget: _progressKey,
          shape: ShapeLightFocus.RRect,
          radius: 8,
          paddingFocus: 8,
          enableOverlayTab: true,
          enableTargetTab: true,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: const CoachMarkContent(
                title: "Daily Progress 📈",
                description:
                    'This bar shows how many of today\'s goals you\'ve completed. Fill it up to make Kaigin happiest!',
              ),
            ),
          ],
        ),
        if (hasGoals)
          TargetFocus(
            identify: 'first-goal',
            keyTarget: _firstGoalKey,
            shape: ShapeLightFocus.RRect,
            radius: 16,
            paddingFocus: 8,
            enableOverlayTab: true,
            enableTargetTab: true,
            contents: [
              TargetContent(
                align: ContentAlign.bottom,
                child: const CoachMarkContent(
                  title: 'Tap to Complete ✅',
                  description:
                      'Tap any goal to mark it as done and earn XP. Completed goals reset every day.',
                ),
              ),
            ],
          ),
        TargetFocus(
          identify: 'add-goal-fab',
          keyTarget: _fabKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          paddingFocus: 8,
          enableOverlayTab: true,
          enableTargetTab: true,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              child: const CoachMarkContent(
                title: 'Add Your Own Goals ✨',
                description:
                    'Want something more personal? Tap here to create a custom goal in any category.',
              ),
            ),
          ],
        ),
      ];

      TutorialCoachMark(
        targets: targets,
        colorShadow: Colors.black,
        opacityShadow: 0.8,
        paddingFocus: 10,
        onFinish: () =>
            prefs.setBool(StorageKeys.goalsCoachMarkSeenKey, true),
        onSkip: () {
          prefs.setBool(StorageKeys.goalsCoachMarkSeenKey, true);
          return true;
        },
      ).show(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GoalsCubit, GoalsState>(
      listener: (context, state) {
        if (state is GoalsLoaded && state.lastCompletedGoalXp != null) {
          _showXpSnackBar(context, state.lastCompletedGoalXp!);
          context.read<GoalsCubit>().clearXpNotification();
        }
      },
      builder: (context, state) {
        if (state is GoalsLoading || state is GoalsInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is GoalsError) {
          return Center(child: Text(state.message));
        }
        if (state is GoalsLoaded) {
          _maybeShowCoachMark(context, state);
          return _buildLoaded(context, state);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLoaded(BuildContext context, GoalsLoaded state) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    bool firstGoalKeyUsed = false;

    GlobalKey? takeFirstGoalKey() {
      if (firstGoalKeyUsed) return null;
      firstGoalKeyUsed = true;
      return _firstGoalKey;
    }

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.goals_title.tr(),
                      style: textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      LocaleKeys.goals_completed.tr(namedArgs: {
                        'done': '${state.completedCount}',
                        'total': '${state.totalCount}',
                      }),
                      style: textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurface.withValues(alpha: 0.55),
                      ),
                    ),
                    if (state.allDone) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: scheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🎉', style: TextStyle(fontSize: 16)),
                            const SizedBox(width: 8),
                            Text(
                              LocaleKeys.goals_all_done.tr(),
                              style: textTheme.labelMedium?.copyWith(
                                color: scheme.onPrimaryContainer,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    _buildProgressRow(context, state),
                  ],
                ),
              ),
            ),
            _buildSection(
              context,
              '💪 ${LocaleKeys.goals_category_health.tr()}',
              state.healthGoals,
              takeFirstGoalKey,
            ),
            _buildSection(
              context,
              '🧘 ${LocaleKeys.goals_category_mind.tr()}',
              state.mindGoals,
              takeFirstGoalKey,
            ),
            _buildSection(
              context,
              '🤝 ${LocaleKeys.goals_category_social.tr()}',
              state.socialGoals,
              takeFirstGoalKey,
            ),
            _buildSection(
              context,
              '🎨 ${LocaleKeys.goals_category_creative.tr()}',
              state.creativeGoals,
              takeFirstGoalKey,
            ),
            _buildSection(
              context,
              '📚 ${LocaleKeys.goals_category_learning.tr()}',
              state.learningGoals,
              takeFirstGoalKey,
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: _fabKey,
        onPressed: () => _showAddGoalSheet(context),
        icon: const Icon(Icons.add),
        label: Text(LocaleKeys.goals_add_goal.tr()),
      ),
    );
  }

  Widget _buildProgressRow(BuildContext context, GoalsLoaded state) {
    final scheme = Theme.of(context).colorScheme;
    final pct =
        state.totalCount == 0 ? 0.0 : state.completedCount / state.totalCount;

    return ClipRRect(
      key: _progressKey,
      borderRadius: BorderRadius.circular(8),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: pct),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
        builder: (context, value, _) {
          return LinearProgressIndicator(
            value: value,
            minHeight: 10,
            backgroundColor: scheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation(scheme.primary),
          );
        },
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Goal> goals,
    GlobalKey? Function() takeFirstKey,
  ) {
    if (goals.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.65),
                    ),
              ),
            ),
            ...goals.map(
              (goal) => GoalItemCard(
                key: takeFirstKey(),
                goal: goal,
                onTap: () async {
                  final xp =
                      await context.read<GoalsCubit>().completeGoal(goal.id);
                  if (xp == null || !context.mounted) return;
                  final goalsState = context.read<GoalsCubit>().state;
                  if (goalsState is! GoalsLoaded) return;
                  final petCubit = context.read<PetCubit>();
                  await petCubit.gainXp(xp);
                  if (context.mounted) {
                    petCubit.refreshGoalProgress(
                      goalsState.completedCount,
                      goalsState.totalCount,
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _showXpSnackBar(BuildContext context, int xp) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(LocaleKeys.pet_xp_earned.tr(namedArgs: {'xp': '$xp'})),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showAddGoalSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<GoalsCubit>(),
        child: const _AddGoalSheet(),
      ),
    );
  }
}

class _AddGoalSheet extends StatefulWidget {
  const _AddGoalSheet();

  @override
  State<_AddGoalSheet> createState() => _AddGoalSheetState();
}

class _AddGoalSheetState extends State<_AddGoalSheet> {
  final _controller = TextEditingController();
  GoalCategory _selected = GoalCategory.health;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(
          24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.goals_add_a_goal.tr(),
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: LocaleKeys.goals_custom_goal_hint.tr(),
              filled: true,
              fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            LocaleKeys.goals_category.tr(),
            style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: GoalCategory.values.map((cat) {
              final label = switch (cat) {
                GoalCategory.health =>
                  '💪 ${LocaleKeys.goals_category_health.tr()}',
                GoalCategory.mind =>
                  '🧘 ${LocaleKeys.goals_category_mind.tr()}',
                GoalCategory.social =>
                  '🤝 ${LocaleKeys.goals_category_social.tr()}',
                GoalCategory.creative =>
                  '🎨 ${LocaleKeys.goals_category_creative.tr()}',
                GoalCategory.learning =>
                  '📚 ${LocaleKeys.goals_category_learning.tr()}',
              };
              final selected = _selected == cat;
              return ChoiceChip(
                label: Text(label),
                selected: selected,
                onSelected: (_) => setState(() => _selected = cat),
                selectedColor: scheme.primaryContainer,
                backgroundColor:
                    scheme.surfaceContainerHighest.withValues(alpha: 0.5),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                final title = _controller.text.trim();
                if (title.isEmpty) return;
                context.read<GoalsCubit>().addCustomGoal(title, _selected);
                Navigator.pop(context);
              },
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(
                LocaleKeys.goals_add_goal.tr(),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
