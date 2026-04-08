import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/game_constants.dart';
import 'board_cell.dart';

class MergeBoard extends StatelessWidget {
  const MergeBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.boardBackground.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.boardBackground,
          width: 2,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cellSize = (constraints.maxWidth - 16) / GameConstants.boardCols;

          return SizedBox(
            height: cellSize * GameConstants.boardRows,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: GameConstants.boardCols,
              ),
              itemCount: GameConstants.totalCells,
              itemBuilder: (context, index) {
                final row = index ~/ GameConstants.boardCols;
                final col = index % GameConstants.boardCols;
                return BoardCell(row: row, col: col);
              },
            ),
          );
        },
      ),
    );
  }
}
