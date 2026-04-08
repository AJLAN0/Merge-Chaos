import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../game/application/player_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    if (!mounted) return;

    final hasOnboarded =
        ref.read(playerProvider).hasCompletedOnboarding;
    if (hasOnboarded) {
      context.go('/home');
    } else {
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo icon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.pets,
                size: 64,
                color: Colors.white,
              ),
            )
                .animate()
                .scale(
                  begin: const Offset(0.3, 0.3),
                  end: const Offset(1, 1),
                  duration: 800.ms,
                  curve: Curves.elasticOut,
                )
                .fadeIn(duration: 400.ms),

            const SizedBox(height: 24),

            // Title
            const Text(
              'Merge Chaos',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1,
              ),
            )
                .animate()
                .fadeIn(delay: 300.ms, duration: 600.ms)
                .slideY(begin: 0.3, end: 0, delay: 300.ms),

            const SizedBox(height: 8),

            Text(
              'Escalate nonsense into glory',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.7),
                fontStyle: FontStyle.italic,
              ),
            ).animate().fadeIn(delay: 600.ms, duration: 600.ms),

            const SizedBox(height: 40),

            // Loading indicator
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white.withValues(alpha: 0.6),
                ),
              ),
            ).animate().fadeIn(delay: 800.ms, duration: 400.ms),
          ],
        ),
      ),
    );
  }
}
