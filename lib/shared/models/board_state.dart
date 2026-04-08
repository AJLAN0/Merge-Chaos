import '../../core/constants/game_constants.dart';
import 'board_unit.dart';

class BoardState {
  final List<List<BoardUnit?>> grid;

  const BoardState({required this.grid});

  factory BoardState.empty() {
    return BoardState(
      grid: List.generate(
        GameConstants.boardRows,
        (_) => List.filled(GameConstants.boardCols, null),
      ),
    );
  }

  BoardUnit? unitAt(int row, int col) {
    if (row < 0 ||
        row >= GameConstants.boardRows ||
        col < 0 ||
        col >= GameConstants.boardCols) {
      return null;
    }
    return grid[row][col];
  }

  bool get isFull {
    for (final row in grid) {
      for (final cell in row) {
        if (cell == null) return false;
      }
    }
    return true;
  }

  bool get hasEmptyCell => !isFull;

  int get unitCount {
    int count = 0;
    for (final row in grid) {
      for (final cell in row) {
        if (cell != null) count++;
      }
    }
    return count;
  }

  /// Find first empty cell, returns (row, col) or null if board is full.
  (int, int)? findEmptyCell() {
    for (int r = 0; r < GameConstants.boardRows; r++) {
      for (int c = 0; c < GameConstants.boardCols; c++) {
        if (grid[r][c] == null) return (r, c);
      }
    }
    return null;
  }

  /// Create a deep copy with a modification.
  BoardState withUnit(int row, int col, BoardUnit? unit) {
    final newGrid = List.generate(
      GameConstants.boardRows,
      (r) => List.generate(
        GameConstants.boardCols,
        (c) => (r == row && c == col) ? unit : grid[r][c],
      ),
    );
    return BoardState(grid: newGrid);
  }

  /// Remove a unit at position.
  BoardState withoutUnit(int row, int col) => withUnit(row, col, null);

  /// Serialize for Hive storage.
  Map<String, dynamic> toJson() {
    final units = <Map<String, dynamic>>[];
    for (int r = 0; r < GameConstants.boardRows; r++) {
      for (int c = 0; c < GameConstants.boardCols; c++) {
        final unit = grid[r][c];
        if (unit != null) {
          units.add(unit.toJson());
        }
      }
    }
    return {'units': units};
  }

  factory BoardState.fromJson(Map<String, dynamic> json) {
    final board = BoardState.empty();
    final units = (json['units'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    var state = board;
    for (final unitJson in units) {
      final unit = BoardUnit.fromJson(unitJson);
      state = state.withUnit(unit.row, unit.col, unit);
    }
    return state;
  }
}
