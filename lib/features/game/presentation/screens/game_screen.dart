import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../collection/application/collection_provider.dart';
import '../../application/player_provider.dart';
import '../widgets/currency_bar.dart';
import '../widgets/merge_board.dart';
import '../widgets/spawn_button.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discovered = ref.watch(discoveredCountProvider);
    final total = ref.watch(totalCreatureCountProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                    onPressed: () => context.go('/home'),
                    color: AppColors.textPrimary,
                  ),
                  const Spacer(),
                  const CurrencyBar(),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.settings_outlined, size: 22),
                    onPressed: () => context.push('/settings'),
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),

            // Progress indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Icon(Icons.catching_pokemon,
                      size: 16, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text(
                    '$discovered / $total discovered',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => context.push('/collection'),
                    child: Row(
                      children: [
                        Text(
                          'Collection',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(Icons.chevron_right,
                            size: 16, color: AppColors.primary),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Merge board
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: const MergeBoard(),
              ),
            ),

            const SizedBox(height: 16),

            // Bottom action bar
            Padding(
              padding:
                  const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _BottomAction(
                    icon: Icons.checklist,
                    label: 'Tasks',
                    onTap: () => context.push('/tasks'),
                  ),
                  const SpawnButton(),
                  _BottomAction(
                    icon: Icons.card_giftcard,
                    label: 'Rewards',
                    onTap: () => context.push('/daily-rewards'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _BottomAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, size: 22, color: AppColors.primary),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
