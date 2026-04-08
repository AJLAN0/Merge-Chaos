import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../collection/application/collection_provider.dart';
import '../../../game/application/player_provider.dart';
import '../../../game/presentation/widgets/creature_avatar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerProvider);
    final collection = ref.watch(collectionProvider);
    final discovered = ref.watch(discoveredCountProvider);
    final total = ref.watch(totalCreatureCountProvider);

    // Find highest tier unlocked creature for hero art
    final highestUnlocked = collection
        .where((e) => e.isUnlocked)
        .toList()
      ..sort((a, b) => b.creature.tier.compareTo(a.creature.tier));

    final heroCreature =
        highestUnlocked.isNotEmpty ? highestUnlocked.first.creature : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Title
            Text(
              'Merge Chaos',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                shadows: [
                  Shadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0),

            const SizedBox(height: 8),
            Text(
              'Science has gone too far. Continue?',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 600.ms),

            const Spacer(),

            // Hero creature
            if (heroCreature != null)
              CreatureAvatar(
                creatureId: heroCreature.id,
                size: 140,
                showAura: true,
              )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .moveY(begin: 0, end: -8, duration: 2.seconds)
            else
              const Icon(
                Icons.pets,
                size: 100,
                color: AppColors.primaryLight,
              ).animate().fadeIn(duration: 600.ms),

            const SizedBox(height: 12),

            // Progress
            Text(
              '$discovered / $total Discovered',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),

            const Spacer(),

            // PLAY button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go('/game'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 8,
                    shadowColor: AppColors.primary.withValues(alpha: 0.4),
                  ),
                  child: const Text(
                    'PLAY',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            )
                .animate()
                .fadeIn(delay: 400.ms, duration: 600.ms)
                .slideY(begin: 0.3, end: 0, delay: 400.ms),

            const SizedBox(height: 32),

            // Bottom navigation row
            Padding(
              padding:
                  const EdgeInsets.only(left: 24, right: 24, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _NavButton(
                    icon: Icons.auto_awesome_mosaic,
                    label: 'Collection',
                    onTap: () => context.push('/collection'),
                  ),
                  _NavButton(
                    icon: Icons.card_giftcard,
                    label: 'Rewards',
                    badge: _canClaimReward(player.lastDailyRewardClaim),
                    onTap: () => context.push('/daily-rewards'),
                  ),
                  _NavButton(
                    icon: Icons.settings,
                    label: 'Settings',
                    onTap: () => context.push('/settings'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _canClaimReward(DateTime? lastClaim) {
    if (lastClaim == null) return true;
    final now = DateTime.now();
    return now.year != lastClaim.year ||
        now.month != lastClaim.month ||
        now.day != lastClaim.day;
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool badge;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.badge = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, size: 24, color: AppColors.primary),
              ),
              if (badge)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
