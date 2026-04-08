import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../application/board_provider.dart';
import '../../application/game_providers.dart';
import '../../application/player_provider.dart';
import '../../domain/spawn_engine.dart';

class SpawnButton extends ConsumerStatefulWidget {
  const SpawnButton({super.key});

  @override
  ConsumerState<SpawnButton> createState() => _SpawnButtonState();
}

class _SpawnButtonState extends ConsumerState<SpawnButton> {
  bool _animating = false;

  @override
  Widget build(BuildContext context) {
    final player = ref.watch(playerProvider);
    final boardState = ref.watch(boardProvider);
    final spawnEngine = ref.read(spawnEngineProvider);

    final cost = spawnEngine.getSpawnCost(player.generatorLevel);
    final canAfford = player.coins >= cost;
    final hasSpace = boardState.hasEmptyCell;
    final enabled = canAfford && hasSpace && !_animating;

    return GestureDetector(
      onTap: enabled ? _onSpawn : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          gradient: enabled
              ? const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                )
              : null,
          color: enabled ? null : Colors.grey.shade400,
          borderRadius: BorderRadius.circular(20),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add_circle_outline,
                color: Colors.white, size: 22),
            const SizedBox(width: 8),
            Text(
              'Spawn',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.monetization_on,
                      color: AppColors.coins, size: 14),
                  const SizedBox(width: 3),
                  Text(
                    '$cost',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        .animate(target: _animating ? 1 : 0)
        .scale(
          begin: const Offset(1, 1),
          end: const Offset(0.92, 0.92),
          duration: 100.ms,
        )
        .then()
        .scale(
          begin: const Offset(0.92, 0.92),
          end: const Offset(1, 1),
          duration: 150.ms,
        );
  }

  void _onSpawn() {
    setState(() => _animating = true);
    final success = ref.read(boardProvider.notifier).spawnUnit();

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot spawn!'),
          duration: Duration(seconds: 1),
        ),
      );
    }

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _animating = false);
    });
  }
}
