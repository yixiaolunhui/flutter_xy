import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/*
 * 旋转木马布局
 */
class CarouselWidget extends StatefulWidget {
  const CarouselWidget({
    Key? key,
    this.children,
    this.childWidth = 60,
    this.childHeight = 60,
    this.deviationRatio = 0.2,
    this.minScale = 0.8,
    this.isAuto = false,
    this.autoSweepAngle = 0.2,
    this.circleScale = 1,
  }) : super(key: key);

  //所有的子控件
  final List<Widget>? children;

  //每个子控件的宽
  final double childWidth;

  //每个子控件的高
  final double childHeight;

  //偏移X系数  0-1
  final double deviationRatio;

  //最小缩放比 子控件的滑动时最小比例
  final double minScale;

  //圆形缩放系数
  final double circleScale;

  //是否自动
  final bool isAuto;

  //自动(每时间间隔)旋转角度
  final double autoSweepAngle;

  @override
  State<StatefulWidget> createState() => CarouselState();
}

class CarouselState extends State<CarouselWidget>
    with TickerProviderStateMixin {
  //所有子布局的位置信息
  List<Point> childPointList = [];

  //滑动系数
  final slipRatio = 0.5;

  //开始角度
  double startAngle = 0;

  //旋转角度
  double rotateAngle = 0.0;

  //按下时X坐标
  double downX = 0.0;

  //按下时的角度
  double downAngle = 0.0;

  //大小
  late Size size;

  //半径
  double radius = 0.0;

  //旋转计时器
  Timer? _rotateTimer;

  late AnimationController _controller;

  late AnimationController moveController;

  late Animation<double> animation;

  late double velocityX;

  @override
  void didUpdateWidget(covariant CarouselWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _startRotateTimer();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        setState(() {
          _startRotateTimer();
        });
      }
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.linearToEaseOut,
    );

    animation = Tween<double>(begin: 1, end: 0).animate(animation)
      ..addListener(() {
        //当前速度
        var velocity = animation.value * -velocityX;
        var offsetX = radius != 0 ? velocity * 5 / (2 * pi * radius) : velocity;
        rotateAngle += offsetX;
        setState(() => {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // rotateAngle = rotateAngle % 360;
          _startRotateTimer();
        }
      });
  }

  @override
  void dispose() {
    super.dispose();
    _cancelRotateTimer();
    _controller.dispose();
  }

  ///开始自动旋转计时器
  _startRotateTimer() {
    _cancelRotateTimer();
    if (!widget.isAuto) {
      return;
    }
    _rotateTimer = Timer.periodic(const Duration(milliseconds: 5), (timer) {
      rotateAngle += widget.autoSweepAngle;
      // rotateAngle %= 360; // 取个模 防止数值爆表
      setState(() {});
    });
  }

  ///取消自动旋转计时器
  _cancelRotateTimer() {
    _rotateTimer?.cancel();
    _rotateTimer = null;
  }

  ///子控件集
  List<Point> _childPointList({Size size = Size.zero}) {
    size = Size(
      max(widget.childWidth, size.width * widget.circleScale),
      max(widget.childWidth, size.height * widget.circleScale),
    );
    childPointList.clear(); //清空之前的数据
    if (widget.children?.isNotEmpty ?? false) {
      //子控件数量
      int count = widget.children?.length ?? 0;
      //平均角度
      double averageAngle = 360 / count;
      //半径
      radius = size.width / 2 - widget.childWidth / 2;
      for (int i = 0; i < count; i++) {
        //当前子控件的角度
        double angle = startAngle + averageAngle * i - rotateAngle;
        //当前子控件的中心点坐标  x=width/2+sin(a)*R   y=height/2+cos(a)*R
        var centerX = size.width / 2 + sin(radian(angle)) * radius;
        var centerY = size.height / 2 +
            cos(radian(angle)) * radius * cos(pi / 2 * widget.deviationRatio);
        var minScale = min(widget.minScale, 0.99);
        var scale = (1 - minScale) / 2 * (1 + cos(radian(angle - startAngle))) +
            minScale;
        childPointList.add(Point(
          centerX,
          centerY,
          widget.childWidth * scale,
          widget.childHeight * scale,
          centerX - widget.childWidth * scale / 2,
          centerY - widget.childHeight * scale / 2,
          centerX + widget.childWidth * scale / 2,
          centerY + widget.childHeight * scale / 2,
          scale,
          angle,
          i,
        ));
      }
      childPointList.sort((a, b) {
        return a.scale.compareTo(b.scale);
      });
    }
    return childPointList;
  }

  ///角度转弧度
  ///弧度 =度数 * (π / 180）
  ///度数 =弧度 * (180 / π）
  double radian(double angle) {
    return angle * pi / 180;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (
      BuildContext context,
      BoxConstraints constraints,
    ) {
      var minSize = min(constraints.maxWidth, constraints.maxHeight);
      size = Size(minSize, minSize);
      return GestureDetector(
        ///水平滑动按下
        onHorizontalDragDown: (DragDownDetails details) {
          _cancelRotateTimer(); //取消自动移动
          _controller.stop();
        },

        ///水平滑动开始
        onHorizontalDragStart: (DragStartDetails details) {
          //记录拖动开始时当前的选择角度值
          downAngle = rotateAngle;
          //记录拖动开始时的x坐标
          downX = details.globalPosition.dx;
        },

        ///水平滑动中
        onHorizontalDragUpdate: (DragUpdateDetails details) {
          //滑动中X坐标值
          var updateX = details.globalPosition.dx;
          //计算当前旋转角度值并刷新
          rotateAngle = (downX - updateX) * slipRatio + downAngle;
          if (mounted) setState(() {});
        },

        ///水平滑动结束
        onHorizontalDragEnd: (DragEndDetails details) {
          //x方向上每秒速度的像素数
          velocityX = details.velocity.pixelsPerSecond.dx;
          _controller.reset();
          _controller.forward();
        },

        ///滑动取消
        onHorizontalDragCancel: () {
          _startRotateTimer();
        },
        behavior: HitTestBehavior.opaque,
        child: CustomPaint(
          size: size,
          child: Stack(
            children: _childPointList(size: size).map(
              (Point point) {
                return Positioned(
                    width: point.width,
                    left: point.left,
                    top: point.top,
                    child: widget.children![point.index]);
              },
            ).toList(),
          ),
        ),
      );
    });
  }
}

///子控件属性对象
class Point {
  Point(this.centerX, this.centerY, this.width, this.height, this.left,
      this.top, this.right, this.bottom, this.scale, this.angle, this.index);

  double centerX;
  double centerY;
  double width;
  double height;
  double left;
  double top;
  double right;
  double bottom;
  double scale;
  double angle;
  int index;
}
