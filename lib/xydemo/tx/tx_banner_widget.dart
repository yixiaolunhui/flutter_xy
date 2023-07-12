import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

/// 仿腾讯视频Banner效果
/// 这里有一些区别，纯属个人觉得这样更喜欢，所以充当了一下产品，修改了需求不同意见莫怪😁
/// 区别1、手势滑动正经半圆效果，腾讯视频是曲线，这里看个人喜好。
/// 区别2、左滑和右滑圆弧效果和手势方向一样，腾讯视频是相同方向都向右。
/// 区别3、不管左滑右滑都是切换相同的下一个，腾讯视频是不同的。
///
class TxBannerWidget extends StatefulWidget {
  const TxBannerWidget({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  @override
  State<TxBannerWidget> createState() => _TxBannerWidgetState();
}

class _TxBannerWidgetState extends State<TxBannerWidget>
    with TickerProviderStateMixin {
  double _clipFraction = 0.0;
  double _clipFractionCache = 0.0;
  int currentIndex = 0;
  double? scale;
  Timer? _timer;
  late AnimationController _controller;
  late AnimationController _autoController;
  late Animation<double> _animation;

  List<Widget> get bannerWidgets {
    List<Widget> widgetList = [];
    int n = widget.children.length;
    int widgetIndex = currentIndex + n;
    while (widgetIndex >= currentIndex) {
      if (widgetIndex == currentIndex) {
        widgetList.add(
          ClipPath(
            clipper: BannerClipper(clipFraction: _clipFraction),
            child: widget.children[widgetIndex % n],
          ),
        );
      } else {
        widgetList.add(widget.children[widgetIndex % n]);
      }
      widgetIndex--;
    }

    return widgetList.toList();
  }

  @override
  void initState() {
    super.initState();
    // 手势操作后动画
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1, end: 0.0).animate(_controller)
      ..addListener(() {
        setState(() {
          if (_clipFractionCache.abs() >= (scale ?? 0.5)) {
            if (_clipFractionCache > 0) {
              _clipFraction = _clipFractionCache +
                  ((1 + (scale ?? 0.5)) - _clipFractionCache) *
                      (1 - _animation.value);
            } else {
              _clipFraction = _clipFractionCache -
                  ((1 + (scale ?? 0.5)) - _clipFractionCache.abs()) *
                      (1 - _animation.value);
            }
          } else {
            _clipFraction = _clipFractionCache * _animation.value;
          }
        });
      })
      ..addStatusListener((status) {
        setState(() {
          if (status == AnimationStatus.completed && _clipFraction.abs() >= 1) {
            _clipFraction = 0.0;
            currentIndex = currentIndex + 1;
          }
        });
      });

    // 自动切换动画
    _autoController = AnimationController(
      duration: const Duration(milliseconds: 500),
      lowerBound: 0.0,
      upperBound: (1 + (scale ?? 0.5)),
      vsync: this,
    )
      ..addListener(() {
        setState(() {
          _clipFraction = -_autoController.value;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _clipFraction = 0.0;
          currentIndex = currentIndex + 1;
        }
      });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoTimer();
    });
  }

  /// 开启自动切换计时器
  void _startAutoTimer() {
    const duration = Duration(seconds: 3);
    _timer = Timer.periodic(duration, (Timer timer) {
      _clipFraction = 0.0;
      _autoController.reset();
      _autoController.forward();
    });
  }

  /// 停止自动切换计时器
  void _stopAutoTimer() {
    _timer?.cancel();
    _timer = null;
  }

  /// 开启手势抬起后动画
  void _startAnimation() {
    _controller.reset();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _autoController.dispose();
    _stopAutoTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        scale = constraints.maxHeight / constraints.maxWidth;
        return GestureDetector(
          onHorizontalDragDown: (DragDownDetails details) {
            _clipFraction = 0.0;
            _stopAutoTimer();
          },
          onHorizontalDragUpdate: (DragUpdateDetails details) {
            setState(() {
              _clipFraction += details.delta.dx / context.size!.width;
              _clipFractionCache = _clipFraction;
            });
          },
          onHorizontalDragEnd: (DragEndDetails details) {
            _startAnimation();
            _startAutoTimer();
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              ...bannerWidgets,
              Positioned(
                left: 0,
                right: 0,
                bottom: 10,
                child: PointWidget(
                  index: currentIndex % widget.children.length,
                  max: widget.children.length,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

/// 自定义裁剪
class BannerClipper extends CustomClipper<Path> {
  final double clipFraction;

  BannerClipper({required this.clipFraction});

  @override
  Path getClip(Size size) {
    Path path = Path();
    if (clipFraction >= 0) {
      double width = size.width * clipFraction;
      path.moveTo(width, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(width, size.height);
      path.arcTo(
        Rect.fromLTWH(width - size.height, 0, size.height, size.height),
        pi / 2,
        -pi,
        false,
      );
      path.close();
    } else {
      double width = size.width * (1 + clipFraction);
      path.moveTo(0, 0);
      path.lineTo(width, 0);
      path.arcTo(
        Rect.fromLTWH(width, 0, size.height, size.height),
        -pi / 2,
        -pi,
        false,
      );
      path.lineTo(width, size.height);
      path.lineTo(0, size.height);
      path.close();
    }
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

/// 游标widget
class PointWidget extends StatelessWidget {
  const PointWidget({
    Key? key,
    required this.max,
    required this.index,
  }) : super(key: key);

  final int max;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [..._pointsWidget()],
    );
  }

  List<Widget> _pointsWidget() {
    List<Widget> points = [];
    for (int i = 0; i < max; i++) {
      points.add(Container(
        margin: const EdgeInsets.only(left: 4),
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: index == i ? Colors.blue : Colors.white,
        ),
      ));
    }
    return points;
  }
}
