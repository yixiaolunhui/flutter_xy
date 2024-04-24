import 'dart:ui';

import 'shape.dart';


/// 绘制圆
class CircleShape implements Shape {
  @override
  void draw(Canvas canvas, List<Offset> points, Paint paint) {
    if (points.length >= 2) {
      double radius = (points[points.length - 1] - points[1]).distance / 2;
      paint.style = PaintingStyle.stroke;
      canvas.drawCircle(points[0], radius, paint);
    }
  }
}
