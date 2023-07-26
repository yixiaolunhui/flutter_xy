import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_xy/widgets/xy_app_bar.dart';

class NumAnimPage extends StatefulWidget {
  const NumAnimPage({super.key});

  @override
  State<NumAnimPage> createState() => _NumAnimPageState();
}

class _NumAnimPageState extends State<NumAnimPage> {
  int _currentNum = 0;

  // 数字文本随机颜色
  Color get _numColor {
    Random random = Random();
    int red = random.nextInt(256);
    int green = random.nextInt(256);
    int blue = random.nextInt(256);
    return Color.fromARGB(255, red, green, blue);
  }

  // 数字累加
  void _addNumber() {
    setState(() {
      _currentNum++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: XYAppBar(
        title: "数字动画",
      ),
      body: Center(
        child: _bodyWidget(),
      ),
    );
  }

  Widget _bodyWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            Offset startOffset = animation.status == AnimationStatus.completed
                ? const Offset(0.0, 1.0)
                : const Offset(0.0, -1.0);
            Offset endOffset = const Offset(0.0, 0.0);
            return SlideTransition(
              position: Tween(begin: startOffset, end: endOffset).animate(
                CurvedAnimation(parent: animation, curve: Curves.bounceOut),
              ),
              child: FadeTransition(
                opacity: Tween(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(parent: animation, curve: Curves.linear),
                ),
                child: ScaleTransition(
                  scale: Tween(begin: 0.5, end: 1.0).animate(
                    CurvedAnimation(parent: animation, curve: Curves.linear),
                  ),
                  child: child,
                ),
              ),
            );
          },
          child: Text(
            '$_currentNum',
            key: ValueKey<int>(_currentNum),
            style: TextStyle(fontSize: 100, color: _numColor),
          ),
        ),
        const SizedBox(height: 80),
        ElevatedButton(
          onPressed: _addNumber,
          child: const Text(
            '数字动画',
            style: TextStyle(fontSize: 25, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
