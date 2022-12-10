import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

///自定义尺子
class RulerView extends StatefulWidget {
  //默认值
  final int value;

  //最小值
  final int minValue;

  //最大值
  final int maxValue;

  //步数 一个刻度的值
  final int step;

  //尺子的宽度
  final int width;

  //尺子的高度
  final int height;

  //每个大刻度的子刻度数
  final int subScaleCountPerScale;

  //每一刻度的宽度
  final int subScaleWidth;

  //左右空白间距宽度
  late double paddingItemWidth;

  //刻度尺选择回调
  final void Function(int) onSelectedChanged;

  //刻度颜色
  final Color scaleColor;

  //指示器颜色
  final Color indicatorColor;

  //刻度文字颜色
  final Color scaleTextColor;

  //刻度文字的大小
  final double scaleTextWidth;

  //刻度线的大小
  final double scaleWidth;

  //计算总刻度数
  late int totalSubScaleCount;

  RulerView({
    Key? key,
    this.value = 10,
    this.minValue = 0,
    this.maxValue = 100,
    this.step = 1,
    this.width = 200,
    this.height = 60,
    this.subScaleCountPerScale = 10,
    this.subScaleWidth = 8,
    this.scaleColor = Colors.black,
    this.scaleWidth = 2,
    this.scaleTextColor = Colors.black,
    this.scaleTextWidth = 15,
    this.indicatorColor = Colors.red,
    required this.onSelectedChanged,
  }) : super(key: key) {
    //检查最大数-最小数必须是步数的倍数
    if ((maxValue - minValue) % step != 0) {
      throw Exception("(maxValue - minValue)必须是 step 的整数倍");
    }
    //默认值 不能低于最小值 或者大于最大值
    if (value < minValue || value > maxValue) {
      throw Exception(
          "value 必须在minValue和maxValue范围内（minValue<=value<=maxValue）");
    }
    //总刻度数
    totalSubScaleCount = (maxValue - minValue) ~/ step;

    //检查总刻度数必须是大刻度子刻度数的倍数
    if (totalSubScaleCount % subScaleCountPerScale != 0) {
      throw Exception(
          "(maxValue - minValue)~/step 必须是 subScaleCountPerScale 的整数倍");
    }
    //空白item的宽度
    paddingItemWidth = width / 2;
  }

  @override
  State<StatefulWidget> createState() {
    return RulerState();
  }
}

class RulerState extends State<RulerView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(
      //初始位置
      initialScrollOffset:
          // （（默认值-最小值）/步长 ）=第几个刻度，再乘以每个刻度的宽度就是初始位置
          (widget.value - widget.minValue) / widget.step * widget.subScaleWidth,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width.toDouble(),
      height: widget.height.toDouble(),
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          NotificationListener(
            onNotification: _onNotification,
            child: ListView.builder(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.all(0),
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (BuildContext context, int index) {
                //2边的空白控件
                if (index == 0 || index == 2) {
                  return SizedBox(
                    width: widget.paddingItemWidth,
                    height: 0,
                  );
                } else {
                  //刻度尺
                  return RealRulerView(
                    subGridCount: widget.totalSubScaleCount,
                    subScaleWidth: widget.subScaleWidth,
                    step: widget.step,
                    minValue: widget.minValue,
                    height: widget.height,
                    scaleColor: widget.scaleColor,
                    scaleWidth: widget.scaleWidth,
                    scaleTextWidth: widget.scaleTextWidth,
                    scaleTextColor: widget.scaleTextColor,
                    subScaleCountPerScale: widget.subScaleCountPerScale,
                  );
                }
              },
            ),
          ),
          //指示器
          Container(
            width: 2,
            height: widget.height / 2,
            color: widget.indicatorColor,
          ),
        ],
      ),
    );
  }

  ///监听刻度尺滚动通知
  bool _onNotification(Notification notification) {
    //ScrollNotification是基类 （ScrollStartNotification/ScrollUpdateNotification/ScrollEndNotification)
    if (notification is ScrollNotification) {
      // print("-------metrics.pixels-------${notification.metrics.pixels}");
      //距离widget中间最近的刻度值
      int centerValue = widget.minValue +
          //notification.metrics.pixels水平滚动的偏移量
          //先计算出滚动偏移量是滚动了多少个刻度，然后取整，在乘以每个刻度的刻度值就是当前选中的值
          (notification.metrics.pixels / widget.subScaleWidth).round() *
              widget.step;

      // 选中值回调
      if (widget.onSelectedChanged != null) {
        widget.onSelectedChanged(centerValue);
      }
      //如果是否滚动停止，停止则滚动到centerValue
      if (_scrollingStopped(notification, _scrollController)) {
        select(centerValue);
      }
    }
    return true; //停止通知
  }

  ///判断是否滚动停止
  bool _scrollingStopped(
    Notification notification,
    ScrollController scrollController,
  ) {
    return
        //停止滚动
        notification is UserScrollNotification
            //没有滚动正在进行
            &&
            notification.direction == ScrollDirection.idle &&
            scrollController.position.activity is! HoldScrollActivity;
  }

  ///选中值
  void select(int centerValue) {
    //根据（中间值-最小值）/步长=第几个刻度，然后第几个刻度乘以每个刻度的宽度就是移动的宽度
    double x =
        (centerValue - widget.minValue) / widget.step * widget.subScaleWidth;
    _scrollController.animateTo(x,
        duration: const Duration(milliseconds: 200), curve: Curves.decelerate);
  }
}

