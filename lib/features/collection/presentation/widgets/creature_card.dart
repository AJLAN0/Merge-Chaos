import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../application/collection_provider.dart';
import '../../../game/presentation/widgets/creature_avatar.dart';
import '../../../game/presentation/painters/creature_painters_catalog.dart';

class CreatureCard extends StatelessWidget {
  final CollectionEntry entry;
  final VoidCallback? onTap;

  const CreatureCard({
    super.key,
    required this.entry,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
          border: entry.isUnlocked
              ? Border.all(
                  color: CreaturePaintersCatalog.getColor(entry.creature.tier)
                      .withValues(alpha: 0.3),
                  width: 1,
                )
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (entry.isUnlocked) ...[
              CreatureAvatar(
                creatureId: entry.creature.id,
                size: 56,
                showAura: false,
              ),
              const SizedBox(height: 6),
              Text(
                entry.creature.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                'Tier ${entry.creature.tier}',
                style: TextStyle(
                  fontSize: 10,
                  color: CreaturePaintersCatalog.getColor(
                      entry.creature.tier),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ] else ...[
              // Locked silhouette
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.cellEmpty.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.question_mark,
                  color: AppColors.textSecondary,
                  size: 24,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Tier ${entry.creature.tier}',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
