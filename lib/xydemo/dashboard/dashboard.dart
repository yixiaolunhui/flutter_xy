import 'dart:ui';

import 'package:flutter/material.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DashBoardState();
  }
}

class DashBoardState extends State<DashBoard> {
  bool _isGetPressure = false;
  int pressures = 0;
  final double wholeCirclesRadian = 6.283185307179586;

  ///虽然一个圆被分割为160份，但是只显示120份
  final int tableCount = 160;
  late Size dashBoardSize;
  late double tableSpace;
  late Picture _pictureBackGround;
  late Picture _pictureIndicator;

  @override
  void initState() {
    super.initState();
    dashBoardSize = Size(300.0, 300.0);
    tableSpace = wholeCirclesRadian / tableCount;
    _pictureBackGround =
        DashBoardTablePainter(tableSpace, dashBoardSize).getBackGround();
    _pictureIndicator = IndicatorPainter(dashBoardSize).drawIndicator();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onPanDown: (DragDownDetails dragDownDetails) {
          _isGetPressure = true;
          boostSpeed();
        },
        onPanCancel: () {
          handleEndEvent();
        },
        onPanEnd: (DragEndDetails dragEndDetails) {
          handleEndEvent();
        },
        child: CustomPaint(
          size: dashBoardSize,
          painter: DashBoardIndicatorPainter(
              pressures, tableSpace, _pictureBackGround, _pictureIndicator),
        ),
      ),
    );
  }

  void boostSpeed() async {
    while (_isGetPressure) {
      if (pressures < 120) {
        setState(() {
          pressures++;
        });
      }
      await Future.delayed(new Duration(milliseconds: 30));
    }
  }

  void handleEndEvent() {
    _isGetPressure = false;
    bringDownSpeed();
  }

  void bringDownSpeed() async {
    while (!_isGetPressure) {
      setState(() {
        pressures--;
      });

      if (pressures <= 0) {
        break;
      }
      await Future.delayed(new Duration(milliseconds: 30));
    }
  }
}

class DashBoardIndicatorPainter extends CustomPainter {
  final int speeds;
  double tableSpace;
  final Picture pictureBackGround;
  final Picture pictureIndicator;

  DashBoardIndicatorPainter(this.speeds, this.tableSpace,
      this.pictureBackGround, this.pictureIndicator);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPicture(pictureBackGround);
    drawIndicator(canvas, size);
    String text;
    if (speeds < 100) {
      text = (speeds * 2).toString() + "KM/H";
    } else {
      int s = speeds - 100;
      text = (100 * 2 + s * 3).toString() + "KM/H";
    }
    drawSpeendOnDashBoard(text, canvas, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  ///画实时得速度值到面板上
  void drawSpeendOnDashBoard(String text, Canvas canvas, Size size) {
    double halfHeight = size.height / 2;
    double halfWidth = size.width / 2;
    canvas.save();
    canvas.translate(halfWidth, halfHeight);

    TextPainter textPainter = TextPainter();
    textPainter.textDirection = TextDirection.ltr;
    textPainter.text = TextSpan(
        text: text,
        style: const TextStyle(
            color: Colors.deepOrangeAccent,
            fontSize: 25.0,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold));
    textPainter.layout();
    double textStarPositionX = -textPainter.size.width / 2;
    double textStarPositionY = 73;
    textPainter.paint(canvas, new Offset(textStarPositionX, textStarPositionY));

    canvas.restore();
  }

  ///画速度指针
  void drawIndicator(Canvas canvas, Size size) {
    double halfHeight = size.height / 2;
    double halfWidth = size.width / 2;

    canvas.save();
    canvas.translate(halfWidth, halfHeight);
    canvas.rotate((-60 + speeds) * tableSpace);
    canvas.translate(-halfWidth, -halfHeight);

    canvas.drawPicture(pictureIndicator);

    canvas.restore();
  }
}

/*
 * 速度指针
 */
class IndicatorPainter {
  final PictureRecorder _recorder = PictureRecorder();
  final Size size;

  IndicatorPainter(this.size);

