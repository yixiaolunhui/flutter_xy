import 'package:flutter/material.dart';
import 'package:flutter_xy/xydemo/drawingboard/drawing/type.dart';

import 'model.dart';

/// 绘制控制器
class DrawingController {
  final _strokes = <DrawingStroke>[];
  final _listeners = <VoidCallback>[];

  // 所有绘制笔画数据
  List<DrawingStroke> get strokes => List.unmodifiable(_strokes);
  // 画笔颜色
  Color selectedColor = Colors.black;
  // 画笔宽度
  double strokeWidth = 2.0;
  // 绘制类型
  ShapeType selectedType = ShapeType.line;

  // 开始绘制
  void startDrawing(Offset point) {
    _strokes.add(DrawingStroke(
      color: selectedColor,
      width: strokeWidth,
      points: [point],
      type: selectedType,
    ));
    _notifyListeners();
  }

  // 正在绘制
  void updateDrawing(Offset point) {
    if (_strokes.isNotEmpty) {
      _strokes.last.points.add(point);
      _notifyListeners();
    }
  }

  // 结束当前笔画绘制
  void endDrawing() {
    _notifyListeners();
  }

  // 撤回一笔
  void undo() {
    if (_strokes.isNotEmpty) {
      _strokes.removeLast();
      _notifyListeners();
    }
  }

  // 清空数据
  void clear() {
    _strokes.clear();
    _notifyListeners();
  }

  // 设置画笔颜色
  void setColor(Color color) {
    selectedColor = color;
    _notifyListeners();
  }

  // 设置画笔宽度
  void setStrokeWidth(double width) {
    strokeWidth = width;
    _notifyListeners();
  }

  // 设置绘制类型
  void setDrawingType(ShapeType type) {
    selectedType = type;
    _notifyListeners();
  }

  void _notifyListeners() {
    for (var listener in _listeners) {
      listener();
    }
  }

  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }
}
