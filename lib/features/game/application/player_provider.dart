import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/player_progress.dart';
import '../../../shared/models/task.dart';
import '../domain/reward_engine.dart';
import 'game_providers.dart';

final playerProvider =
    StateNotifierProvider<PlayerNotifier, PlayerProgress>((ref) {
  final saveService = ref.read(saveServiceProvider);
  final rewardEngine = ref.read(rewardEngineProvider);
  final loaded = saveService.loadProgress();

  // Generate daily tasks if empty
  var progress = loaded;
  if (progress.tasks.isEmpty) {
    progress = progress.copyWith(tasks: rewardEngine.generateDailyTasks());
  }

  return PlayerNotifier(progress, ref);
});

class PlayerNotifier extends StateNotifier<PlayerProgress> {
  final Ref _ref;

  PlayerNotifier(super.state, this._ref);

  void _save() {
    _ref.read(saveServiceProvider).saveProgress(state);
  }

  void addCoins(int amount) {
    state = state.copyWith(
      coins: state.coins + amount,
      totalCoinsEarned: state.totalCoinsEarned + amount,
    );
    // Update coins task
    _updateTask(TaskType.coinsEarned, amount);
    _save();
  }

  bool spendCoins(int amount) {
    if (state.coins < amount) return false;
    state = state.copyWith(coins: state.coins - amount);
    _save();
    return true;
  }

  void unlockCreature(String creatureId) {
    if (state.unlockedCreatureIds.contains(creatureId)) return;
    final newSet = {...state.unlockedCreatureIds, creatureId};
    state = state.copyWith(unlockedCreatureIds: newSet);
    _updateTask(TaskType.discoveries, 1);
    _save();
  }

  void recordMerge() {
    state = state.copyWith(totalMerges: state.totalMerges + 1);
    _updateTask(TaskType.merges, 1);
    _save();
  }

  void upgradeGenerator() {
    state = state.copyWith(generatorLevel: state.generatorLevel + 1);
    _save();
  }

  bool claimDailyReward() {
    final rewardEngine = _ref.read(rewardEngineProvider);
    if (!rewardEngine.canClaimDailyReward(state.lastDailyRewardClaim)) {
      return false;
    }

    final reward = rewardEngine.getDailyReward(state.dailyRewardDay);
    state = state.copyWith(
      coins: state.coins + reward.reward.amount,
      dailyRewardDay: state.dailyRewardDay + 1,
      lastDailyRewardClaim: DateTime.now(),
    );
    _save();
    return true;
  }

  void claimTaskReward(String taskId) {
    final tasks = state.tasks.map((t) {
      if (t.id == taskId && t.isComplete && !t.claimed) {
        addCoins(t.rewardCoins);
        return t.copyWith(claimed: true);
      }
      return t;
    }).toList();
    state = state.copyWith(tasks: tasks);
    _save();
  }

  void completeOnboarding() {
    state = state.copyWith(hasCompletedOnboarding: true);
    _save();
  }

  void _updateTask(TaskType type, int amount) {
    final tasks = state.tasks.map((t) {
      if (t.type == type && !t.claimed) {
        return t.copyWith(current: (t.current + amount).clamp(0, t.target));
      }
      return t;
    }).toList();
    state = state.copyWith(tasks: tasks);
  }
}
