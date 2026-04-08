import 'package:flutter/material.dart';

import '../../../../shared/models/creature_definition.dart';
import '../../data/creature_families.dart';
import '../painters/creature_painters_catalog.dart';

class CreatureAvatar extends StatelessWidget {
  final String creatureId;
  final double size;
  final bool showAura;
  final bool showTierBadge;

  const CreatureAvatar({
    super.key,
    required this.creatureId,
    this.size = 56,
    this.showAura = true,
    this.showTierBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    final creature = getCreature(creatureId);
    if (creature == null) {
      return SizedBox(width: size, height: size);
    }

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: CreaturePaintersCatalog.getPainter(
              creature,
              showAura: showAura,
            ),
          ),
          if (showTierBadge) _buildTierBadge(creature),
        ],
      ),
    );
  }

  Widget _buildTierBadge(CreatureDefinition creature) {
    return Positioned(
      right: -2,
      bottom: -2,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
        decoration: BoxDecoration(
          color: CreaturePaintersCatalog.getColor(creature.tier),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: Text(
          '${creature.tier}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
