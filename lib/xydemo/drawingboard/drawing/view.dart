import 'package:flutter/material.dart';

import 'controller.dart';
import 'factory.dart';
import 'model.dart';
import 'shape/shape.dart';

class DrawingBoard extends StatefulWidget {
  final DrawingController controller;

  const DrawingBoard({Key? key, required this.controller}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DrawingBoardState();
}

class DrawingBoardState extends State<DrawingBoard> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateState);
  }

  void _updateState() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(_updateState);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      return SizedBox(
        width: size.maxWidth,
        height: size.maxHeight,
        child: GestureDetector(
          onPanStart: (details) {
            widget.controller.startDrawing(details.localPosition);
          },
          onPanUpdate: (details) {
            widget.controller.updateDrawing(details.localPosition);
          },
          onPanEnd: (_) {
            widget.controller.endDrawing();
          },
          child: CustomPaint(
            painter: DrawingPainter(strokes: widget.controller.strokes),
            size: Size.infinite,
          ),
        ),
      );
    });
  }
}

class DrawingPainter extends CustomPainter {
  final Paint drawPaint = Paint();

  DrawingPainter({required this.strokes});

  List<DrawingStroke> strokes;

  @override
  void paint(Canvas canvas, Size size) {
    for (var stroke in strokes) {
      drawPaint
        ..color = stroke.color
        ..strokeCap = StrokeCap.round
        ..strokeWidth = stroke.width;

      Shape shape = getShape(stroke.type);
      shape.draw(canvas, stroke.points, drawPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
