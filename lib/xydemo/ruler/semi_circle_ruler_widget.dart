import 'dart:math';

import 'package:flutter/material.dart';

/*
 * 半圆刻度尺
 * https://www.twle.cn/l/yufei/canvas/canvas-basic-geometric-rotate.html
 */
class SemiCircleRulerWidget extends StatelessWidget {
  const SemiCircleRulerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double radius;
        if (constraints.maxWidth / 2 >= constraints.maxHeight) {
          radius = constraints.maxHeight;
        } else {
          radius = constraints.maxWidth / 2;
        }
        var size = Size(radius * 2, radius);
        return CustomPaint(
          size: size,
          painter: SemiCircleRulerCustomPainter(radius),
        );
      },
    );
  }
}

class SemiCircleRulerCustomPainter extends CustomPainter {
  //边框画笔
  late Paint borderPaint;

  //边框画笔宽度
  late double borderStrokeWidth = 2;

  //半圆画笔
  late Paint semicirclePaint;

  //半圆画笔宽度
  late double semicircleWidth = 1;

  //刻度画笔
  late Paint scalePaint;

  //刻度画笔宽度
  late double scalePaintWidth = 1;

  //数字画笔
  late TextPainter textPainter;

  //数字画笔的宽度
  late double numberWidth;

  //半径
  late double radius;

  //长刻度长度
  final double longScaleSize = 25;

  //中刻度长度
  final double middleScaleSize = 18;

  //短刻度长度
  final double shortScaleSize = 13;

  //外圈文字距离边框距离
  final double outNumSize = 30;

  //内圈文字距离边框距离
  final double inNumSize = 60;

  //外半圆与边缘的距离
  final double outerSemicircleSize = 50;

  //内半圆与边缘的距离
  final double interSemicircleSize = 85;

  //数字文字大小
  final double numTextSize = 16.0;

  SemiCircleRulerCustomPainter(this.radius) {
    //创建边框画笔
    borderPaint = createPaint(Colors.black, borderStrokeWidth);
    //创建刻度画笔
    scalePaint = createPaint(Colors.black, scalePaintWidth);
    //创建内部半圆画笔
    semicirclePaint = createPaint(Colors.black, semicircleWidth);
    //刻度值文字画笔
    textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    //绘制表框（最外层半圆）
    drawBorder(canvas, size);

    //绘制外半圆
    drawOuterSemicircle(canvas, size);

    //绘制内半圆
    drawInnerSemicircle(canvas, size);

    //绘制刻度
    drawScale(canvas, size);

    //绘制最小的半圆
    drawSmallSemicircle(canvas, size);
  }

  /*
   * 绘制刻度
   */
  void drawScale(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(radius, radius);
    canvas.rotate(degToRad(-90));
    for (int index = 1; index < 180; index++) {
      //旋转角度
      canvas.rotate(degToRad(1));

      //大刻度
      if (index % 10 == 0) {
        //绘制最长刻度
        drawLongLine(canvas, size);
        //绘制刻度值文字
        drawScaleNum(canvas, index);
        // 绘制刻度线
        drawScaleLine(canvas, size);
      }
      //中刻度
      else if (index % 5 == 0) {
        //绘制中刻度
        drawMiddleLine(canvas, size);
      }
      //小刻度
      else {
        //绘制小刻度
        drawShortLine(canvas, size);
      }
    }
    canvas.restore();
  }

  /*
   * 绘制数字
   */
  void drawScaleNum(Canvas canvas, int i) {
    //绘制最外圈刻度值
    textPainter.text = TextSpan(
        text: "$i",
        style: TextStyle(
          color: Colors.black,
          fontSize: numTextSize,
        ));
    textPainter.layout();
    double textStarPositionX = -textPainter.size.width / 2;
    double textStarPositionY = -radius + outNumSize;
    textPainter.paint(canvas, Offset(textStarPositionX, textStarPositionY));

    //绘制内圈刻度值
    textPainter.text = TextSpan(
        text: "${180 - i}",
        style: TextStyle(
          color: Colors.black,
          fontSize: numTextSize,
        ));
    textPainter.layout();
    double textStarPositionX2 = -textPainter.size.width / 2;
    double textStarPositionY2 = -radius + inNumSize;
    textPainter.paint(canvas, Offset(textStarPositionX2, textStarPositionY2));
  }

