import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../shared/models/task.dart';
import '../../../game/application/player_provider.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(playerProvider.select((p) => p.tasks));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Daily Tasks'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: tasks.isEmpty
          ? const Center(
              child: Text(
                'No tasks available',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: tasks.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final task = tasks[index];
                return _TaskCard(
                  task: task,
                  onClaim: () {
                    ref
                        .read(playerProvider.notifier)
                        .claimTaskReward(task.id);
                  },
                );
              },
            ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final GameTask task;
  final VoidCallback onClaim;

  const _TaskCard({required this.task, required this.onClaim});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getTaskIcon(task.type),
                size: 20,
                color: task.claimed
                    ? AppColors.success
                    : task.isComplete
                        ? AppColors.coins
                        : AppColors.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  task.description,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: task.claimed
                        ? AppColors.textSecondary
                        : AppColors.textPrimary,
                    decoration:
                        task.claimed ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
              if (task.isComplete && !task.claimed)
                GestureDetector(
                  onTap: onClaim,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.monetization_on,
                            color: AppColors.coins, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '${task.rewardCoins}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else if (task.claimed)
                const Icon(Icons.check_circle,
                    color: AppColors.success, size: 22)
              else
                Text(
                  '+${task.rewardCoins}',
                  style: const TextStyle(
                    color: AppColors.coins,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: task.progress,
              backgroundColor: AppColors.primary.withValues(alpha: 0.08),
              valueColor: AlwaysStoppedAnimation<Color>(
                task.claimed
                    ? AppColors.success
                    : task.isComplete
                        ? AppColors.coins
                        : AppColors.primary,
              ),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${task.current} / ${task.target}',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getTaskIcon(TaskType type) {
    return switch (type) {
      TaskType.merges => Icons.merge_type,
      TaskType.discoveries => Icons.auto_awesome,
      TaskType.coinsEarned => Icons.monetization_on,
    };
  }
}
