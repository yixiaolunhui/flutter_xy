import 'dart:math';
import 'package:flutter/material.dart';

class FullAnimation extends StatefulWidget {
  @override
  _FullAnimationState createState() => _FullAnimationState();
}

class _FullAnimationState extends State<FullAnimation> with TickerProviderStateMixin {
  late AnimationController _circleController;
  late AnimationController _expandContractController;
  late AnimationController _disperseController;
  late Animation<double> _circleAnimation;
  late Animation<double> _expandContractAnimation;
  late Animation<double> _disperseAnimation;

  @override
  void initState() {
    super.initState();

    // Circle Animation Controller
    _circleController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    // Circle Animation
    _circleAnimation = Tween<double>(begin: 0, end: 1).animate(_circleController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _expandContractController.forward();
        }
      });

    // Expand Contract Animation Controller
    _expandContractController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    // Expand Contract Animation
    _expandContractAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1, end: 1.5).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.5, end: 1).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1,
      ),
    ]).animate(_expandContractController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _expandContractController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _expandContractController.forward();
        }
      });

    // Disperse Animation Controller
    _disperseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    // Disperse Animation
    _disperseAnimation = Tween<double>(begin: 0, end: 3).animate(_disperseController);

    _circleController.forward();
  }

  @override
  void dispose() {
    _circleController.dispose();
    _expandContractController.dispose();
    _disperseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: AnimatedBuilder(
              animation: _circleAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: CirclePainter(_circleAnimation.value),
                  child: Container(
                    width: 200,
                    height: 200,
                  ),
                );
              },
            ),
          ),
          Center(
            child: AnimatedBuilder(
              animation: _expandContractAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _expandContractAnimation.value,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [Colors.blue.withOpacity(0.5), Colors.blue.withOpacity(0.1)],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Center(
            child: AnimatedBuilder(
              animation: _disperseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _disperseAnimation.value,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blue.withOpacity(0.5), width: 2),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final double progress;

  CirclePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    double angle = 2 * pi * progress;
    double radius = size.width / 2;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(radius, radius), radius: radius),
      -pi / 2,
      angle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
