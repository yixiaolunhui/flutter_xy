import 'dart:ui';

import 'shape.dart';


/// 绘制方
class RectangleShape implements Shape {
  @override
  void draw(Canvas canvas, List<Offset> points, Paint paint) {
    if (points.length >= 2) {
      final rect = Rect.fromPoints(points[0], points[points.length - 1]);
      paint.style = PaintingStyle.stroke;
      canvas.drawRect(rect, paint);
    }
  }
}
