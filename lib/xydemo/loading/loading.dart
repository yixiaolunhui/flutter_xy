import 'dart:math';

import 'package:flutter/material.dart';

class LoadingView extends StatefulWidget {
  const LoadingView({super.key});

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView>  with TickerProviderStateMixin{

  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _radiusAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: pi)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_controller);

    _radiusAnimation = Tween(begin: 40.0, end: 5.0)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _rotationAnimation = Tween<double>(
            begin: _rotationAnimation.value % (2 * pi),
            end: _rotationAnimation.value % (2 * pi) + pi)
            .chain(CurveTween(curve: Curves.easeInOut))
            .animate(_controller);
        _radiusAnimation = Tween<double>(
            begin: _radiusAnimation.value == 40.0 ? 40.0 : 5.0,
            end: _radiusAnimation.value == 40.0 ? 5.0 : 40.0)
            .chain(CurveTween(curve: Curves.easeInOut))
            .animate(_controller);
        _controller
          ..reset()
          ..forward();
      }
    });
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
      builder: (BuildContext context, Widget? child) {
        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..rotateZ(_rotationAnimation.value),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.deepPurple[400],
                  borderRadius: BorderRadius.circular(_radiusAnimation.value),
                ),
              ),
            ),
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..rotateZ(_rotationAnimation.value + 0.2),
              child: Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  color: Colors.deepPurple[300],
                  borderRadius: BorderRadius.circular(_radiusAnimation.value),
                ),
              ),
            ),
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..rotateZ(_rotationAnimation.value + 0.4),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.deepPurple[200],
                  borderRadius: BorderRadius.circular(_radiusAnimation.value),
                ),
              ),
            ),
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..rotateZ(_rotationAnimation.value + 0.6),
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.deepPurple[100],
                  borderRadius: BorderRadius.circular(_radiusAnimation.value),
                ),
              ),
            ),
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..rotateZ(_rotationAnimation.value + 0.8),
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.deepPurple[50],
                  borderRadius: BorderRadius.circular(_radiusAnimation.value),
                ),
              ),
            ),

            // positioned text at the bottom says 加载中...
            Positioned(
              bottom: -40,
              child: Text(
                "加载中...",
                style: TextStyle(
                  color: Colors.deepPurple[400],
                  fontSize: 20,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
