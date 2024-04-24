import 'dart:ui';

/// 绘制抽象类
abstract class Shape {
  void draw(
    Canvas canvas,
    List<Offset> points,
    Paint paint,
  );
}
