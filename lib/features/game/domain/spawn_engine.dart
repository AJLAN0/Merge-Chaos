import 'dart:math';

import 'package:uuid/uuid.dart';

import '../../../core/constants/game_constants.dart';
import '../../../shared/models/board_state.dart';
import '../../../shared/models/board_unit.dart';
import '../../../shared/models/creature_definition.dart';
import '../data/creature_families.dart';

const _uuid = Uuid();
final _random = Random();

class SpawnResult {
  final BoardState newBoardState;
  final BoardUnit spawnedUnit;
  final CreatureDefinition creature;

  const SpawnResult({
    required this.newBoardState,
    required this.spawnedUnit,
    required this.creature,
  });
}

class SpawnEngine {
  /// Check if the board has room for a new unit.
  bool canSpawn(BoardState boardState) => boardState.hasEmptyCell;

  /// Calculate spawn cost based on generator level.
  int getSpawnCost(int generatorLevel) {
    return (GameConstants.baseSpawnCost *
            pow(GameConstants.spawnCostMultiplier, generatorLevel - 1))
        .round();
  }

  /// Spawn a Tier 1 creature at a random empty cell.
  SpawnResult? spawn(BoardState boardState) {
    if (!canSpawn(boardState)) return null;

    // Collect all empty cells
    final emptyCells = <(int, int)>[];
    for (int r = 0; r < GameConstants.boardRows; r++) {
      for (int c = 0; c < GameConstants.boardCols; c++) {
        if (boardState.unitAt(r, c) == null) {
          emptyCells.add((r, c));
        }
      }
    }

    if (emptyCells.isEmpty) return null;

    // Pick a random empty cell
    final (row, col) = emptyCells[_random.nextInt(emptyCells.length)];
    final creature = spawnCreature;

    final unit = BoardUnit(
      instanceId: _uuid.v4(),
      creatureId: creature.id,
      row: row,
      col: col,
    );

    final newState = boardState.withUnit(row, col, unit);

    return SpawnResult(
      newBoardState: newState,
      spawnedUnit: unit,
      creature: creature,
    );
  }
}