  /*
   * 绘制刻度线（10倍数）
   */
  void drawScaleLine(Canvas canvas, Size size) {
    canvas.drawLine(
      const Offset(0, 0),
      Offset(0, -radius + scalePaintWidth + interSemicircleSize),
      scalePaint,
    );
  }

  /*
   * 绘制长线
   */
  void drawLongLine(Canvas canvas, Size size) {
    canvas.drawLine(
      Offset(0.0, -(radius - borderStrokeWidth / 2)),
      Offset(0.0, -(radius - borderStrokeWidth / 2) + longScaleSize),
      scalePaint,
    );
  }

  /*
   * 绘制中线
   */
  void drawMiddleLine(Canvas canvas, Size size) {
    canvas.drawLine(
      Offset(0.0, -(radius - borderStrokeWidth / 2)),
      Offset(0.0, -(radius - borderStrokeWidth / 2) + middleScaleSize),
      scalePaint,
    );
  }

  /*
   * 绘制短线
   */
  void drawShortLine(Canvas canvas, Size size) {
    canvas.drawLine(
      Offset(0.0, -(radius - borderStrokeWidth / 2)),
      Offset(0.0, -(radius - borderStrokeWidth / 2) + shortScaleSize),
      scalePaint,
    );
  }

  /*
   * 绘制表框（半圆）
   */
  void drawBorder(Canvas canvas, Size size) {
    Rect rect = Rect.fromCircle(
      center: Offset(radius, radius),
      radius: radius - borderStrokeWidth / 2,
    );
    canvas.drawArc(rect, -pi, pi, true, borderPaint);
  }

  /*
   * 绘制外半圆
   */
  void drawOuterSemicircle(Canvas canvas, Size size) {
    Rect rect = Rect.fromCircle(
      center: Offset(radius, radius),
      radius: radius - borderStrokeWidth / 2 - interSemicircleSize,
    );
    canvas.drawArc(rect, -pi, pi, true, semicirclePaint);
  }

  /*
   * 绘制内半圆
   */
  void drawInnerSemicircle(Canvas canvas, Size size) {
    Rect rect = Rect.fromCircle(
      center: Offset(radius, radius),
      radius: radius - borderStrokeWidth / 2 - outerSemicircleSize,
    );
    canvas.drawArc(rect, -pi, pi, true, semicirclePaint);
  }

  /*
   * 绘制最小的半圆
   */
  void drawSmallSemicircle(Canvas canvas, Size size) {
    //绘制半圆区域
    Rect rect = Rect.fromCircle(
      center: Offset(radius, radius - borderStrokeWidth / 2),
      radius: radius / 10,
    );
    //这里先绘制半圆边框
    canvas.drawArc(rect, -pi, pi, true, semicirclePaint);

    //绘制白色半圆
    semicirclePaint.color = Colors.white;
    semicirclePaint.style = PaintingStyle.fill;
    canvas.drawArc(rect, -pi, pi, true, semicirclePaint);
  }

  /*
   * 绘制坐标系( X轴  Y轴) 为了查看坐标系位置,调试用
   */
  void drawXY(Canvas canvas) {
    //X轴
    canvas.drawLine(
      const Offset(0, 0),
      const Offset(300, 0),
      Paint()
        ..color = Colors.green
        ..strokeWidth = 3,
    );

    //Y轴
    canvas.drawLine(
      const Offset(0, 0),
      const Offset(0, 300),
      Paint()
        ..color = Colors.red
        ..strokeWidth = 3,
    );
  }

  //角度转换为弧度
  double degToRad(num deg) => deg * (pi / 180.0);

  /*
   * 创建Paint
   */
  Paint createPaint(Color color, double strokeWidth,
      {PaintingStyle style = PaintingStyle.stroke}) {
    return Paint()
      ..color = color
      ..isAntiAlias = true
      ..style = style
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
