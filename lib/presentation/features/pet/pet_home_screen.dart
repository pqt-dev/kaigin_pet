import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaigin_pet/domain/entities/pet.dart';
import 'package:kaigin_pet/generated/locale_keys.g.dart';
import 'package:kaigin_pet/core/constants/storage_keys.dart';
import 'package:kaigin_pet/core/di/injection.dart';
import 'package:kaigin_pet/presentation/features/pet/pet_cubit.dart';
import 'package:kaigin_pet/presentation/features/pet/pet_state.dart';
import 'package:kaigin_pet/presentation/features/pet/widgets/pet_bird_widget.dart';
import 'package:kaigin_pet/presentation/features/pet/widgets/xp_progress_bar.dart';
import 'package:kaigin_pet/presentation/widgets/coach_mark_content.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class PetHomeScreen extends StatelessWidget {
  const PetHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PetHomeView();
  }
}

class _PetHomeView extends StatefulWidget {
  const _PetHomeView();

  @override
  State<_PetHomeView> createState() => _PetHomeViewState();
}

class _PetHomeViewState extends State<_PetHomeView> {
  final _moodBadgeKey = GlobalKey();
  final _petBirdKey = GlobalKey();
  final _xpBarKey = GlobalKey();
  final _moodCardKey = GlobalKey();
  final _goalsSummaryKey = GlobalKey();
  bool _coachMarkTriggered = false;

