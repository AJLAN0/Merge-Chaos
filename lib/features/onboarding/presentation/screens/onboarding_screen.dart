import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../game/application/player_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  static const _pages = [
    _OnboardingPage(
      icon: Icons.science,
      iconColor: AppColors.primary,
      title: 'Welcome to the Chaos Lab!',
      subtitle: 'Merge creatures and discover the unexpected.',
    ),
    _OnboardingPage(
      icon: Icons.merge_type,
      iconColor: AppColors.accent,
      title: 'Merge to Evolve',
      subtitle:
          'Drag identical creatures together to create something new and bizarre.',
    ),
    _OnboardingPage(
      icon: Icons.auto_awesome_mosaic,
      iconColor: AppColors.rarityLegendary,
      title: 'Collect Them All',
      subtitle:
          'Build your collection of increasingly chaotic creatures. What comes next?',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onFinish() {
    ref.read(playerProvider.notifier).completeOnboarding();
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _onFinish,
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            color: page.iconColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            page.icon,
                            size: 72,
                            color: page.iconColor,
                          ),
                        ).animate().scale(
                              begin: const Offset(0.6, 0.6),
                              end: const Offset(1, 1),
                              duration: 600.ms,
                              curve: Curves.elasticOut,
                            ),
                        const SizedBox(height: 40),
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 200.ms, duration: 500.ms)
                            .slideY(begin: 0.2, end: 0),
                        const SizedBox(height: 16),
                        Text(
                          page.subtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 400.ms, duration: 500.ms),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Page indicators + button
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Dots
                  Row(
                    children: List.generate(_pages.length, (i) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: i == _currentPage ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: i == _currentPage
                              ? AppColors.primary
                              : AppColors.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),

                  // Next / Get started button
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage < _pages.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        _onFinish();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      _currentPage < _pages.length - 1
                          ? 'Next'
                          : "Let's Go!",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  const _OnboardingPage({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });
}
