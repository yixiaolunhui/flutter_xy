import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

///时钟
class ClockView extends StatefulWidget {
  const ClockView({
    Key? key,
    this.radius = 150,
    this.borderColor = Colors.black,
    this.scaleColor = Colors.black,
    this.numberColor = Colors.black,
    this.moveBallColor = Colors.red,
    this.hourHandColor = Colors.black,
    this.minuteHandColor = Colors.black,
    this.secondHandColor = Colors.red,
    this.middleCircleColor = Colors.red,
    this.isDrawBorder = true,
    this.isDrawScale = true,
    this.isDrawNumber = true,
    this.isDrawMoveBall = true,
    this.isDrawHourHand = true,
    this.isDrawMinuteHand = true,
    this.isDrawSecondHand = true,
    this.isDrawMiddleCircle = true,
    this.isMove = true,
  }) : super(key: key);

  //钟表的半径
  final double radius;

  //边框的颜色
  final Color borderColor;

  //刻度的颜色
  final Color scaleColor;

  //数字的颜色
  final Color numberColor;

  //走秒小球颜色
  final Color moveBallColor;

  //时针的颜色
  final Color hourHandColor;

  //分针的颜色
  final Color minuteHandColor;

  //秒针的颜色
  final Color secondHandColor;

  //中间圆颜色
  final Color middleCircleColor;

  //是否绘制边框
  final bool isDrawBorder;

  //是否绘制刻度
  final bool isDrawScale;

  //是否绘制数字
  final bool isDrawNumber;

  //是否绘制移动小球
  final bool isDrawMoveBall;

  //是否绘制时针
  final bool isDrawHourHand;

  //是否绘制分针
  final bool isDrawMinuteHand;

  //是否绘制秒针
  final bool isDrawSecondHand;

  //是否绘制中间圆圈
  final bool isDrawMiddleCircle;

  //是否走起来
  final bool isMove;

  @override
  State<StatefulWidget> createState() {
    return ClockViewState();
  }
}

class ClockViewState extends State<ClockView> {
  //当前时间
  late DateTime dateTime;

  //定时器
  late Timer timer;

