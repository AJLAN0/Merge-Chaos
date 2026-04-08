import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/game_constants.dart';
import '../../../game/application/game_providers.dart';
import '../../../game/application/player_provider.dart';
import '../../../game/domain/reward_engine.dart';

class DailyRewardsScreen extends ConsumerWidget {
  const DailyRewardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerProvider);
    final rewardEngine = ref.read(rewardEngineProvider);
    final canClaim =
        rewardEngine.canClaimDailyReward(player.lastDailyRewardClaim);
    final currentDay = player.dailyRewardDay;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Daily Rewards'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Come back every day for rewards!',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),

            // 7-day grid
            Expanded(
              child: GridView.builder(
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemCount: GameConstants.dailyRewardDays,
                itemBuilder: (context, index) {
                  final reward = rewardEngine.getDailyReward(index);
                  final isClaimed = index < currentDay;
                  final isToday = index == currentDay % GameConstants.dailyRewardDays;

                  return _RewardDayCard(
                    day: index + 1,
                    coins: reward.reward.amount,
                    isClaimed: isClaimed,
                    isToday: isToday,
                    canClaim: isToday && canClaim,
                    onClaim: () {
                      ref.read(playerProvider.notifier).claimDailyReward();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RewardDayCard extends StatelessWidget {
  final int day;
  final int coins;
  final bool isClaimed;
  final bool isToday;
  final bool canClaim;
  final VoidCallback onClaim;

  const _RewardDayCard({
    required this.day,
    required this.coins,
    required this.isClaimed,
    required this.isToday,
    required this.canClaim,
    required this.onClaim,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isClaimed
            ? AppColors.success.withValues(alpha: 0.1)
            : isToday
                ? AppColors.primary.withValues(alpha: 0.1)
                : AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isToday
              ? AppColors.primary
              : isClaimed
                  ? AppColors.success.withValues(alpha: 0.3)
                  : AppColors.cellEmpty.withValues(alpha: 0.3),
          width: isToday ? 2 : 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Day $day',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isToday ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          if (isClaimed)
            const Icon(Icons.check_circle, color: AppColors.success, size: 28)
          else ...[
            const Icon(Icons.monetization_on,
                color: AppColors.coins, size: 24),
            const SizedBox(height: 2),
            Text(
              '$coins',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ],
          if (canClaim) ...[
            const SizedBox(height: 6),
            GestureDetector(
              onTap: onClaim,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Claim',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
