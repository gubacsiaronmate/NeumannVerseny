import 'package:flutter/material.dart';

enum FadeInDirection { up, down, left, right }

extension FadeInDirectionExtension on FadeInDirection {
  bool get isHorizontal => this == FadeInDirection.left || this == FadeInDirection.right;
}

class FadeInAnimation extends StatefulWidget {
  const FadeInAnimation({
    super.key,
    required this.child,
    required this.duration,
    required this.startDelay,
    this.direction = FadeInDirection.up,
    this.distance = 30.0,
    this.curve = Curves.easeOut,
    this.onCompleted,
  });

  final Widget child;
  final Duration duration;
  final Duration startDelay;
  final FadeInDirection direction;
  final double distance;
  final Curve curve;
  final VoidCallback? onCompleted;

  @override
  State<FadeInAnimation> createState() => _FadeInAnimationState();
}

class _FadeInAnimationState extends State<FadeInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _translateAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    final curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    // Set up animations
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    _setupTranslationAnimation(curvedAnimation);

    // Add completion listener
    _controller.addStatusListener(_handleAnimationStatus);

    // Start animation after delay
    Future.delayed(widget.startDelay, () {
      if (mounted) _controller.forward();
    });
  }

  void _setupTranslationAnimation(CurvedAnimation curvedAnimation) {
    double beginOffset;
    switch (widget.direction) {
      case FadeInDirection.up:
        beginOffset = widget.distance;
        break;
      case FadeInDirection.down:
        beginOffset = -widget.distance;
        break;
      case FadeInDirection.left:
        beginOffset = -widget.distance;
        break;
      case FadeInDirection.right:
        beginOffset = widget.distance;
        break;
    }

    _translateAnimation = Tween<double>(
      begin: beginOffset,
      end: 0,
    ).animate(curvedAnimation);
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      widget.onCompleted?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: widget.direction.isHorizontal
              ? Offset(_translateAnimation.value, 0)
              : Offset(0, _translateAnimation.value),
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_handleAnimationStatus);
    _controller.dispose();
    super.dispose();
  }
}