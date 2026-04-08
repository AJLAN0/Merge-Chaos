import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../shared/models/board_unit.dart';
import '../../application/board_provider.dart';
import '../../application/game_providers.dart';
import '../../data/creature_families.dart';
import 'creature_avatar.dart';
import 'reveal_modal.dart';

class BoardCell extends ConsumerWidget {
  final int row;
  final int col;

  const BoardCell({
    super.key,
    required this.row,
    required this.col,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardState = ref.watch(boardProvider);
    final unit = boardState.unitAt(row, col);
    final draggedId = ref.watch(draggedCreatureIdProvider);

    return DragTarget<BoardUnit>(
      onWillAcceptWithDetails: (details) {
        final incoming = details.data;
        if (incoming.row == row && incoming.col == col) return false;

        if (unit == null) return true; // Empty cell — allow move
        // Allow merge if same creature and not same instance
        return incoming.creatureId == unit.creatureId &&
            incoming.instanceId != unit.instanceId &&
            !(getCreature(unit.creatureId)?.isMaxTier ?? true);
      },
      onAcceptWithDetails: (details) {
        final incoming = details.data;
        final boardNotifier = ref.read(boardProvider.notifier);

        if (unit == null) {
          boardNotifier.moveUnit(incoming.row, incoming.col, row, col);
        } else {
          final result = boardNotifier.mergeUnits(
              incoming.row, incoming.col, row, col);
          if (result != null && result.isNewDiscovery) {
            // Show reveal modal for first-time discoveries
            RevealModal.show(context, result.mergedCreature);
          }
        }
        ref.read(draggedCreatureIdProvider.notifier).state = null;
      },
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;
        final canMerge = isHovering && unit != null;
        final canPlace = isHovering && unit == null;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: canMerge
                ? AppColors.cellHoverMerge.withValues(alpha: 0.3)
                : canPlace
                    ? AppColors.cellHoverPlace.withValues(alpha: 0.3)
                    : AppColors.cellEmpty.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: canMerge
                  ? AppColors.cellHoverMerge
                  : canPlace
                      ? AppColors.cellHoverPlace
                      : AppColors.cellEmpty.withValues(alpha: 0.5),
              width: isHovering ? 2 : 1,
            ),
            boxShadow: isHovering
                ? [
                    BoxShadow(
                      color: (canMerge
                              ? AppColors.cellHoverMerge
                              : AppColors.cellHoverPlace)
                          .withValues(alpha: 0.4),
                      blurRadius: 8,
                    ),
                  ]
                : null,
          ),
          child: unit != null
              ? _buildDraggableUnit(ref, unit, draggedId)
              : _buildEmptyCell(),
        );
      },
    );
  }

  Widget _buildDraggableUnit(WidgetRef ref, BoardUnit unit, String? draggedId) {
    return LongPressDraggable<BoardUnit>(
      data: unit,
      delay: const Duration(milliseconds: 100),
      onDragStarted: () {
        ref.read(draggedCreatureIdProvider.notifier).state = unit.creatureId;
      },
      onDragEnd: (_) {
        ref.read(draggedCreatureIdProvider.notifier).state = null;
      },
      onDraggableCanceled: (_, __) {
        ref.read(draggedCreatureIdProvider.notifier).state = null;
      },
      feedback: Material(
        color: Colors.transparent,
        child: Transform.scale(
          scale: 1.15,
          child: Opacity(
            opacity: 0.85,
            child: CreatureAvatar(
              creatureId: unit.creatureId,
              size: 60,
              showAura: true,
            ),
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: Center(
          child: CreatureAvatar(
            creatureId: unit.creatureId,
            size: 48,
            showAura: false,
          ),
        ),
      ),
      child: Center(
        child: CreatureAvatar(
          creatureId: unit.creatureId,
          size: 48,
          showAura: true,
          showTierBadge: true,
        ),
      ),
    );
  }

  Widget _buildEmptyCell() {
    return Center(
      child: CustomPaint(
        size: const Size(24, 24),
        painter: _DashedBorderPainter(),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.cellEmpty.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.4;
    canvas.drawCircle(Offset(cx, cy), r, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
