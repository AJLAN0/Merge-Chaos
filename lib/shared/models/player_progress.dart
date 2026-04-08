import 'task.dart';

class PlayerProgress {
  final int coins;
  final Set<String> unlockedCreatureIds;
  final int generatorLevel;
  final int dailyRewardDay;
  final DateTime? lastDailyRewardClaim;
  final int totalMerges;
  final int totalCoinsEarned;
  final List<GameTask> tasks;
  final bool hasCompletedOnboarding;

  const PlayerProgress({
    this.coins = 50,
    this.unlockedCreatureIds = const {},
    this.generatorLevel = 1,
    this.dailyRewardDay = 0,
    this.lastDailyRewardClaim,
    this.totalMerges = 0,
    this.totalCoinsEarned = 0,
    this.tasks = const [],
    this.hasCompletedOnboarding = false,
  });

  PlayerProgress copyWith({
    int? coins,
    Set<String>? unlockedCreatureIds,
    int? generatorLevel,
    int? dailyRewardDay,
    DateTime? lastDailyRewardClaim,
    int? totalMerges,
    int? totalCoinsEarned,
    List<GameTask>? tasks,
    bool? hasCompletedOnboarding,
  }) {
    return PlayerProgress(
      coins: coins ?? this.coins,
      unlockedCreatureIds: unlockedCreatureIds ?? this.unlockedCreatureIds,
      generatorLevel: generatorLevel ?? this.generatorLevel,
      dailyRewardDay: dailyRewardDay ?? this.dailyRewardDay,
      lastDailyRewardClaim: lastDailyRewardClaim ?? this.lastDailyRewardClaim,
      totalMerges: totalMerges ?? this.totalMerges,
      totalCoinsEarned: totalCoinsEarned ?? this.totalCoinsEarned,
      tasks: tasks ?? this.tasks,
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
    );
  }

  Map<String, dynamic> toJson() => {
        'coins': coins,
        'unlockedCreatureIds': unlockedCreatureIds.toList(),
        'generatorLevel': generatorLevel,
        'dailyRewardDay': dailyRewardDay,
        'lastDailyRewardClaim': lastDailyRewardClaim?.toIso8601String(),
        'totalMerges': totalMerges,
        'totalCoinsEarned': totalCoinsEarned,
        'tasks': tasks.map((t) => t.toJson()).toList(),
        'hasCompletedOnboarding': hasCompletedOnboarding,
      };

  factory PlayerProgress.fromJson(Map<String, dynamic> json) {
    return PlayerProgress(
      coins: json['coins'] as int? ?? 50,
      unlockedCreatureIds:
          (json['unlockedCreatureIds'] as List?)?.cast<String>().toSet() ??
              const {},
      generatorLevel: json['generatorLevel'] as int? ?? 1,
      dailyRewardDay: json['dailyRewardDay'] as int? ?? 0,
      lastDailyRewardClaim: json['lastDailyRewardClaim'] != null
          ? DateTime.parse(json['lastDailyRewardClaim'] as String)
          : null,
      totalMerges: json['totalMerges'] as int? ?? 0,
      totalCoinsEarned: json['totalCoinsEarned'] as int? ?? 0,
      tasks: (json['tasks'] as List?)
              ?.map((t) => GameTask.fromJson(t as Map<String, dynamic>))
              .toList() ??
          const [],
      hasCompletedOnboarding: json['hasCompletedOnboarding'] as bool? ?? false,
    );
  }
}
