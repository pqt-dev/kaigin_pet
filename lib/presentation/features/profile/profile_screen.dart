import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaigin_pet/domain/entities/pet.dart';
import 'package:kaigin_pet/generated/locale_keys.g.dart';
import 'package:kaigin_pet/presentation/features/goals/goals_cubit.dart';
import 'package:kaigin_pet/presentation/features/goals/goals_state.dart';
import 'package:kaigin_pet/presentation/features/pet/pet_cubit.dart';
import 'package:kaigin_pet/presentation/features/pet/pet_state.dart';
import 'package:kaigin_pet/presentation/theme/theme_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ProfileView();
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.profile_title.tr(),
                style: textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 20),
              _buildPetCard(context, scheme, textTheme),
              const SizedBox(height: 16),
              _buildStatsCard(context, scheme, textTheme),
              const SizedBox(height: 16),
              _buildSettingsCard(context, scheme, textTheme),
              const SizedBox(height: 16),
              _buildAboutCard(context, scheme, textTheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPetCard(
      BuildContext context, ColorScheme scheme, TextTheme textTheme) {
    return BlocBuilder<PetCubit, PetState>(
      builder: (context, state) {
        if (state is! PetLoaded) {
          return const Card(
              child: Center(child: CircularProgressIndicator()));
        }
        final pet = state.pet;
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                scheme.primaryContainer,
                scheme.tertiaryContainer,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              _PetAvatar(mood: pet.mood),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pet.name,
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Level ${pet.level} · ${pet.totalXp} XP total',
                      style: textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurface.withValues(alpha: 0.65),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: pet.levelProgress,
                        minHeight: 8,
                        backgroundColor:
                            scheme.onSurface.withValues(alpha: 0.15),
                        valueColor:
                            AlwaysStoppedAnimation(scheme.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsCard(
      BuildContext context, ColorScheme scheme, TextTheme textTheme) {
    return BlocBuilder<GoalsCubit, GoalsState>(
      builder: (context, goalsState) {
        return BlocBuilder<PetCubit, PetState>(
          builder: (context, petState) {
            final totalXp =
                petState is PetLoaded ? petState.pet.totalXp : 0;
            final completedGoals = goalsState is GoalsLoaded
                ? goalsState.completedCount
                : 0;

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.profile_stats_title.tr(),
                      style: textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _StatItem(
                            label: LocaleKeys.profile_total_goals.tr(),
                            value: '$completedGoals',
                            icon: Icons.check_circle_rounded,
                            color: scheme.primary,
                          ),
                        ),
                        Expanded(
                          child: _StatItem(
                            label: LocaleKeys.profile_total_xp.tr(),
                            value: '$totalXp',
                            icon: Icons.star_rounded,
                            color: const Color(0xFFFFBF00),
                          ),
                        ),
                        Expanded(
                          child: _StatItem(
                            label: LocaleKeys.profile_level.tr(),
                            value: petState is PetLoaded
                                ? '${petState.pet.level}'
                                : '-',
                            icon: Icons.emoji_events_rounded,
                            color: scheme.tertiary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSettingsCard(
      BuildContext context, ColorScheme scheme, TextTheme textTheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.profile_app_settings.tr(),
              style: textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            _ThemeToggle(),
            const SizedBox(height: 8),
            _LanguageSelector(),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutCard(
      BuildContext context, ColorScheme scheme, TextTheme textTheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const Text('🐦', style: TextStyle(fontSize: 28)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kaigin Pet',
                    style: textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    LocaleKeys.profile_companion.tr(),
                    style: textTheme.bodySmall?.copyWith(
                      color: scheme.onSurface.withValues(alpha: 0.55),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'v1.0',
              style: textTheme.labelSmall?.copyWith(
                color: scheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PetAvatar extends StatelessWidget {
  const _PetAvatar({required this.mood});

  final PetMood mood;

  @override
  Widget build(BuildContext context) {
    final emoji = switch (mood) {
      PetMood.ecstatic => '🌟',
      PetMood.happy => '😊',
      PetMood.neutral => '🐦',
      PetMood.sad => '😔',
      PetMood.tired => '😴',
    };

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(emoji, style: const TextStyle(fontSize: 36)),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w800),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color:
                    Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeCubit = context.watch<ThemeCubit>();
    final themeMode = themeCubit.state;

    return Row(
      children: [
        Icon(Icons.palette_outlined,
            size: 20, color: Theme.of(context).colorScheme.onSurface),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            LocaleKeys.theme.tr(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        SegmentedButton<ThemeMode>(
          segments: const [
            ButtonSegment(
                value: ThemeMode.light,
                icon: Icon(Icons.light_mode_rounded, size: 16)),
            ButtonSegment(
                value: ThemeMode.system,
                icon: Icon(Icons.auto_mode_rounded, size: 16)),
            ButtonSegment(
                value: ThemeMode.dark,
                icon: Icon(Icons.dark_mode_rounded, size: 16)),
          ],
          selected: {themeMode},
          onSelectionChanged: (modes) =>
              context.read<ThemeCubit>().setTheme(modes.first),
          style: const ButtonStyle(
            visualDensity: VisualDensity.compact,
          ),
        ),
      ],
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  static const _locales = {
    'en': Locale('en', 'US'),
    'vi': Locale('vi', 'VN'),
    'ja': Locale('ja', 'JP'),
    'zh': Locale('zh', 'CN'),
    'ko': Locale('ko', 'KR'),
    'fr': Locale('fr', 'FR'),
    'es': Locale('es', 'ES'),
    'pt': Locale('pt', 'BR'),
  };

  static const _labels = {
    'en': 'English',
    'vi': 'Tiếng Việt',
    'ja': '日本語',
    'zh': '中文',
    'ko': '한국어',
    'fr': 'Français',
    'es': 'Español',
    'pt': 'Português',
  };

  @override
  Widget build(BuildContext context) {
    final langCode = context.locale.languageCode;

    return Row(
      children: [
        Icon(Icons.language_rounded,
            size: 20, color: Theme.of(context).colorScheme.onSurface),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            LocaleKeys.language.tr(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: langCode,
            isDense: true,
            borderRadius: BorderRadius.circular(12),
            items: [
              for (final e in _labels.entries)
                DropdownMenuItem<String>(
                  value: e.key,
                  child: Text(e.value),
                ),
            ],
            onChanged: (code) {
              final locale = _locales[code];
              if (locale != null) context.setLocale(locale);
            },
          ),
        ),
      ],
    );
  }
}
