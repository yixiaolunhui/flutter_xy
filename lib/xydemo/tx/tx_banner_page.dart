import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_xy/utils/image_utils.dart';

class ImageClippingPage extends StatefulWidget {
  const ImageClippingPage({Key? key}) : super(key: key);

  @override
  _ImageClippingPageState createState() => _ImageClippingPageState();
}

class _ImageClippingPageState extends State<ImageClippingPage>
    with TickerProviderStateMixin {
  double _clipFraction = 0.0;
  double _clipFractionCache = 0.0;
  late AnimationController _controller;
  late AnimationController _autoController;
  late Animation<double> _animation;
  int currentIndex = 0;
  Timer? _timer;

  List<String> imgList = [
    ImageUtils.getImgPath("img1", format: "jpg"),
    ImageUtils.getImgPath("img2", format: "jpg"),
    ImageUtils.getImgPath("img3", format: "jpg"),
    ImageUtils.getImgPath("img4", format: "jpg"),
  ];

  List<Widget> get bannerWidgets {
    List<Widget> widgetList = [];
    int n = imgList.length;
    int widgetIndex = currentIndex + n;
    while (widgetIndex >= currentIndex) {
      if (widgetIndex == currentIndex) {
        widgetList.add(
          ClipPath(
            clipper: ImageClipper(clipFraction: _clipFraction),
            child: Image.asset(
              imgList[widgetIndex % n],
              fit: BoxFit.cover,
            ),
          ),
        );
      } else {
        widgetList.add(
          Image.asset(
            imgList[widgetIndex % n],
            fit: BoxFit.cover,
          ),
        );
      }
      widgetIndex--;
    }

    return widgetList.toList();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1, end: 0.0).animate(_controller)
      ..addListener(() {
        setState(() {
          if (_clipFractionCache.abs() >= 0.5) {
            if (_clipFractionCache > 0) {
              _clipFraction = _clipFractionCache +
                  (1.5 - _clipFractionCache) * (1 - _animation.value);
            } else {
              _clipFraction = _clipFractionCache -
                  (1.5 - _clipFractionCache.abs()) * (1 - _animation.value);
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
    _autoController = AnimationController(
      duration: const Duration(milliseconds: 500),
      lowerBound: 0.0,
      upperBound: 1.5,
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

    _startTimer();
  }

  void _startTimer() {
    const duration = Duration(seconds: 3);
    _timer = Timer.periodic(duration, (Timer timer) {
      _autoController.reset();
      _autoController.forward();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _controller.dispose();
    _autoController.dispose();
    _stopTimer();
    super.dispose();
  }

  void _startAnimation() {
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('腾讯视频Banner'),
      ),
      body: GestureDetector(
        onHorizontalDragDown: (DragDownDetails details) {
          _clipFraction = 0.0;
          _stopTimer();
        },
        onHorizontalDragUpdate: (DragUpdateDetails details) {
          setState(() {
            _clipFraction += details.delta.dx / context.size!.width;
            _clipFractionCache = _clipFraction;
          });
        },
        onHorizontalDragEnd: (DragEndDetails details) {
          _startAnimation();
          _startTimer();
        },
        child: Stack(
          children: [
            ...bannerWidgets,
            Positioned(
              left: 0,
              right: 0,
              bottom: 10,
              child: PointWidget(
                index: currentIndex % imgList.length,
                max: imgList.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ImageClipper extends CustomClipper<Path> {
  final double clipFraction;

  ImageClipper({required this.clipFraction});

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

void main() {
  runApp(const MaterialApp(
    home: ImageClippingPage(),
  ));
}
