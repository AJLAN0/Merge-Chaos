enum TaskType { merges, discoveries, coinsEarned }

class GameTask {
  final String id;
  final TaskType type;
  final String description;
  final int target;
  final int current;
  final int rewardCoins;
  final bool claimed;

  const GameTask({
    required this.id,
    required this.type,
    required this.description,
    required this.target,
    this.current = 0,
    required this.rewardCoins,
    this.claimed = false,
  });

  bool get isComplete => current >= target;
  double get progress => (current / target).clamp(0.0, 1.0);

  GameTask copyWith({
    int? current,
    bool? claimed,
  }) {
    return GameTask(
      id: id,
      type: type,
      description: description,
      target: target,
      current: current ?? this.current,
      rewardCoins: rewardCoins,
      claimed: claimed ?? this.claimed,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'description': description,
        'target': target,
        'current': current,
        'rewardCoins': rewardCoins,
        'claimed': claimed,
      };

  factory GameTask.fromJson(Map<String, dynamic> json) => GameTask(
        id: json['id'] as String,
        type: TaskType.values.byName(json['type'] as String),
        description: json['description'] as String,
        target: json['target'] as int,
        current: json['current'] as int? ?? 0,
        rewardCoins: json['rewardCoins'] as int,
        claimed: json['claimed'] as bool? ?? false,
      );
}
