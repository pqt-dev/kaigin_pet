import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kaigin_pet/generated/locale_keys.g.dart';
import 'package:kaigin_pet/core/di/injection.dart';
import 'package:kaigin_pet/presentation/features/goals/goals_cubit.dart';
import 'package:kaigin_pet/presentation/features/goals/goals_state.dart';
import 'package:kaigin_pet/presentation/features/pet/pet_cubit.dart';

class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<PetCubit>()..load()),
        BlocProvider(create: (_) => getIt<GoalsCubit>()..load()),
      ],
      child: BlocListener<GoalsCubit, GoalsState>(
        listenWhen: (prev, curr) =>
            prev is GoalsLoading && curr is GoalsLoaded,
        listener: (context, state) {
          if (state is GoalsLoaded) {
            context.read<PetCubit>().refreshGoalProgress(
              state.completedCount,
              state.totalCount,
            );
          }
        },
        child: Scaffold(
          body: navigationShell,
          bottomNavigationBar: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: (index) => navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            ),
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home_rounded),
                label: LocaleKeys.home.tr(),
              ),
              NavigationDestination(
                icon: const Icon(Icons.check_circle_outline_rounded),
                selectedIcon: const Icon(Icons.check_circle_rounded),
                label: LocaleKeys.tab_goals.tr(),
              ),
              NavigationDestination(
                icon: const Icon(Icons.book_outlined),
                selectedIcon: const Icon(Icons.book_rounded),
                label: LocaleKeys.tab_journal.tr(),
              ),
              NavigationDestination(
                icon: const Icon(Icons.person_outline_rounded),
                selectedIcon: const Icon(Icons.person_rounded),
                label: LocaleKeys.tab_profile.tr(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
