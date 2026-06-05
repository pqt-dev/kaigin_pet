import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaigin_pet/domain/entities/pet.dart';
import 'package:kaigin_pet/generated/locale_keys.g.dart';
import 'package:kaigin_pet/presentation/features/pet/pet_cubit.dart';
import 'package:kaigin_pet/presentation/features/pet/pet_state.dart';
import 'package:kaigin_pet/presentation/features/pet/widgets/pet_bird_widget.dart';
import 'package:kaigin_pet/presentation/features/pet/widgets/xp_progress_bar.dart';

class PetHomeScreen extends StatelessWidget {
  const PetHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PetHomeView();
  }
}

class _PetHomeView extends StatelessWidget {
  const _PetHomeView();

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
        _MoodBadge(mood: mood),
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
          PetBirdWidget(mood: state.pet.mood, size: 160),
          const SizedBox(height: 20),
          XpProgressBar(
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
        content: Text(LocaleKeys.pet_level_up_message.tr(namedArgs: {'level': '$level'})),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

}

class _MoodBadge extends StatelessWidget {
  const _MoodBadge({required this.mood});

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
