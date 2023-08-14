import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_xy/widgets/xy_app_bar.dart';

import '../../r.dart';

class ImageSwitchPage extends StatefulWidget {
  const ImageSwitchPage({Key? key}) : super(key: key);

  @override
  State<ImageSwitchPage> createState() => _ImageSwitchPageState();
}

class _ImageSwitchPageState extends State<ImageSwitchPage> {
  var imgList = [R.img1_jpg, R.img2_jpg, R.img3_jpg];

  var deviationRatio = 0.8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: XYAppBar(
        title: "3D画廊",
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ImageSwitchWidget(
                  deviationRatio: deviationRatio,
                  childWidth: 150,
                  childHeight: 150,
                  children: [
                    Image.asset(
                      R.image1_webp,
                    ),
                    Image.asset(
                      R.image2_webp,
                    ),
                    Image.asset(
                      R.image3_jpg,
                    ),
                    Image.asset(
                      R.image4_webp,
                    ),
                    Image.asset(
                      R.image5_webp,
                    ),
                    Image.asset(
                      R.image6_webp,
                    ),
                    Image.asset(
                      R.image7_webp,
                    ),
                  ]),
            ),
            Slider(
              value: deviationRatio,
              onChanged: (value) {
                setState(() {
                  deviationRatio = value;
                });
              },
            )
          ],
        ),
      ),
    );
  }
}

class ImageSwitchWidget extends StatefulWidget {
  const ImageSwitchWidget({
    Key? key,
    this.children,
    this.childWidth = 80,
    this.childHeight = 80,
    this.deviationRatio = 0.8,
    this.minScale = 0.4,
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

  @override
  State<StatefulWidget> createState() => ImageSwitchState();
}

class ImageSwitchState extends State<ImageSwitchWidget>
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

  late AnimationController _controller;
  late Animation<double> animation;

  late double velocityX;

  @override
  void initState() {
    super.initState();
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
        if (status == AnimationStatus.completed) {}
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
        onHorizontalDragCancel: () {},
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
                  child: Transform(
                    transform: Matrix4.rotationY(radian(point.angle)),
                    alignment: AlignmentDirectional.center,
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 16,
                            offset: const Offset(0, 16),
                          ),
                        ],
                      ),
                      child: widget.children![point.index],
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        ),
      );
    });
  }

  ///角度转弧度
  double radian(double angle) {
    return angle * pi / 180;
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
