import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sprintf/sprintf.dart';

class _PtReportLevelWidgetConstant {
  static const HEIGHT = 320.0;
}

Widget LevelWidget({int level = 0}) {
  return Container(
    child: CustomPaint(
      painter: _LevelsPainter(currentLevel: level),
      size: Size(
          WidgetsBinding.instance.window.physicalSize.width /
              WidgetsBinding.instance.window.devicePixelRatio,
          _PtReportLevelWidgetConstant.HEIGHT.w),
    ),
  );
}

class _LevelsPainter extends CustomPainter {
  int currentLevel;

  _LevelsPainter({this.currentLevel = 0});

  @override
  void paint(Canvas canvas, Size size) {
    // 基础数据
    var level = 8;
    if (currentLevel < 0 || currentLevel > level - 1) {
      currentLevel = 0;
    }
    var edgeMargin = 20.0.w;
    var xAxisTopMargin = 225.0.w;
    var levelTextMinWidth = 20.0.w;
    var levelTextMaxWidth = 30.0.w;
    var levelTextMargin = (size.width -
            edgeMargin * 2 -
            levelTextMinWidth * (level - 1) -
            levelTextMaxWidth) /
        (level - 1);

    // 背景
    var bgPaint = Paint()..isAntiAlias = true;
    bgPaint.shader = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomCenter,
      colors: [
        Colors.white.withOpacity(1),
        Colors.white.withOpacity(0.7),
        Colors.white.withOpacity(0.6),
        Colors.white.withOpacity(0.5),
        Colors.white.withOpacity(0.4),
        Colors.white.withOpacity(0.3),
        Colors.white.withOpacity(0),
        Colors.white.withOpacity(0),
      ],
      tileMode: TileMode.mirror,
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    var bgPath = Path();
    bgPath.moveTo(0, size.height * 0.50.w);
    bgPath.quadraticBezierTo(size.width / 2 + 50.w, 220.w, size.width, 0);
    bgPath.lineTo(size.width, size.height - 40.w);
    bgPath.lineTo(100.w, size.height);
    bgPath.lineTo(0, size.height + 100);
    canvas.drawPath(bgPath, bgPaint);

    // 循环创建 x 轴文字 和 竖指示线
    var levelTextOffsetX = 0.0;
    var addtionalDotOffsetX =
        <double>[1, 2, 2, 2, 4, 10, 22, 42].map((e) => e.w).toList();
    for (var i = 0; i < level; i++) {
      var selected = currentLevel == i;
      var tp = TextPainter(
          text: TextSpan(
            text: sprintf("Level%s", [i + 1]),
            style: TextStyle(
              color: Colors.white,
              fontSize: selected ? 15 : 10,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w700,
            ),
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr);
      tp.layout();
      var nextLevelTextWidth =
          i == currentLevel + 1 ? levelTextMaxWidth : levelTextMinWidth;
      levelTextOffsetX +=
          i == 0 ? edgeMargin : (levelTextMargin + nextLevelTextWidth);
      var levelTextOffsetY = selected ? xAxisTopMargin - 3 : xAxisTopMargin;
      tp.paint(canvas, Offset(levelTextOffsetX, levelTextOffsetY));

      // 虚线上边界和圆环中心点位置
      var currentLevelTextWidth =
          i == currentLevel ? levelTextMaxWidth : levelTextMinWidth;
      var metrics = bgPath.computeMetrics().elementAt(0);
      var currentOffsetX = levelTextOffsetX + currentLevelTextWidth / 2;
      var levelDotOffset = metrics
          .getTangentForOffset(currentOffsetX + addtionalDotOffsetX[i])!
          .position;
      // level 对应的圆环位置

      // 虚线部分
      var dashPaint = Paint()..isAntiAlias = true;
      dashPaint.style = PaintingStyle.stroke;
      dashPaint.strokeWidth = 1.2;
      dashPaint.shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withOpacity(0),
          Colors.white.withOpacity(0.5),
        ],
        tileMode: TileMode.mirror,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
      var baseOffsetY = xAxisTopMargin - 5;
      var dashOffsetY = baseOffsetY;
      for (var j = 0; j < 30; j++) {
        canvas.drawLine(
            Offset(levelTextOffsetX + currentLevelTextWidth / 2, dashOffsetY),
            Offset(
                levelTextOffsetX + currentLevelTextWidth / 2, dashOffsetY - 3),
            dashPaint);
        // 上边界判断
        if (dashOffsetY >= levelDotOffset.dy) {
          dashOffsetY = dashOffsetY - 8;
        } else {
          break;
        }
      }

      // 当前 level 处理
      if (selected) {
        //  实竖线
        var linePaint = Paint()..isAntiAlias = true;
        linePaint.style = PaintingStyle.stroke;
        linePaint.strokeWidth = 2;
        var rect = Rect.fromLTWH(
            levelTextOffsetX +
                currentLevelTextWidth / 2 -
                linePaint.strokeWidth / 2,
            dashOffsetY,
            linePaint.strokeWidth,
            baseOffsetY - dashOffsetY);
        linePaint.shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withOpacity(0.8),
              Colors.white.withOpacity(0.5),
              Colors.white.withOpacity(0)
            ]).createShader(rect);
        canvas.drawRect(rect, linePaint);

        // 圆环组
        var circlePaint = Paint()..isAntiAlias = true;
        circlePaint.style = PaintingStyle.fill;
        circlePaint.color = Colors.white.withOpacity(0.1);
        canvas.drawArc(
            Rect.fromCenter(
                center: Offset(levelTextOffsetX + currentLevelTextWidth / 2,
                    levelDotOffset.dy),
                width: 40.w,
                height: 40.w),
            0,
            2 * pi,
            true,
            circlePaint);

        circlePaint.color = Colors.white.withOpacity(0.3);
        canvas.drawArc(
            Rect.fromCenter(
                center: Offset(levelTextOffsetX + currentLevelTextWidth / 2,
                    levelDotOffset.dy),
                width: 25.w,
                height: 25.w),
            0,
            2 * pi,
            true,
            circlePaint);

        circlePaint.color = Colors.white;
        canvas.drawArc(
            Rect.fromCenter(
                center: Offset(levelTextOffsetX + currentLevelTextWidth / 2,
                    levelDotOffset.dy),
                width: 15.w,
                height: 15.w),
            0,
            2 * pi,
            true,
            circlePaint);
      }
    }
  }

  @override
  bool shouldRepaint(_LevelsPainter oldDelegate) {
    return false;
  }
}
