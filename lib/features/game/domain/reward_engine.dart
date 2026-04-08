import '../../../core/constants/game_constants.dart';
import '../../../shared/models/creature_definition.dart';
import '../../../shared/models/daily_reward.dart';
import '../../../shared/models/reward.dart';
import '../../../shared/models/task.dart';

class RewardEngine {
  /// Calculate coins earned from merging to produce this creature.
  int calculateMergeReward(CreatureDefinition creature) {
    return creature.mergeRewardCoins;
  }

  /// Generate the daily reward for a given day (0-indexed, wraps every 7 days).
  DailyReward getDailyReward(int day) {
    final dayIndex = day % GameConstants.dailyRewardDays;
    return DailyReward(
      day: day,
      reward: Reward.coins(GameConstants.dailyRewardCoins[dayIndex]),
    );
  }

  /// Check if a daily reward can be claimed (once per calendar day).
  bool canClaimDailyReward(DateTime? lastClaim) {
    if (lastClaim == null) return true;
    final now = DateTime.now();
    return now.year != lastClaim.year ||
        now.month != lastClaim.month ||
        now.day != lastClaim.day;
  }

  /// Generate default daily tasks.
  List<GameTask> generateDailyTasks() {
    return [
      const GameTask(
        id: 'daily_merges',
        type: TaskType.merges,
        description: 'Perform 10 merges',
        target: GameConstants.dailyMergeTarget,
        rewardCoins: 50,
      ),
      const GameTask(
        id: 'daily_discover',
        type: TaskType.discoveries,
        description: 'Discover 2 new creatures',
        target: GameConstants.dailyDiscoverTarget,
        rewardCoins: 100,
      ),
      const GameTask(
        id: 'daily_coins',
        type: TaskType.coinsEarned,
        description: 'Earn 500 coins',
        target: GameConstants.dailyCoinsTarget,
        rewardCoins: 75,
      ),
    ];
  }

  /// Update a task's progress based on an action.
  GameTask updateTaskProgress(GameTask task, {int incrementBy = 1}) {
    if (task.claimed) return task;
    final newCurrent = (task.current + incrementBy).clamp(0, task.target);
    return task.copyWith(current: newCurrent);
  }
}
