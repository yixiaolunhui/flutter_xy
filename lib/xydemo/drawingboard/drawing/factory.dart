import 'shape/circle.dart';
import 'shape/line.dart';
import 'shape/rectangle.dart';
import 'shape/shape.dart';
import 'type.dart';

/// 根据绘制类型返回具体绘制对象
Shape getShape(ShapeType type) {
  switch (type) {
    case ShapeType.line:
      return LineShape();
    case ShapeType.circle:
      return CircleShape();
    case ShapeType.rectangle:
      return RectangleShape();
  }
}
