import 'package:flutter/material.dart';

class FadeInAnimation extends StatefulWidget {
  const FadeInAnimation({
    super.key,
    required this.child,
    required this.delay,
    this.axis = Axis.vertical,
    this.distance = 30.0,
  });

  final Widget child;
  final double delay;
  final Axis axis;
  final double distance;

  @override
  State<FadeInAnimation> createState() => _FadeInAnimationState();
}

class _FadeInAnimationState extends State<FadeInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> opacityAnimation;
  late Animation<double> translateAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(milliseconds: (250 * widget.delay).round()),
      vsync: this,
    );

    final curvedAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOut,
    );

    opacityAnimation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    translateAnimation =
        Tween<double>(begin: widget.distance, end: 0).animate(curvedAnimation);

    Future.delayed(Duration(milliseconds: (20 * widget.delay).round()), () {
      if (mounted) {
        controller.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.translate(
          offset: widget.axis == Axis.vertical
              ? Offset(0, translateAnimation.value)
              : Offset(translateAnimation.value, 0),
          child: Opacity(
            opacity: opacityAnimation.value,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