///真实刻度尺View
class RealRulerView extends StatelessWidget {
  const RealRulerView({
    Key? key,
    required this.subGridCount,
    required this.subScaleWidth,
    required this.minValue,
    required this.height,
    required this.step,
    required this.scaleColor,
    required this.scaleWidth,
    required this.scaleTextColor,
    required this.scaleTextWidth,
    required this.subScaleCountPerScale,
  }) : super(key: key);

  //刻度总数
  final int subGridCount;

  //每个刻度的宽度
  final int subScaleWidth;

  //刻度尺的高度
  final int height;

  //刻度尺最小值
  final int minValue;

  //每个大刻度的小刻度数
  final int subScaleCountPerScale;

  //步长 一刻度的值
  final int step;

  //刻度尺颜色
  final Color scaleColor;

  //刻度尺宽度
  final double scaleTextWidth;

  //刻度线宽度
  final double scaleWidth;

  //数字颜色
  final Color scaleTextColor;

  @override
  Widget build(BuildContext context) {
    double rulerWidth = (subScaleWidth * subGridCount).toDouble();
    double rulerHeight = this.height.toDouble();
    return CustomPaint(
      size: Size(rulerWidth, rulerHeight),
      painter: RulerViewPainter(
        subScaleWidth,
        step,
        minValue,
        scaleColor,
        scaleWidth,
        scaleTextColor,
        scaleTextWidth,
        subScaleCountPerScale,
      ),
    );
  }
}

class RulerViewPainter extends CustomPainter {
  RulerViewPainter(
    this.subScaleWidth,
    this.step,
    this.minValue,
    this.scaleColor,
    this.scaleWidth,
    this.scaleTextColor,
    this.scaleTextWidth,
    this.subScaleCountPerScale,
  ) {
    //刻度尺
    linePaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = scaleWidth
      ..color = scaleColor;

    //数字
    textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
  }

  final int subScaleWidth;

  final int step;

  final int minValue;

  final Color scaleColor;

  final Color scaleTextColor;

  final double scaleTextWidth;

  final int subScaleCountPerScale;

  final double scaleWidth;

  late Paint linePaint;

  late TextPainter textPainter;

  @override
  void paint(Canvas canvas, Size size) {
    //绘制线
    drawLine(canvas, size);
    //绘制数字
    drawNum(canvas, size);
  }

  ///绘制线
  void drawLine(Canvas canvas, Size size) {
    //绘制横线
    canvas.drawLine(
      Offset(0, 0 + scaleWidth / 2),
      Offset(size.width, 0 + scaleWidth / 2),
      linePaint,
    );
    //第几个小格子
    int index = 0;
    //绘制竖线
    for (double x = 0; x <= size.width; x += subScaleWidth) {
      if (index % subScaleCountPerScale == 0) {
        canvas.drawLine(
            Offset(x, 0), Offset(x, size.height * 3 / 8), linePaint);
      } else {
        canvas.drawLine(Offset(x, 0), Offset(x, size.height / 4), linePaint);
      }
      index++;
    }
  }

  ///绘制数字
  void drawNum(Canvas canvas, Size size) {
    canvas.save();
    //坐标移动（0，0）点
    canvas.translate(0, 0);
    //每个大格子的宽度
    double offsetX = (subScaleWidth * subScaleCountPerScale).toDouble();
    int index = 0;
    //绘制数字
    for (double x = 0; x <= size.width; x += offsetX) {
      textPainter.text = TextSpan(
        text: "${minValue + index * step * subScaleCountPerScale}",
        style: TextStyle(color: scaleTextColor, fontSize: scaleTextWidth),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          -textPainter.width / 2,
          size.height - textPainter.height,
        ),
      );
      index++;
      canvas.translate(offsetX, 0);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
