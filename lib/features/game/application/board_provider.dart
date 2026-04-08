import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/board_state.dart';
import '../../../shared/models/board_unit.dart';
import '../domain/merge_engine.dart';
import 'game_providers.dart';
import 'player_provider.dart';

final boardProvider =
    StateNotifierProvider<BoardNotifier, BoardState>((ref) {
  final saveService = ref.read(saveServiceProvider);
  final loaded = saveService.loadBoardState();
  return BoardNotifier(loaded, ref);
});

class BoardNotifier extends StateNotifier<BoardState> {
  final Ref _ref;

  BoardNotifier(super.state, this._ref);

  void _save() {
    _ref.read(saveServiceProvider).saveBoardState(state);
  }

  /// Spawn a new Tier 1 unit. Returns true if successful.
  bool spawnUnit() {
    final spawnEngine = _ref.read(spawnEngineProvider);
    final playerNotifier = _ref.read(playerProvider.notifier);
    final player = _ref.read(playerProvider);

    final cost = spawnEngine.getSpawnCost(player.generatorLevel);
    if (!playerNotifier.spendCoins(cost)) return false;

    final result = spawnEngine.spawn(state);
    if (result == null) {
      // Refund if board is full
      playerNotifier.addCoins(cost);
      return false;
    }

    state = result.newBoardState;

    // Unlock the base creature if not yet discovered
    playerNotifier.unlockCreature(result.creature.id);

    _ref.read(audioServiceProvider).playSpawn();
    _ref.read(hapticsServiceProvider).lightTap();
    _save();
    return true;
  }

  /// Merge units at (fromRow, fromCol) into (toRow, toCol).
  /// Returns MergeResult if successful, null otherwise.
  MergeResult? mergeUnits(int fromRow, int fromCol, int toRow, int toCol) {
    final mergeEngine = _ref.read(mergeEngineProvider);
    final playerNotifier = _ref.read(playerProvider.notifier);
    final player = _ref.read(playerProvider);

    final result = mergeEngine.merge(
      boardState: state,
      fromRow: fromRow,
      fromCol: fromCol,
      toRow: toRow,
      toCol: toCol,
      unlockedCreatureIds: player.unlockedCreatureIds,
    );

    if (result == null) return null;

    state = result.newBoardState;
    playerNotifier.addCoins(result.coinsEarned);
    playerNotifier.recordMerge();

    if (result.isNewDiscovery) {
      playerNotifier.unlockCreature(result.mergedCreature.id);
    }

    _ref.read(audioServiceProvider).playMerge();
    _ref.read(hapticsServiceProvider).mediumImpact();
    _save();
    return result;
  }

  /// Move a unit to an empty cell.
  bool moveUnit(int fromRow, int fromCol, int toRow, int toCol) {
    final unit = state.unitAt(fromRow, fromCol);
    if (unit == null) return false;
    if (state.unitAt(toRow, toCol) != null) return false;

    final movedUnit = BoardUnit(
      instanceId: unit.instanceId,
      creatureId: unit.creatureId,
      row: toRow,
      col: toCol,
    );

    var newState = state.withoutUnit(fromRow, fromCol);
    newState = newState.withUnit(toRow, toCol, movedUnit);
    state = newState;
    _save();
    return true;
  }
}