  ///画速度指针
  Picture drawIndicator() {
    Canvas canvas = Canvas(_recorder);
    canvas.clipRect(new Rect.fromLTWH(0.0, 0.0, size.width, size.height));

    double halfHeight = size.height / 2;
    double halfWidth = size.width / 2;
    Path path = new Path();
    path.moveTo(-2.5, 20);
    path.lineTo(2.5, 20);
    path.lineTo(6.0, -30);
    path.lineTo(0.5, -halfHeight + 8);
    path.lineTo(-0.5, -halfHeight + 8);
    path.lineTo(-6.0, -30);
    path.close();
    canvas.save();

    canvas.translate(halfWidth, halfHeight);

    Paint paint = new Paint();
    paint.color = Colors.red;
    paint.style = PaintingStyle.fill;

    canvas.drawPath(path, paint);

    paint.color = Colors.black;
    canvas.drawCircle(new Offset(0.0, 0.0), 6, paint);

    canvas.restore();
    return _recorder.endRecording();
  }
}

/*
 * 表盘
 */
class DashBoardTablePainter {
  final double tableSpace;
  var speedTexts = [
    "0",
    "20",
    "40",
    "60",
    "80",
    "100",
    "120",
    "140",
    "160",
    "180",
    "200",
    "230",
    "260"
  ];
  final Size size;
  final PictureRecorder _recorder = PictureRecorder();

  DashBoardTablePainter(this.tableSpace, this.size);

  Picture getBackGround() {
    Canvas canvas = Canvas(_recorder);
    canvas.clipRect(new Rect.fromLTWH(0.0, 0.0, size.width, size.height));
    drawTable(canvas, size);
    return _recorder.endRecording();
  }

  ///画仪表盘的表格
  void drawTable(Canvas canvas, Size size) {
    canvas.save();
    double halfWidth = size.width / 2;
    double halfHeight = size.height / 2;
    canvas.translate(halfWidth, halfHeight);

    Paint paintMain = new Paint();
    paintMain.color = Colors.blue;
    paintMain.strokeWidth = 2.5;
    paintMain.style = PaintingStyle.fill;

    Paint paintOther = new Paint();
    paintOther.color = Colors.blue;
    paintOther.strokeWidth = 1;
    paintOther.style = PaintingStyle.fill;

    drawLongLine(canvas, paintMain, halfHeight, speedTexts[6]);

    canvas.save();
    for (int i = 61; i <= 120; i++) {
      canvas.rotate(tableSpace);
      if (i % 10 == 0) {
        int a = (i / 10).ceil();
        changePaintColors(paintMain, i);
        drawLongLine(canvas, paintMain, halfHeight, speedTexts[a]);
      } else if (i % 5 == 0) {
        changePaintColors(paintMain, i);
        drawMiddleLine(canvas, paintMain, halfHeight);
      } else {
        changePaintColors(paintOther, i);
        drawSmallLine(canvas, paintOther, halfHeight);
      }
    }
    canvas.restore();

    canvas.save();
    for (int i = 59; i >= 0; i--) {
      canvas.rotate(-tableSpace);
      if (i % 10 == 0) {
        int a = (i / 10).ceil();
        changePaintColors(paintMain, i);
        drawLongLine(canvas, paintMain, halfHeight, speedTexts[a]);
      } else if (i % 5 == 0) {
        changePaintColors(paintMain, i);
        drawMiddleLine(canvas, paintMain, halfHeight);
      } else {
        changePaintColors(paintOther, i);
        drawSmallLine(canvas, paintOther, halfHeight);
      }
    }
    canvas.restore();

    canvas.restore();
  }

  void changePaintColors(Paint paint, int value) {
    if (value <= 20) {
      paint.color = Colors.green;
    } else if (value < 80) {
      paint.color = Colors.blue;
    } else {
      paint.color = Colors.red;
    }
  }

  ///画仪表盘上的长线
  void drawLongLine(
      Canvas canvas, Paint paintMain, double halfHeight, String text) {
    canvas.drawLine(
        Offset(0.0, -halfHeight), Offset(0.0, -halfHeight + 15), paintMain);

    TextPainter textPainter = TextPainter();
    textPainter.textDirection = TextDirection.ltr;
    textPainter.text = TextSpan(
        text: text,
        style: TextStyle(
          color: paintMain.color,
          fontSize: 15.5,
        ));
    textPainter.layout();
    double textStarPositionX = -textPainter.size.width / 2;
    double textStarPositionY = -halfHeight + 19;
    textPainter.paint(canvas, Offset(textStarPositionX, textStarPositionY));
  }

  void drawMiddleLine(Canvas canvas, Paint paintMain, double halfHeight) {
    canvas.drawLine(
        Offset(0.0, -halfHeight), Offset(0.0, -halfHeight + 10), paintMain);
  }

  ///画短线
  void drawSmallLine(Canvas canvas, Paint paintOther, double halfHeight) {
    canvas.drawLine(
        Offset(0.0, -halfHeight), Offset(0.0, -halfHeight + 7), paintOther);
  }
}
