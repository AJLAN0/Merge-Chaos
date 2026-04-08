import 'dart:math';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

/// Animated particle burst effect shown at merge point.
class MergeEffect extends StatefulWidget {
  final Offset position;
  final Color color;
  final VoidCallback onComplete;

  const MergeEffect({
    super.key,
    required this.position,
    required this.color,
    required this.onComplete,
  });

  @override
  State<MergeEffect> createState() => _MergeEffectState();
}

class _MergeEffectState extends State<MergeEffect>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Particle> _particles;
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _particles = List.generate(12, (_) {
      final angle = _random.nextDouble() * 2 * pi;
      final speed = 40 + _random.nextDouble() * 60;
      return _Particle(
        angle: angle,
        speed: speed,
        size: 3 + _random.nextDouble() * 5,
        color: _random.nextBool() ? widget.color : AppColors.coins,
      );
    });

    _controller.forward().then((_) => widget.onComplete());
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
          size: Size.infinite,
          painter: _ParticlePainter(
            particles: _particles,
            progress: _controller.value,
            center: widget.position,
          ),
        );
      },
    );
  }
}

class _Particle {
  final double angle;
  final double speed;
  final double size;
  final Color color;

  const _Particle({
    required this.angle,
    required this.speed,
    required this.size,
    required this.color,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;
  final Offset center;

  _ParticlePainter({
    required this.particles,
    required this.progress,
    required this.center,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final dx = center.dx + cos(p.angle) * p.speed * progress;
      final dy = center.dy + sin(p.angle) * p.speed * progress;
      final opacity = (1.0 - progress).clamp(0.0, 1.0);
      final currentSize = p.size * (1.0 - progress * 0.5);

      final paint = Paint()
        ..color = p.color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(dx, dy), currentSize, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
