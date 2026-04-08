import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../shared/models/creature_definition.dart';
import '../../../game/presentation/painters/creature_painters_catalog.dart';
import '../../../game/presentation/widgets/creature_avatar.dart';

class CreatureDetailSheet extends StatelessWidget {
  final CreatureDefinition creature;

  const CreatureDetailSheet({super.key, required this.creature});

  static void show(BuildContext context, CreatureDefinition creature) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CreatureDetailSheet(creature: creature),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tierColor = CreaturePaintersCatalog.getColor(creature.tier);
    final rarityColor = switch (creature.rarity) {
      Rarity.common => AppColors.rarityCommon,
      Rarity.uncommon => AppColors.rarityUncommon,
      Rarity.rare => AppColors.rarityRare,
      Rarity.epic => AppColors.rarityEpic,
      Rarity.legendary => AppColors.rarityLegendary,
    };

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          // Creature
          CreatureAvatar(
            creatureId: creature.id,
            size: 100,
            showAura: true,
          ),
          const SizedBox(height: 16),

          // Name
          Text(
            creature.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),

          // Tier + Rarity
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: tierColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Tier ${creature.tier}',
                  style: TextStyle(
                    color: tierColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: rarityColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: rarityColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  creature.rarity.displayName,
                  style: TextStyle(
                    color: rarityColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            '"${creature.description}"',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontStyle: FontStyle.italic,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),

          // Merge reward
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.monetization_on,
                  color: AppColors.coins, size: 16),
              const SizedBox(width: 4),
              Text(
                'Merge reward: ${creature.mergeRewardCoins} coins',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
