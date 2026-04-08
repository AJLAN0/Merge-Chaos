enum Rarity {
  common,
  uncommon,
  rare,
  epic,
  legendary;

  String get displayName {
    return switch (this) {
      common => 'Common',
      uncommon => 'Uncommon',
      rare => 'Rare',
      epic => 'Epic',
      legendary => 'Legendary',
    };
  }
}

class CreatureDefinition {
  final String id;
  final String name;
  final String familyId;
  final int tier;
  final Rarity rarity;
  final String description;
  final int mergeRewardCoins;

  const CreatureDefinition({
    required this.id,
    required this.name,
    required this.familyId,
    required this.tier,
    required this.rarity,
    required this.description,
    required this.mergeRewardCoins,
  });

  /// Returns the next creature id in the evolution chain.
  /// Convention: family_tier (e.g., 'chaos_cats_1', 'chaos_cats_2')
  String? get nextTierId {
    if (tier >= 10) return null;
    return '${familyId}_${tier + 1}';
  }

  bool get isMaxTier => tier >= 10;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreatureDefinition &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'CreatureDefinition($name, tier: $tier)';
}
