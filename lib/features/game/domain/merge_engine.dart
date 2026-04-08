import '../../../shared/models/board_state.dart';
import '../../../shared/models/board_unit.dart';
import '../../../shared/models/creature_definition.dart';
import '../data/creature_families.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class MergeResult {
  final BoardState newBoardState;
  final CreatureDefinition mergedCreature;
  final int coinsEarned;
  final bool isNewDiscovery;
  final int targetRow;
  final int targetCol;

  const MergeResult({
    required this.newBoardState,
    required this.mergedCreature,
    required this.coinsEarned,
    required this.isNewDiscovery,
    required this.targetRow,
    required this.targetCol,
  });
}

class MergeEngine {
  /// Check if two board units can be merged (same creature type, not max tier).
  bool canMerge(BoardUnit a, BoardUnit b) {
    if (a.instanceId == b.instanceId) return false;
    if (a.creatureId != b.creatureId) return false;
    final creature = getCreature(a.creatureId);
    return creature != null && !creature.isMaxTier;
  }

  /// Perform a merge: remove both units, create next-tier unit at target position.
  /// Returns null if merge is not possible.
  MergeResult? merge({
    required BoardState boardState,
    required int fromRow,
    required int fromCol,
    required int toRow,
    required int toCol,
    required Set<String> unlockedCreatureIds,
  }) {
    final fromUnit = boardState.unitAt(fromRow, fromCol);
    final toUnit = boardState.unitAt(toRow, toCol);

    if (fromUnit == null || toUnit == null) return null;
    if (!canMerge(fromUnit, toUnit)) return null;

    final nextCreature = getNextTier(fromUnit.creatureId);
    if (nextCreature == null) return null;

    // Create new unit at target position
    final newUnit = BoardUnit(
      instanceId: _uuid.v4(),
      creatureId: nextCreature.id,
      row: toRow,
      col: toCol,
    );

    // Update board: remove source, place new unit at target
    var newState = boardState.withoutUnit(fromRow, fromCol);
    newState = newState.withUnit(toRow, toCol, newUnit);

    final isNew = !unlockedCreatureIds.contains(nextCreature.id);

    return MergeResult(
      newBoardState: newState,
      mergedCreature: nextCreature,
      coinsEarned: nextCreature.mergeRewardCoins,
      isNewDiscovery: isNew,
      targetRow: toRow,
      targetCol: toCol,
    );
  }
}
