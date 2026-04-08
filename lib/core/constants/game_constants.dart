abstract final class GameConstants {
  // Board dimensions
  static const int boardRows = 6;
  static const int boardCols = 5;
  static const int totalCells = boardRows * boardCols;

  // Economy
  static const int startingCoins = 50;
  static const int baseSpawnCost = 5;
  static const double spawnCostMultiplier = 1.15;
  static const int generatorUpgradeCost = 100;

  // Daily rewards
  static const int dailyRewardDays = 7;
  static const List<int> dailyRewardCoins = [10, 20, 30, 50, 75, 100, 200];

  // Tasks
  static const int dailyMergeTarget = 10;
  static const int dailyDiscoverTarget = 2;
  static const int dailyCoinsTarget = 500;

  // Timing (milliseconds)
  static const int mergeAnimationDuration = 400;
  static const int revealAnimationDuration = 800;
  static const int spawnAnimationDuration = 300;
  static const int coinCounterDuration = 600;

  // Creature family
  static const String chaosCatsFamilyId = 'chaos_cats';
  static const int maxTier = 10;
}
