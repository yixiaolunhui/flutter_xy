import 'dart:ui';

import 'shape.dart';


/// 绘制线
class LineShape implements Shape {
  @override
  void draw(Canvas canvas, List<Offset> points, Paint paint) {
    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }
  }
}