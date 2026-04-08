import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/home/presentation/screens/home_screen.dart';
import '../features/game/presentation/screens/game_screen.dart';
import '../features/collection/presentation/screens/collection_screen.dart';
import '../features/rewards/presentation/screens/daily_rewards_screen.dart';
import '../features/missions/presentation/screens/tasks_screen.dart';
import '../features/settings/presentation/screens/settings_screen.dart';
import '../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../features/onboarding/presentation/screens/splash_screen.dart';

abstract final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/game',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const GameScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/collection',
        builder: (context, state) => const CollectionScreen(),
      ),
      GoRoute(
        path: '/daily-rewards',
        builder: (context, state) => const DailyRewardsScreen(),
      ),
      GoRoute(
        path: '/tasks',
        builder: (context, state) => const TasksScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
