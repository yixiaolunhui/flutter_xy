import 'dart:math';

import 'package:flutter/material.dart';

/// 表情下落动画
class EmojiAnimWidget extends StatefulWidget {
  const EmojiAnimWidget(
      {Key? key,
      required this.width,
      required this.height,
      this.emojiNum = 6,
      this.duration = const Duration(seconds: 5)})
      : super(key: key);

  final double width;
  final double height;
  final int emojiNum;
  final Duration duration;

  @override
  State<EmojiAnimWidget> createState() => EmojiAnimWidgetState();
}

class EmojiAnimWidgetState extends State<EmojiAnimWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  List<Widget>? _emojis;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// 开始表情动画
  void startEmojiAnim(String emoji) {
    _emojis = List.generate(widget.emojiNum, (index) {
      var delay = Random().nextInt(150).toDouble() + 50;
      var fontSize = Random().nextInt(9).toDouble() + 18.0;
      var animation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(delay / 500, (delay + 300) / 500, curve: Curves.linear),
      ));
      return AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          var opacity = 1 - animation.value;
          return Positioned(
            left: (widget.width - 32) / widget.emojiNum * index,
            top: -delay + animation.value * (widget.height + delay),
            child: Opacity(
              opacity: (opacity > 0.5) ? 1 : opacity,
              child: Container(
                height: 50,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Text(
                  emoji,
                  style: TextStyle(fontSize: fontSize, height: 1.2),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        },
      );
    });
    setState(() {
      _animationController.stop();
      _animationController.repeat();
      _animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_emojis == null) return Container();
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 16, right: 16),
      width: widget.width,
      height: widget.height,
      child: Stack(
        clipBehavior: Clip.none,
        children: _emojis!,
      ),
    );
  }
}
