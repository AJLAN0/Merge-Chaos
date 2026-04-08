import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../shared/models/creature_definition.dart';
import '../../data/creature_families.dart';
import 'creature_painter.dart';

/// Maps creature IDs to their visual configuration and creates painters.
abstract final class CreaturePaintersCatalog {
  static const Map<int, Color> _tierColors = {
    1: AppColors.tier1,
    2: AppColors.tier2,
    3: AppColors.tier3,
    4: AppColors.tier4,
    5: AppColors.tier5,
    6: AppColors.tier6,
    7: AppColors.tier7,
    8: AppColors.tier8,
    9: AppColors.tier9,
    10: AppColors.tier10,
  };

  /// Get the base color for a creature tier.
  static Color getColor(int tier) => _tierColors[tier] ?? AppColors.tier1;

  /// Create a CustomPainter for a creature by its definition.
  static CreaturePainter getPainter(CreatureDefinition creature,
      {bool showAura = true}) {
    return CreaturePainter(
      tier: creature.tier,
      rarity: creature.rarity,
      baseColor: getColor(creature.tier),
      showAura: showAura,
    );
  }

  /// Create a CustomPainter for a creature by its ID.
  static CreaturePainter? getPainterById(String creatureId,
      {bool showAura = true}) {
    final creature = getCreature(creatureId);
    if (creature == null) return null;
    return getPainter(creature, showAura: showAura);
  }
}
