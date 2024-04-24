import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_xy/xydemo/drawingboard/drawing/type.dart';
import 'package:flutter_xy/xydemo/drawingboard/drawing/view.dart';

import 'drawing/controller.dart';

class DrawingPage extends StatefulWidget {
  const DrawingPage({Key? key}) : super(key: key);

  @override
  DrawingPageState createState() => DrawingPageState();
}

class DrawingPageState extends State<DrawingPage> {
  final _controller = DrawingController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            SizedBox(
              width: 120,
              child: ListView(
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  const SizedBox(width: 10),
                  _buildText("操作"),
                  const SizedBox(width: 10),
                  _buildButton('Undo', () => _controller.undo()),
                  const SizedBox(width: 10),
                  _buildButton('Clear', () => _controller.clear()),
                  const SizedBox(width: 10),
                  _buildText("画笔颜色"),
                  const SizedBox(width: 10),
                  _buildColorButton(Colors.red),
                  const SizedBox(width: 10),
                  _buildColorButton(Colors.blue),
                  const SizedBox(width: 10),
                  _buildText("画笔宽度"),
                  const SizedBox(width: 10),
                  _buildStrokeWidthButton(2.0),
                  const SizedBox(width: 10),
                  _buildStrokeWidthButton(5.0),
                  const SizedBox(width: 10),
                  _buildText("画笔类型"),
                  const SizedBox(width: 10),
                  _buildTypeButton(ShapeType.line, '线'),
                  const SizedBox(width: 10),
                  _buildTypeButton(ShapeType.circle, '圆'),
                  const SizedBox(width: 10),
                  _buildTypeButton(ShapeType.rectangle, '方'),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: DrawingBoard(
                      controller: _controller,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }

  Widget _buildColorButton(Color color) {
    return ElevatedButton(
      onPressed: () => _controller.setColor(color),
      style: ElevatedButton.styleFrom(primary: color),
      child: const SizedBox(width: 30, height: 30),
    );
  }

  Widget _buildStrokeWidthButton(double width) {
    return ElevatedButton(
      onPressed: () => _controller.setStrokeWidth(width),
      child: Text(width.toString()),
    );
  }

  Widget _buildTypeButton(ShapeType type, String label) {
    return ElevatedButton(
      onPressed: () => _controller.setDrawingType(type),
      child: Text(label),
    );
  }
}
