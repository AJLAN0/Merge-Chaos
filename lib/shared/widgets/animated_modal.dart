import 'package:flutter/material.dart';

/// Reusable animated modal that fades in with a scale bounce.
class AnimatedModal extends StatefulWidget {
  final Widget child;
  final VoidCallback? onDismiss;

  const AnimatedModal({
    super.key,
    required this.child,
    this.onDismiss,
  });

  @override
  State<AnimatedModal> createState() => _AnimatedModalState();
}

class _AnimatedModalState extends State<AnimatedModal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.5, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
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
      builder: (context, child) {
        return Stack(
          children: [
            // Dimmed background
            GestureDetector(
              onTap: widget.onDismiss,
              child: Container(
                color: Colors.black.withValues(
                  alpha: 0.6 * _fadeAnimation.value,
                ),
              ),
            ),
            // Modal content
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: widget.child,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
