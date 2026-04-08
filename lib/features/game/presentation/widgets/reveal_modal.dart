import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../shared/models/creature_definition.dart';
import '../../../../shared/widgets/animated_modal.dart';
import '../painters/creature_painters_catalog.dart';
import 'creature_avatar.dart';

/// Full-screen celebration modal for first-time creature discoveries.
class RevealModal extends StatelessWidget {
  final CreatureDefinition creature;
  final VoidCallback onContinue;

  const RevealModal({
    super.key,
    required this.creature,
    required this.onContinue,
  });

  /// Show the reveal modal as an overlay.
  static void show(BuildContext context, CreatureDefinition creature) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      pageBuilder: (context, _, __) => RevealModal(
        creature: creature,
        onContinue: () => Navigator.of(context).pop(),
      ),
      transitionDuration: const Duration(milliseconds: 100),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rarityColor = switch (creature.rarity) {
      Rarity.common => AppColors.rarityCommon,
      Rarity.uncommon => AppColors.rarityUncommon,
      Rarity.rare => AppColors.rarityRare,
      Rarity.epic => AppColors.rarityEpic,
      Rarity.legendary => AppColors.rarityLegendary,
    };

    return AnimatedModal(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // "New Discovery!" header
            Text(
              'New Discovery!',
              style: TextStyle(
                color: AppColors.coins,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: AppColors.coins.withValues(alpha: 0.5),
                    blurRadius: 12,
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(duration: 400.ms)
                .slideY(begin: -0.3, end: 0, duration: 400.ms),

            const SizedBox(height: 24),

            // Creature avatar — big, with sparkle
            Stack(
              alignment: Alignment.center,
              children: [
                // Sparkle ring
                _SparkleRing(color: rarityColor),
                // Creature
                CreatureAvatar(
                  creatureId: creature.id,
                  size: 120,
                  showAura: true,
                ),
              ],
            )
                .animate()
                .scale(
                  begin: const Offset(0.3, 0.3),
                  end: const Offset(1, 1),
                  duration: 600.ms,
                  curve: Curves.elasticOut,
                )
                .fadeIn(duration: 300.ms),

            const SizedBox(height: 20),

            // Creature name
            Text(
              creature.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn(delay: 300.ms, duration: 400.ms),

            const SizedBox(height: 8),

            // Rarity badge
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: rarityColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: rarityColor, width: 1),
              ),
              child: Text(
                creature.rarity.displayName,
                style: TextStyle(
                  color: rarityColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ).animate().fadeIn(delay: 400.ms, duration: 400.ms),

            const SizedBox(height: 16),

            // Funny description
            Text(
              '"${creature.description}"',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 15,
                fontStyle: FontStyle.italic,
                height: 1.4,
              ),
            ).animate().fadeIn(delay: 500.ms, duration: 400.ms),

            const SizedBox(height: 8),

            // Coins reward
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.monetization_on,
                    color: AppColors.coins, size: 18),
                const SizedBox(width: 4),
                Text(
                  '+${creature.mergeRewardCoins}',
                  style: const TextStyle(
                    color: AppColors.coins,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 600.ms, duration: 400.ms),

            const SizedBox(height: 28),

            // Continue button
            ElevatedButton(
              onPressed: onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 48, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            )
                .animate()
                .fadeIn(delay: 700.ms, duration: 400.ms)
                .slideY(begin: 0.3, end: 0, delay: 700.ms, duration: 400.ms),
          ],
        ),
      ),
    );
  }
}

/// Animated sparkle ring around the creature.
class _SparkleRing extends StatefulWidget {
  final Color color;
  const _SparkleRing({required this.color});

  @override
  State<_SparkleRing> createState() => _SparkleRingState();
}

class _SparkleRingState extends State<_SparkleRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          size: const Size(160, 160),
          painter: _SparkleRingPainter(
            color: widget.color,
            progress: _controller.value,
          ),
        );
      },
    );
  }
}

class _SparkleRingPainter extends CustomPainter {
  final Color color;
  final double progress;

  _SparkleRingPainter({required this.color, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.45;

    for (int i = 0; i < 8; i++) {
      final angle = (i / 8 * 2 * pi) + (progress * 2 * pi);
      final x = cx + cos(angle) * r;
      final y = cy + sin(angle) * r;
      final sparkleSize = 3.0 + sin(progress * pi * 2 + i) * 2;

      final paint = Paint()
        ..color = color.withValues(alpha: 0.6 + sin(progress * pi * 2 + i) * 0.4)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), sparkleSize, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SparkleRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
