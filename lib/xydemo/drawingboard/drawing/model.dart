import 'package:flutter/material.dart';

import 'type.dart';

/// 笔画参数对象
class DrawingStroke {
  Color color;
  double width;
  List<Offset> points;
  ShapeType type;

  DrawingStroke({
    this.color = Colors.black,
    this.width = 2.0,
    this.points = const [],
    this.type = ShapeType.line,
  });
}
