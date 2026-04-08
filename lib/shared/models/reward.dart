enum RewardType { coins, gems, creature }

class Reward {
  final RewardType type;
  final int amount;
  final String? creatureId;

  const Reward({
    required this.type,
    required this.amount,
    this.creatureId,
  });

  const Reward.coins(this.amount)
      : type = RewardType.coins,
        creatureId = null;
}
