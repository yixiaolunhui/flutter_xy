import 'package:flutter/material.dart';

/// 扫描线控件
class ScanLineMovingBar extends StatefulWidget {
  ScanLineMovingBar({
    super.key,
    required this.width,
    required this.height,
    required this.lineColor,
    this.lineHeight = 2,
    this.animDuration = const Duration(seconds: 2),
  });

  final double width;
  final double height;
  final Color lineColor;
  double lineHeight;
  Duration animDuration;

  @override
  ScanLineMovingBarState createState() => ScanLineMovingBarState();
}

class ScanLineMovingBarState extends State<ScanLineMovingBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animDuration,
    );
    _animation = Tween<double>(
      begin: 0,
      end: widget.height,
    ).animate(_controller);
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Positioned(
                top: _animation.value,
                left: 0,
                right: 0,
                child: Container(
                  width: widget.width,
                  height: widget.lineHeight,
                  color: widget.lineColor,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
