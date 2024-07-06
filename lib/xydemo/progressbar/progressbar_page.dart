import 'package:flutter/material.dart';

class ProgressbarPage extends StatelessWidget {
  const ProgressbarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('双向PK进度条')),
        body: const Center(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PKProgressBar(
                leftValue: 75,
                rightValue: 150,
                leftColor: Colors.blue,
                rightColor: Colors.red,
                height: 20,
                transitionType: TransitionType.diagonal, // 设置过渡类型为斜角
              ),
              SizedBox(height: 50),
              PKProgressBar(
                leftValue: 90,
                rightValue: 55,
                leftColor: Colors.brown,
                rightColor: Colors.green,
                height: 20,
                transitionType: TransitionType.vertical, // 设置过渡类型为斜角
              ),
            ],
          ),
        )),
      ),
    );
  }
}

// 定义过渡类型枚举
enum TransitionType { vertical, diagonal }

class PKProgressBar extends StatelessWidget {
  final double leftValue;
  final double rightValue;
  final Color leftColor;
  final Color rightColor;
  final double height;
  final TransitionType transitionType;

  const PKProgressBar({
    super.key,
    required this.leftValue,
    required this.rightValue,
    required this.leftColor,
    required this.rightColor,
    this.height = 20.0,
    this.transitionType = TransitionType.diagonal, // 默认过渡类型为竖直
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(double.infinity, height),
      painter: PKProgressPainter(
        leftValue: leftValue,
        rightValue: rightValue,
        leftColor: leftColor,
        rightColor: rightColor,
        transitionType: transitionType,
      ),
    );
  }
}

class PKProgressPainter extends CustomPainter {
  final double leftValue;
  final double rightValue;
  final Color leftColor;
  final Color rightColor;
  final TransitionType transitionType;

  PKProgressPainter({
    required this.leftValue,
    required this.rightValue,
    required this.leftColor,
    required this.rightColor,
    required this.transitionType,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    final double totalValue = leftValue + rightValue;
    final double leftWidth = (leftValue / totalValue) * size.width;
    final double rightWidth = (rightValue / totalValue) * size.width;
    final double radius = size.height / 2;

    // 左侧带圆角的矩形
    final leftRRect = RRect.fromLTRBAndCorners(
      0,
      0,
      leftWidth,
      size.height,
      topLeft: Radius.circular(radius),
      bottomLeft: Radius.circular(radius),
    );

    // 右侧带圆角的矩形
    final rightRRect = RRect.fromLTRBAndCorners(
      leftWidth,
      0,
      size.width,
      size.height,
      topRight: Radius.circular(radius),
      bottomRight: Radius.circular(radius),
    );

    // 绘制左侧部分
    paint.color = leftColor;
    canvas.drawRRect(leftRRect, paint);

    // 绘制右侧部分
    paint.color = rightColor;
    canvas.drawRRect(rightRRect, paint);

    // 根据过渡类型绘制中间部分
    if (transitionType == TransitionType.vertical) {
      // 竖直过渡
      final middleRect = Rect.fromLTWH(
        leftWidth - radius,
        0,
        2 * radius,
        size.height,
      );
      paint.color = rightColor;
      canvas.drawRect(middleRect, paint);
    } else if (transitionType == TransitionType.diagonal) {
      // 斜角过渡，形成45度斜线
      final leftPath = Path()
        ..moveTo(leftWidth - size.height / 2, 0)
        ..lineTo(leftWidth + size.height / 2, size.height)
        ..lineTo(leftWidth - size.height / 2, size.height)
        ..close();
      paint.color = leftColor;
      canvas.drawPath(leftPath, paint);

      // 斜角过渡，形成45度斜线
      final rightPath = Path()
        ..moveTo(leftWidth - size.height / 2, 0)
        ..lineTo(leftWidth, 0)
        ..lineTo(leftWidth, size.height / 2)
        ..close();
      paint.color = rightColor;
      canvas.drawPath(rightPath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
