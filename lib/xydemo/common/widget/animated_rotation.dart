import 'package:flutter/cupertino.dart';

class AnimatedRotation extends StatefulWidget {
  final Duration duration;
  final Widget child;
  final double rotation;

  const AnimatedRotation({
    Key? key,
    this.duration = const Duration(milliseconds: 300),
    required this.child,
    required this.rotation,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AnimatedRotationState();
}

class _AnimatedRotationState extends State<AnimatedRotation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  late double from;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    controller.value = widget.rotation;
    from = widget.rotation;
    animation = Tween<double>(
      begin: from,
      end: widget.rotation,
    ).animate(controller);
  }

  @override
  void didUpdateWidget(covariant AnimatedRotation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.rotation != widget.rotation && from != oldWidget.rotation) {
      from = oldWidget.rotation;
      start();
    }
  }

  void start() {
    animation = Tween<double>(
      begin: from,
      end: widget.rotation,
    ).animate(controller);
    controller.reset();
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: animation,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