  void _maybeShowCoachMark(BuildContext context) {
    if (_coachMarkTriggered) return;
    _coachMarkTriggered = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final prefs = getIt<SharedPreferences>();
      if (prefs.getBool(StorageKeys.homeCoachMarkSeenKey) ?? false) return;

      TutorialCoachMark(
        targets: [
          TargetFocus(
            identify: 'mood-badge',
            keyTarget: _moodBadgeKey,
            shape: ShapeLightFocus.RRect,
            radius: 20,
            paddingFocus: 8,
            enableOverlayTab: true,
            enableTargetTab: true,
            contents: [
              TargetContent(
                align: ContentAlign.bottom,
                child: const CoachMarkContent(
                  title: "Mood Badge 🎭",
                  description:
                      "A quick-glance indicator of Kaigin's current mood.\n\n"
                      "The color and emoji update automatically throughout the day as you complete goals. "
                      "Gold = ecstatic, orange = happy, blue = sad, grey = tired.",
                ),
              ),
            ],
          ),
          TargetFocus(
            identify: 'pet-bird',
            keyTarget: _petBirdKey,
            shape: ShapeLightFocus.RRect,
            radius: 24,
            paddingFocus: 12,
            enableOverlayTab: true,
            enableTargetTab: true,
            contents: [
              TargetContent(
                align: ContentAlign.bottom,
                child: const CoachMarkContent(
                  title: "This is Kaigin! 🐦",
                  description:
                      "Kaigin is your hand-drawn, animated companion. "
                      "The color, expression, and energy all reflect the current mood — "
                      "golden & sparkling when ecstatic, droopy-eyed when tired.\n\n"
                      "Complete daily goals to keep Kaigin glowing!",
                ),
              ),
            ],
          ),
          TargetFocus(
            identify: 'xp-bar',
            keyTarget: _xpBarKey,
            shape: ShapeLightFocus.RRect,
            radius: 10,
            paddingFocus: 8,
            enableOverlayTab: true,
            enableTargetTab: true,
            contents: [
              TargetContent(
                align: ContentAlign.top,
                child: const CoachMarkContent(
                  title: "XP & Level Up ⭐",
                  description:
                      "Every goal you complete earns XP. Fill this bar to reach the next level!\n\n"
                      "Higher levels mean a more vibrant, expressive Kaigin. "
                      "The bar shows your progress: current XP / XP needed for next level.",
                ),
              ),
            ],
          ),
          TargetFocus(
            identify: 'mood-card',
            keyTarget: _moodCardKey,
            shape: ShapeLightFocus.RRect,
            radius: 16,
            paddingFocus: 8,
            enableOverlayTab: true,
            enableTargetTab: true,
            contents: [
              TargetContent(
                align: ContentAlign.top,
                child: const CoachMarkContent(
                  title: "Mood in Detail 💭",
                  description:
                      "Kaigin has 5 mood levels based on how many goals you complete today:\n\n"
                      "😴 Tired  →  😔 Sad  →  😐 Neutral\n"
                      "→  😊 Happy  →  🌟 Ecstatic\n\n"
                      "Complete all goals to reach Ecstatic — the happiest Kaigin can be!",
                ),
              ),
            ],
          ),
          TargetFocus(
            identify: 'goals-summary',
            keyTarget: _goalsSummaryKey,
            shape: ShapeLightFocus.RRect,
            radius: 16,
            paddingFocus: 8,
            enableOverlayTab: true,
            enableTargetTab: true,
            contents: [
              TargetContent(
                align: ContentAlign.top,
                child: const CoachMarkContent(
                  title: "Today's Snapshot 📊",
                  description:
                      "A quick count of how many goals you've completed today out of the total.\n\n"
                      "Head to the Goals tab (bottom navigation) to see all goal categories — "
                      "Health, Mind, Social, Creative, and Learning — and tick them off one by one!",
                ),
              ),
            ],
          ),
        ],
        colorShadow: Colors.black,
        opacityShadow: 0.8,
        paddingFocus: 10,
        onFinish: () =>
            prefs.setBool(StorageKeys.homeCoachMarkSeenKey, true),
        onSkip: () {
          prefs.setBool(StorageKeys.homeCoachMarkSeenKey, true);
          return true;
        },
      ).show(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PetCubit, PetState>(
      listener: (context, state) {
        if (state is PetLoaded && state.justLeveledUp) {
          _showLevelUpSnackBar(context, state.pet.level);
          context.read<PetCubit>().clearLevelUp();
        }
      },
      builder: (context, state) {
        if (state is PetLoading || state is PetInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is PetError) {
          return Center(child: Text(state.message));
        }
        if (state is PetLoaded) {
          _maybeShowCoachMark(context);
          return _buildLoaded(context, state);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLoaded(BuildContext context, PetLoaded state) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? LocaleKeys.pet_greeting_morning.tr()
        : hour < 18
            ? LocaleKeys.pet_greeting_afternoon.tr()
            : LocaleKeys.pet_greeting_evening.tr();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildHeader(context, greeting, state.pet.name, state.pet.mood),
              const SizedBox(height: 24),
              _buildPetCard(context, state, scheme),
              const SizedBox(height: 20),
              _buildMoodCard(context, state.pet.mood, scheme, textTheme),
              const SizedBox(height: 16),
              _buildGoalsSummary(context, state, scheme, textTheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, String greeting, String name, PetMood mood) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6),
                    ),
              ),
              Text(
                name,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ],
          ),
        ),
        _MoodBadge(key: _moodBadgeKey, mood: mood),
      ],
    );
  }

  Widget _buildPetCard(
      BuildContext context, PetLoaded state, ColorScheme scheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scheme.primaryContainer,
            scheme.secondaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          PetBirdWidget(key: _petBirdKey, mood: state.pet.mood, size: 160),
          const SizedBox(height: 20),
          XpProgressBar(
            key: _xpBarKey,
            level: state.pet.level,
            currentXp: state.pet.currentLevelXp,
            xpToNext: state.pet.xpToNextLevel,
            progress: state.pet.levelProgress,
          ),
        ],
      ),
    );
  }

  Widget _buildMoodCard(BuildContext context, PetMood mood,
      ColorScheme scheme, TextTheme textTheme) {
    final moodText = switch (mood) {
      PetMood.ecstatic => LocaleKeys.pet_mood_ecstatic.tr(),
      PetMood.happy => LocaleKeys.pet_mood_happy.tr(),
      PetMood.neutral => LocaleKeys.pet_mood_neutral.tr(),
      PetMood.sad => LocaleKeys.pet_mood_sad.tr(),
      PetMood.tired => LocaleKeys.pet_mood_tired.tr(),
    };

    final moodEmoji = switch (mood) {
      PetMood.ecstatic => '🌟',
      PetMood.happy => '😊',
      PetMood.neutral => '😐',
      PetMood.sad => '😔',
      PetMood.tired => '😴',
    };

    return Card(
      key: _moodCardKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Text(moodEmoji, style: textTheme.headlineSmall),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.pet_feeling.tr(),
                  style: textTheme.labelSmall?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                Text(
                  moodText,
                  style: textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalsSummary(BuildContext context, PetLoaded state,
      ColorScheme scheme, TextTheme textTheme) {
    final pct = state.totalGoals == 0
        ? 0.0
        : state.completedGoals / state.totalGoals;

    return Card(
      key: _goalsSummaryKey,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.pet_today_progress.tr(),
              style: textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: pct,
                      minHeight: 8,
                      backgroundColor: scheme.surfaceContainerHighest,
                      valueColor:
                          AlwaysStoppedAnimation(scheme.tertiary),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${state.completedGoals}/${state.totalGoals}',
                  style: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: scheme.tertiary,
                  ),
                ),
              ],
            ),
            if (state.completedGoals == state.totalGoals &&
                state.totalGoals > 0) ...[
              const SizedBox(height: 8),
              Text(
                LocaleKeys.goals_all_done.tr(),
                style: textTheme.labelMedium?.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showLevelUpSnackBar(BuildContext context, int level) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(LocaleKeys.pet_level_up_message
            .tr(namedArgs: {'level': '$level'})),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

class _MoodBadge extends StatelessWidget {
  const _MoodBadge({super.key, required this.mood});

  final PetMood mood;

  @override
  Widget build(BuildContext context) {
    final color = switch (mood) {
      PetMood.ecstatic => const Color(0xFFFFD166),
      PetMood.happy => const Color(0xFFFF8C69),
      PetMood.neutral => const Color(0xFF90CAF9),
      PetMood.sad => const Color(0xFF7986CB),
      PetMood.tired => const Color(0xFFB0BEC5),
    };

    final emoji = switch (mood) {
      PetMood.ecstatic => '🌟',
      PetMood.happy => '😊',
      PetMood.neutral => '😐',
      PetMood.sad => '😔',
      PetMood.tired => '😴',
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Text(emoji, style: const TextStyle(fontSize: 20)),
    );
  }
}
