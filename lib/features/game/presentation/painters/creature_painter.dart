import 'dart:math';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../shared/models/creature_definition.dart';

/// Base cat painter that all tiers build upon.
/// Each tier adds visual elements on top of the base cat body.
class CreaturePainter extends CustomPainter {
  final int tier;
  final Rarity rarity;
  final Color baseColor;
  final bool showAura;

  CreaturePainter({
    required this.tier,
    required this.rarity,
    required this.baseColor,
    this.showAura = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.32;

    // Rarity aura glow
    if (showAura && rarity.index >= Rarity.uncommon.index) {
      _paintAura(canvas, cx, cy, r, size);
    }

    // Base cat body (circle)
    final bodyPaint = Paint()
      ..color = baseColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx, cy + r * 0.1), r, bodyPaint);

    // Ears
    _paintEars(canvas, cx, cy, r);

    // Eyes
    _paintEyes(canvas, cx, cy, r);

    // Mouth / whiskers
    _paintMouth(canvas, cx, cy, r);

    // Tier-specific overlays
    _paintTierDetails(canvas, size, cx, cy, r);
  }

  void _paintAura(Canvas canvas, double cx, double cy, double r, Size size) {
    final auraColor = switch (rarity) {
      Rarity.uncommon => AppColors.rarityUncommon,
      Rarity.rare => AppColors.rarityRare,
      Rarity.epic => AppColors.rarityEpic,
      Rarity.legendary => AppColors.rarityLegendary,
      _ => Colors.transparent,
    };

    final auraPaint = Paint()
      ..color = auraColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawCircle(Offset(cx, cy + r * 0.1), r * 1.35, auraPaint);
  }

  void _paintEars(Canvas canvas, double cx, double cy, double r) {
    final earPaint = Paint()
      ..color = baseColor
      ..style = PaintingStyle.fill;

    final innerEarPaint = Paint()
      ..color = baseColor.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    // Left ear
    final leftEar = Path()
      ..moveTo(cx - r * 0.7, cy - r * 0.5)
      ..lineTo(cx - r * 0.9, cy - r * 1.3)
      ..lineTo(cx - r * 0.15, cy - r * 0.85)
      ..close();
    canvas.drawPath(leftEar, earPaint);

    final leftInner = Path()
      ..moveTo(cx - r * 0.65, cy - r * 0.6)
      ..lineTo(cx - r * 0.78, cy - r * 1.1)
      ..lineTo(cx - r * 0.25, cy - r * 0.82)
      ..close();
    canvas.drawPath(leftInner, innerEarPaint);

    // Right ear
    final rightEar = Path()
      ..moveTo(cx + r * 0.7, cy - r * 0.5)
      ..lineTo(cx + r * 0.9, cy - r * 1.3)
      ..lineTo(cx + r * 0.15, cy - r * 0.85)
      ..close();
    canvas.drawPath(rightEar, earPaint);

    final rightInner = Path()
      ..moveTo(cx + r * 0.65, cy - r * 0.6)
      ..lineTo(cx + r * 0.78, cy - r * 1.1)
      ..lineTo(cx + r * 0.25, cy - r * 0.82)
      ..close();
    canvas.drawPath(rightInner, innerEarPaint);
  }

  void _paintEyes(Canvas canvas, double cx, double cy, double r) {
    final eyeWhite = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final eyePupil = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.fill;

    // Tier 2 (Ninja) has narrowed eyes
    if (tier == 2) {
      final slitPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      // Narrow eye slits
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx - r * 0.3, cy),
          width: r * 0.35,
          height: r * 0.15,
        ),
        slitPaint,
      );
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx + r * 0.3, cy),
          width: r * 0.35,
          height: r * 0.15,
        ),
        slitPaint,
      );
      canvas.drawCircle(Offset(cx - r * 0.3, cy), r * 0.06, eyePupil);
      canvas.drawCircle(Offset(cx + r * 0.3, cy), r * 0.06, eyePupil);
      return;
    }

    // Tier 3 (Laser) has glowing red eyes
    if (tier == 3) {
      final redGlow = Paint()
        ..color = Colors.red.withValues(alpha: 0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawCircle(Offset(cx - r * 0.3, cy - r * 0.05), r * 0.2, redGlow);
      canvas.drawCircle(Offset(cx + r * 0.3, cy - r * 0.05), r * 0.2, redGlow);
      final redEye = Paint()..color = Colors.red;
      canvas.drawCircle(Offset(cx - r * 0.3, cy - r * 0.05), r * 0.12, redEye);
      canvas.drawCircle(Offset(cx + r * 0.3, cy - r * 0.05), r * 0.12, redEye);
      canvas.drawCircle(Offset(cx - r * 0.3, cy - r * 0.05), r * 0.04, eyePupil);
      canvas.drawCircle(Offset(cx + r * 0.3, cy - r * 0.05), r * 0.04, eyePupil);
      return;
    }

    // Default big cute eyes
    canvas.drawCircle(Offset(cx - r * 0.3, cy - r * 0.05), r * 0.2, eyeWhite);
    canvas.drawCircle(Offset(cx + r * 0.3, cy - r * 0.05), r * 0.2, eyeWhite);
    canvas.drawCircle(Offset(cx - r * 0.3, cy - r * 0.05), r * 0.12, eyePupil);
    canvas.drawCircle(Offset(cx + r * 0.3, cy - r * 0.05), r * 0.12, eyePupil);

    // Eye shine
    final shine = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(cx - r * 0.25, cy - r * 0.1), r * 0.05, shine);
    canvas.drawCircle(Offset(cx + r * 0.35, cy - r * 0.1), r * 0.05, shine);
  }

  void _paintMouth(Canvas canvas, double cx, double cy, double r) {
    final mouthPaint = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Small nose dot
    canvas.drawCircle(
      Offset(cx, cy + r * 0.2),
      r * 0.05,
      Paint()..color = Colors.pinkAccent.shade100,
    );

    // Mouth curve
    final mouth = Path()
      ..moveTo(cx - r * 0.15, cy + r * 0.3)
      ..quadraticBezierTo(cx, cy + r * 0.42, cx + r * 0.15, cy + r * 0.3);
    canvas.drawPath(mouth, mouthPaint);

    // Whiskers
    final whiskerPaint = Paint()
      ..color = Colors.black38
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Left whiskers
    canvas.drawLine(
      Offset(cx - r * 0.2, cy + r * 0.2),
      Offset(cx - r * 0.9, cy + r * 0.05),
      whiskerPaint,
    );
    canvas.drawLine(
      Offset(cx - r * 0.2, cy + r * 0.25),
      Offset(cx - r * 0.9, cy + r * 0.3),
      whiskerPaint,
    );

    // Right whiskers
    canvas.drawLine(
      Offset(cx + r * 0.2, cy + r * 0.2),
      Offset(cx + r * 0.9, cy + r * 0.05),
      whiskerPaint,
    );
    canvas.drawLine(
      Offset(cx + r * 0.2, cy + r * 0.25),
      Offset(cx + r * 0.9, cy + r * 0.3),
      whiskerPaint,
    );
  }

  void _paintTierDetails(
      Canvas canvas, Size size, double cx, double cy, double r) {
    switch (tier) {
      case 2:
        _paintNinjaHeadband(canvas, cx, cy, r);
      case 3:
        _paintLaserBeams(canvas, cx, cy, r, size);
      case 4:
        _paintCrown(canvas, cx, cy, r);
      case 5:
        _paintFlameTrails(canvas, cx, cy, r);
      case 6:
        _paintStars(canvas, size);
      case 7:
        _paintClockMotif(canvas, cx, cy, r);
      case 8:
        _paintGlitchOutline(canvas, cx, cy, r);
      case 9:
        _paintHalo(canvas, cx, cy, r);
      case 10:
        _paintRealityCracks(canvas, size, cx, cy, r);
    }
  }

  void _paintNinjaHeadband(Canvas canvas, double cx, double cy, double r) {
    final bandPaint = Paint()
      ..color = Colors.red.shade700
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(cx, cy - r * 0.35),
        width: r * 2.0,
        height: r * 0.2,
      ),
      bandPaint,
    );
    // Tail ribbons
    final ribbon = Paint()
      ..color = Colors.red.shade700
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawLine(
      Offset(cx + r * 0.9, cy - r * 0.35),
      Offset(cx + r * 1.3, cy - r * 0.15),
      ribbon,
    );
    canvas.drawLine(
      Offset(cx + r * 0.9, cy - r * 0.35),
      Offset(cx + r * 1.2, cy - r * 0.55),
      ribbon,
    );
  }

  void _paintLaserBeams(
      Canvas canvas, double cx, double cy, double r, Size size) {
    final laserPaint = Paint()
      ..color = Colors.red.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    // Beams from eyes to bottom-right
    canvas.drawLine(
      Offset(cx - r * 0.3, cy - r * 0.05),
      Offset(size.width, size.height),
      laserPaint,
    );
    canvas.drawLine(
      Offset(cx + r * 0.3, cy - r * 0.05),
      Offset(size.width, size.height * 0.7),
      laserPaint,
    );
  }

  void _paintCrown(Canvas canvas, double cx, double cy, double r) {
    final crownPaint = Paint()
      ..color = AppColors.rarityLegendary
      ..style = PaintingStyle.fill;
    final crown = Path()
      ..moveTo(cx - r * 0.6, cy - r * 0.85)
      ..lineTo(cx - r * 0.5, cy - r * 1.3)
      ..lineTo(cx - r * 0.2, cy - r * 1.05)
      ..lineTo(cx, cy - r * 1.4)
      ..lineTo(cx + r * 0.2, cy - r * 1.05)
      ..lineTo(cx + r * 0.5, cy - r * 1.3)
      ..lineTo(cx + r * 0.6, cy - r * 0.85)
      ..close();
    canvas.drawPath(crown, crownPaint);

    // Crown gems
    final gemPaint = Paint()..color = Colors.red;
    canvas.drawCircle(Offset(cx, cy - r * 1.15), r * 0.06, gemPaint);
  }

  void _paintFlameTrails(Canvas canvas, double cx, double cy, double r) {
    final flamePaint = Paint()
      ..color = Colors.orange.withValues(alpha: 0.7)
      ..style = PaintingStyle.fill;
    final flame2 = Paint()
      ..color = Colors.yellow.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    // Bottom flame trail
    final flameOuter = Path()
      ..moveTo(cx - r * 0.4, cy + r * 0.9)
      ..quadraticBezierTo(cx - r * 0.2, cy + r * 1.6, cx, cy + r * 1.3)
      ..quadraticBezierTo(cx + r * 0.2, cy + r * 1.6, cx + r * 0.4, cy + r * 0.9)
      ..close();
    canvas.drawPath(flameOuter, flamePaint);

    final flameInner = Path()
      ..moveTo(cx - r * 0.2, cy + r * 0.9)
      ..quadraticBezierTo(cx - r * 0.1, cy + r * 1.35, cx, cy + r * 1.15)
      ..quadraticBezierTo(cx + r * 0.1, cy + r * 1.35, cx + r * 0.2, cy + r * 0.9)
      ..close();
    canvas.drawPath(flameInner, flame2);
  }

  void _paintStars(Canvas canvas, Size size) {
    final starPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;
    // Scatter small stars around
    final positions = [
      Offset(size.width * 0.1, size.height * 0.15),
      Offset(size.width * 0.85, size.height * 0.1),
      Offset(size.width * 0.9, size.height * 0.7),
      Offset(size.width * 0.05, size.height * 0.8),
      Offset(size.width * 0.5, size.height * 0.05),
    ];
    for (final p in positions) {
      canvas.drawCircle(p, 2.5, starPaint);
    }
  }

  void _paintClockMotif(Canvas canvas, double cx, double cy, double r) {
    final clockPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    // Clock circle on belly
    canvas.drawCircle(Offset(cx, cy + r * 0.15), r * 0.35, clockPaint);
    // Clock hands
    canvas.drawLine(
      Offset(cx, cy + r * 0.15),
      Offset(cx, cy - r * 0.08),
      clockPaint,
    );
    canvas.drawLine(
      Offset(cx, cy + r * 0.15),
      Offset(cx + r * 0.2, cy + r * 0.15),
      clockPaint,
    );
  }

  void _paintGlitchOutline(Canvas canvas, double cx, double cy, double r) {
    // Double offset outline for glitch effect
    final glitch1 = Paint()
      ..color = Colors.cyan.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final glitch2 = Paint()
      ..color = Colors.red.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(Offset(cx - 2, cy + r * 0.1 - 1), r, glitch1);
    canvas.drawCircle(Offset(cx + 2, cy + r * 0.1 + 1), r, glitch2);
  }

  void _paintHalo(Canvas canvas, double cx, double cy, double r) {
    final haloPaint = Paint()
      ..color = AppColors.rarityLegendary.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    // Elliptical halo above head
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, cy - r * 1.15),
        width: r * 1.0,
        height: r * 0.3,
      ),
      haloPaint,
    );
    // Radiant lines
    final rayPaint = Paint()
      ..color = AppColors.rarityLegendary.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (int i = 0; i < 8; i++) {
      final angle = (i * pi / 4);
      canvas.drawLine(
        Offset(cx + cos(angle) * r * 1.2, cy + r * 0.1 + sin(angle) * r * 1.2),
        Offset(cx + cos(angle) * r * 1.5, cy + r * 0.1 + sin(angle) * r * 1.5),
        rayPaint,
      );
    }
  }

  void _paintRealityCracks(
      Canvas canvas, Size size, double cx, double cy, double r) {
    // Fractal crack lines
    final crackPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final cracks = [
      [Offset(0, size.height * 0.3), Offset(cx - r, cy)],
      [Offset(size.width, size.height * 0.5), Offset(cx + r, cy)],
      [Offset(size.width * 0.3, 0), Offset(cx, cy - r)],
      [Offset(size.width * 0.7, size.height), Offset(cx, cy + r)],
    ];
    for (final crack in cracks) {
      canvas.drawLine(crack[0], crack[1], crackPaint);
    }

    // Rainbow aura
    final rainbow = Paint()
      ..shader = SweepGradient(
        colors: [
          Colors.red.withValues(alpha: 0.3),
          Colors.orange.withValues(alpha: 0.3),
          Colors.yellow.withValues(alpha: 0.3),
          Colors.green.withValues(alpha: 0.3),
          Colors.blue.withValues(alpha: 0.3),
          Colors.purple.withValues(alpha: 0.3),
          Colors.red.withValues(alpha: 0.3),
        ],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r * 1.4))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(Offset(cx, cy + r * 0.1), r * 1.2, rainbow);
  }

  @override
  bool shouldRepaint(covariant CreaturePainter oldDelegate) {
    return oldDelegate.tier != tier ||
        oldDelegate.rarity != rarity ||
        oldDelegate.baseColor != baseColor;
  }
}
