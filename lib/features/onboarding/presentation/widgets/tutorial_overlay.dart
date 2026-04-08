import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

/// Interactive tutorial overlay that highlights UI elements step-by-step.
/// This is a simplified version — in production, use a spotlight/cutout approach.
class TutorialOverlay extends StatefulWidget {
  final VoidCallback onComplete;

  const TutorialOverlay({super.key, required this.onComplete});

  @override
  State<TutorialOverlay> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends State<TutorialOverlay> {
  int _step = 0;

  static const _steps = [
    _TutorialStep(
      message: 'Tap the Spawn button to create your first cat!',
      icon: Icons.add_circle_outline,
      alignment: Alignment.bottomCenter,
    ),
    _TutorialStep(
      message: 'Spawn another cat — you need two of the same kind.',
      icon: Icons.add_circle_outline,
      alignment: Alignment.bottomCenter,
    ),
    _TutorialStep(
      message: 'Now drag one cat onto the other to merge them!',
      icon: Icons.swipe,
      alignment: Alignment.center,
    ),
    _TutorialStep(
      message: 'Amazing! You discovered a new creature! Keep merging to find more.',
      icon: Icons.auto_awesome,
      alignment: Alignment.center,
    ),
  ];

  void _nextStep() {
    if (_step < _steps.length - 1) {
      setState(() => _step++);
    } else {
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final step = _steps[_step];

    return GestureDetector(
      onTap: _nextStep,
      behavior: HitTestBehavior.translucent,
      child: Container(
        color: Colors.black.withValues(alpha: 0.4),
        child: Align(
          alignment: step.alignment,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(step.icon, size: 40, color: AppColors.primary),
                  const SizedBox(height: 12),
                  Text(
                    step.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Tap to continue',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Step indicator
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(_steps.length, (i) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: i == _step ? 16 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: i == _step
                              ? AppColors.primary
                              : AppColors.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TutorialStep {
  final String message;
  final IconData icon;
  final Alignment alignment;

  const _TutorialStep({
    required this.message,
    required this.icon,
    required this.alignment,
  });
}