  @override
  void initState() {
    super.initState();
    dateTime = DateTime.now();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (widget.isMove) {
        setState(() {
          dateTime = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    //取消定时器
    if (timer.isActive) {
      timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ClockPainter(
        dateTime,
        radius: widget.radius,
        borderColor: widget.borderColor,
        scaleColor: widget.scaleColor,
        numberColor: widget.numberColor,
        moveBallColor: widget.moveBallColor,
        hourHandColor: widget.hourHandColor,
        minuteHandColor: widget.minuteHandColor,
        secondHandColor: widget.secondHandColor,
        middleCircleColor: widget.middleCircleColor,
        isDrawBorder: widget.isDrawBorder,
        isDrawScale: widget.isDrawScale,
        isDrawNumber: widget.isDrawNumber,
        isDrawMoveBall: widget.isDrawMoveBall,
        isDrawHourHand: widget.isDrawHourHand,
        isDrawMinuteHand: widget.isDrawMinuteHand,
        isDrawSecondHand: widget.isDrawSecondHand,
        isDrawMiddleCircle: widget.isDrawMiddleCircle,
        isMove: widget.isMove,
      ),
      size: Size(widget.radius * 2, widget.radius * 2),
    );
  }
}

class ClockPainter extends CustomPainter {
  //边框的颜色
  final Color borderColor;

  //刻度的颜色
  final Color scaleColor;

  //数字的颜色
  final Color numberColor;

  //中间圆颜色
  final Color middleCircleColor;

  //走秒小球颜色
  final Color moveBallColor;

  //时针的颜色
  final Color hourHandColor;

  //分针的颜色
  final Color minuteHandColor;

  //秒针的颜色
  final Color secondHandColor;

  //是否绘制边框
  final bool isDrawBorder;

  //是否绘制刻度
  final bool isDrawScale;

  //是否绘制数字
  final bool isDrawNumber;

  //是否绘制移动小球
  final bool isDrawMoveBall;

  //是否绘制时针
  final bool isDrawHourHand;

  //是否绘制分针
  final bool isDrawMinuteHand;

  //是否绘制秒针
  final bool isDrawSecondHand;

  //是否绘制中间圆圈
  final bool isDrawMiddleCircle;

  //是否走起来
  final bool isMove;

  //边框画笔的宽度
  late double borderWidth;

  //刻度画笔的宽度
  late double scaleWidth;

  //数字画笔的宽度
  late double numberWidth;

  //时针画笔的宽度
  late double hourHandWidth;

  //分针画笔的宽度
  late double minuteHandWidth;

  //秒针画笔的宽度
  late double secondHandWidth;

  //中间圆的宽度
  late double middleCircleWidth;

  //小刻度的位置集合
  late List<Offset> scaleOffset = [];

  //大刻度的位置集合 每5个小刻度是一个大刻度
  late List<Offset> bigScaleOffset = [];

  //钟表的半径
  final double radius;

  //当前时间
  final DateTime dateTime;

  //边框画笔
  late Paint borderPaint;

  //刻度画笔
  late Paint scalePaint;

  //数字画笔
  late TextPainter textPainter;

  //时针画笔
  late Paint hourPaint;

  //分针画笔
  late Paint minutePaint;

  //秒针画笔
  late Paint secondPaint;

  //中间圆画笔
  late Paint centerPaint;

  //移动小球画笔
  late Paint moveBallPaint;

  ClockPainter(
    this.dateTime, {
    required this.radius,
    required this.borderColor,
    required this.scaleColor,
    required this.numberColor,
    required this.moveBallColor,
    required this.hourHandColor,
    required this.minuteHandColor,
    required this.secondHandColor,
    required this.middleCircleColor,
    required this.isDrawBorder,
    required this.isDrawScale,
    required this.isDrawNumber,
    required this.isDrawMoveBall,
    required this.isDrawHourHand,
    required this.isDrawMinuteHand,
    required this.isDrawSecondHand,
    required this.isDrawMiddleCircle,
    required this.isMove,
  }) {
    //根据自己的审美设置这些画笔的宽度
    borderWidth = 8 * (radius / 100);
    scaleWidth = 2 * (radius / 100);
    numberWidth = 20 * (radius / 100);
    hourHandWidth = 5 * (radius / 100);
    minuteHandWidth = 3 * (radius / 100);
    secondHandWidth = 1 * (radius / 100);
    middleCircleWidth = 4 * (radius / 100);

    //边框画笔
    borderPaint =
        createPaint(borderColor, borderWidth, style: PaintingStyle.stroke);
    //刻度画笔
    scalePaint = createPaint(numberColor, scaleWidth);
    //时针画笔
    hourPaint = createPaint(hourHandColor, hourHandWidth);
    //分针画笔
    minutePaint = createPaint(minuteHandColor, minuteHandWidth);
    //秒针画笔
    secondPaint = createPaint(secondHandColor, secondHandWidth);
    //中间圆
    centerPaint = createPaint(middleCircleColor, middleCircleWidth);
    //移动小球画笔
    moveBallPaint = createPaint(moveBallColor, scaleWidth * 2);
    //数字
    textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    //计算出 小刻度和大刻度
    final l = radius - borderWidth * 2;
    for (var i = 0; i < 60; i++) {
      Offset offset = pointOffset(radius, l, 360 / 60 * i);
      //小刻度
      scaleOffset.add(offset);
      //大刻度
      if (i % 5 == 0) {
        bigScaleOffset.add(offset);
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    //绘制边框
    if (isDrawBorder) drawBorder(canvas);
    //绘制刻度
    if (isDrawScale) drawScale(canvas);
    //绘制数字
    if (isDrawNumber) drawNumber(canvas);
    //绘制时针
    if (isDrawHourHand) drawHour(canvas);
    //绘制分针
    if (isDrawMinuteHand) drawMinute(canvas);
    //绘制秒针
    if (isDrawSecondHand) drawSecond(canvas);
    //绘制中间圆圈
    if (isDrawMiddleCircle) drawMiddleCircle(canvas);
    //绘制移动小球
    if (isDrawMoveBall) drawMoveBall(canvas);
  }

  //判断是否需要重绘
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  ///绘制边框
  void drawBorder(Canvas canvas) {
    canvas.drawCircle(
        Offset(radius, radius), radius - borderWidth / 2, borderPaint);
  }

  ///绘制刻度
  void drawScale(Canvas canvas) {
    //小刻度
    if (scaleOffset.isNotEmpty) {
      canvas.drawPoints(PointMode.points, scaleOffset, scalePaint);
    }

    //大刻度
    final biggerScalePaint = Paint()
      ..strokeWidth = scaleWidth * 2
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..color = numberColor;
    canvas.drawPoints(PointMode.points, bigScaleOffset, biggerScalePaint);
  }

  ///绘制数字(第1种)
  void drawNumber(Canvas canvas) {
    double l = radius - borderWidth * 4;
    for (var i = 0; i < bigScaleOffset.length; i++) {
      textPainter.text = TextSpan(
        text: "${i == 0 ? 12 : i}",
        style: TextStyle(color: numberColor, fontSize: numberWidth),
      );
      Offset offset = pointOffset(radius, l, i * 360 / 12);
      textPainter.layout();
      textPainter.paint(
          canvas,
          Offset(
            offset.dx - (textPainter.width / 2),
            offset.dy - (textPainter.height / 2),
          ));
    }
  }

  ///绘制数字(第2种)
  void drawNumber2(Canvas canvas) {
    canvas.save();

    //移动的圆点（水平向右为正向，竖直向下为正向）
    canvas.translate(radius, radius);

    //每个刻度角度圆弧
    num angle = degToRad(360 / 60);
    for (var i = 0; i < bigScaleOffset.length; i++) {
      canvas.save();
      //上移移动到待绘制的地方
      canvas.translate(0.0, -radius + borderWidth * 4);
      //旋转，确定数字竖直绘制
      canvas.rotate(-angle * i * 5);
      //设置文字及样式
      textPainter.text = TextSpan(
        text: "${i == 0 ? 12 : i}",
        style: TextStyle(color: numberColor, fontSize: numberWidth),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          -(textPainter.width / 2),
          -(textPainter.height / 2),
        ),
      );
      canvas.restore();

      canvas.rotate(angle * 5);
    }

    canvas.restore();
  }

  ///绘制时针
  void drawHour(Canvas canvas) {
    final hour = dateTime.hour;
    double angle = 360 / 12 * hour + dateTime.minute / 60 * 30;
    Offset hourHand1 = pointOffset(radius, radius * 0.1, angle + 180);
    Offset hourHand2 = pointOffset(radius, radius * 0.45, angle);
    canvas.drawLine(hourHand1, hourHand2, hourPaint);
  }

  ///绘制分针
  void drawMinute(Canvas canvas) {
    final minute = dateTime.minute;
    double angle = 360 / 60 * minute + dateTime.second / 60 * 6;
    Offset minuteHand1 = pointOffset(radius, radius * 0.1, angle + 180);
    Offset minuteHand2 = pointOffset(radius, radius * 0.7, angle);
    canvas.drawLine(minuteHand1, minuteHand2, minutePaint);
  }

  ///绘制秒针
  void drawSecond(Canvas canvas) {
    final second = dateTime.second;
    double angle = 360 / 60 * second;
    Offset secondHand1 = pointOffset(radius, radius * 0.1, angle + 180);
    Offset secondHand2 = pointOffset(radius, radius * 0.7, angle);
    canvas.drawLine(secondHand1, secondHand2, secondPaint);
  }

  ///绘制中间圆圈
  void drawMiddleCircle(Canvas canvas) {
    canvas.drawCircle(Offset(radius, radius), middleCircleWidth, centerPaint);
  }

  ///绘制移动小球
  void drawMoveBall(Canvas canvas) {
    final second = dateTime.second;
    canvas.drawCircle(scaleOffset[second], middleCircleWidth, moveBallPaint);
  }
}

///创建Paint
Paint createPaint(Color color, double strokeWidth,
    {PaintingStyle style = PaintingStyle.fill}) {
  return Paint()
    ..color = color
    ..isAntiAlias = true
    ..style = style
    ..strokeCap = StrokeCap.round
    ..strokeWidth = strokeWidth;
}

///圆中万能求点公式
Offset pointOffset(double radius, double l, double angle) {
  return Offset(
    radius + l * sin(degToRad(angle)),
    radius - l * cos(degToRad(angle)),
  );
}

///角度转换为弧度
num degToRad(num deg) => deg * (pi / 180.0);
