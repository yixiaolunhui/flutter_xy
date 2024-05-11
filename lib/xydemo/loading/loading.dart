import 'dart:math';

import 'package:flutter/material.dart';

class LoadingView extends StatefulWidget {
  const LoadingView({Key? key}) : super(key: key);

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _radiusAnimation;
  var size = 160.0;

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

    _radiusAnimation = Tween(begin: size / 2, end: 5.0)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _rotationAnimation = Tween<double>(
          begin: _rotationAnimation.value % (2 * pi),
          end: _rotationAnimation.value % (2 * pi) + pi,
        ).chain(CurveTween(curve: Curves.easeInOut)).animate(_controller);
        _radiusAnimation = Tween<double>(
          begin: _radiusAnimation.value == size / 2 ? size / 2 : 5.0,
          end: _radiusAnimation.value == size / 2 ? 5.0 : size / 2,
        ).chain(CurveTween(curve: Curves.easeInOut)).animate(_controller);
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
            for (var i = 0; i < 5; i++)
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..rotateZ(_rotationAnimation.value + i * 0.2),
                child: Container(
                  width: size - i * 30,
                  height: size - i * 30,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[400 - i * 100],
                    borderRadius: BorderRadius.circular(_radiusAnimation.value),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
