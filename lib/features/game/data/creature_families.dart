import '../../../shared/models/creature_definition.dart';

/// All creature definitions in the game, indexed by id.
final Map<String, CreatureDefinition> allCreatures = {
  for (final c in chaosCatsFamily) c.id: c,
};

/// The Chaos Cats evolution family — 10 tiers of escalating feline absurdity.
const List<CreatureDefinition> chaosCatsFamily = [
  CreatureDefinition(
    id: 'chaos_cats_1',
    name: 'Cat',
    familyId: 'chaos_cats',
    tier: 1,
    rarity: Rarity.common,
    description: 'Just a regular cat. Nothing suspicious.',
    mergeRewardCoins: 1,
  ),
  CreatureDefinition(
    id: 'chaos_cats_2',
    name: 'Ninja Cat',
    familyId: 'chaos_cats',
    tier: 2,
    rarity: Rarity.common,
    description: 'Learned stealth from watching too many movies.',
    mergeRewardCoins: 3,
  ),
  CreatureDefinition(
    id: 'chaos_cats_3',
    name: 'Laser Cat',
    familyId: 'chaos_cats',
    tier: 3,
    rarity: Rarity.uncommon,
    description: "It doesn't chase mice anymore. It negotiates with dimensions.",
    mergeRewardCoins: 8,
  ),
  CreatureDefinition(
    id: 'chaos_cats_4',
    name: 'Royal Cat',
    familyId: 'chaos_cats',
    tier: 4,
    rarity: Rarity.uncommon,
    description: 'Demands treats via royal decree.',
    mergeRewardCoins: 20,
  ),
  CreatureDefinition(
    id: 'chaos_cats_5',
    name: 'Rocket Cat',
    familyId: 'chaos_cats',
    tier: 5,
    rarity: Rarity.rare,
    description: 'Houston, we have a purr-blem.',
    mergeRewardCoins: 50,
  ),
  CreatureDefinition(
    id: 'chaos_cats_6',
    name: 'Galaxy Cat',
    familyId: 'chaos_cats',
    tier: 6,
    rarity: Rarity.rare,
    description: 'Contains at least three black holes and one hairball.',
    mergeRewardCoins: 120,
  ),
  CreatureDefinition(
    id: 'chaos_cats_7',
    name: 'Time Cat',
    familyId: 'chaos_cats',
    tier: 7,
    rarity: Rarity.epic,
    description: 'Has already seen all nine of its lives. Twice.',
    mergeRewardCoins: 300,
  ),
  CreatureDefinition(
    id: 'chaos_cats_8',
    name: 'Chaos Cat',
    familyId: 'chaos_cats',
    tier: 8,
    rarity: Rarity.epic,
    description: 'Science has gone too far. Continue?',
    mergeRewardCoins: 750,
  ),
  CreatureDefinition(
    id: 'chaos_cats_9',
    name: 'Divine Cat',
    familyId: 'chaos_cats',
    tier: 9,
    rarity: Rarity.legendary,
    description: 'This one is probably illegal in three dimensions.',
    mergeRewardCoins: 2000,
  ),
  CreatureDefinition(
    id: 'chaos_cats_10',
    name: 'Reality Breaker Cat',
    familyId: 'chaos_cats',
    tier: 10,
    rarity: Rarity.legendary,
    description: 'You created something that should not purr this loudly.',
    mergeRewardCoins: 5000,
  ),
];

/// Get creature definition by id.
CreatureDefinition? getCreature(String id) => allCreatures[id];

/// Get the Tier 1 creature for spawning.
CreatureDefinition get spawnCreature => chaosCatsFamily.first;

/// Get next tier creature from current creature id.
CreatureDefinition? getNextTier(String creatureId) {
  final current = allCreatures[creatureId];
  if (current == null || current.isMaxTier) return null;
  return allCreatures[current.nextTierId];
}
