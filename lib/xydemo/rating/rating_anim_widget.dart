import 'package:flutter/material.dart';

/// 三角形等级评分的控件
class TriangleRatingAnimView extends StatefulWidget {
  final double width; // 控件宽度
  final double height; // 控件高度
  final int maxRating; // 最大评分
  final int upRating; // 上顶点评分
  final int leftRating; // 左顶点评分
  final int rightRating; // 右顶点评分
  final Color strokeColor; // 三角形边框颜色
  final double strokeWidth; // 三角形边框宽度
  final Color ratingStrokeColor; // 评分三角形边框颜色
  final double ratingStrokeWidth; // 评分三角形边框宽度

  const TriangleRatingAnimView({
    Key? key,
    required this.width,
    required this.height,
    this.maxRating = 5,
    this.upRating = 0,
    this.leftRating = 0,
    this.rightRating = 0,
    this.strokeColor = Colors.grey,
    this.strokeWidth = 1,
    this.ratingStrokeColor = Colors.red,
    this.ratingStrokeWidth = 2,
  }) : super(key: key);

  @override
  TriangleRatingAnimViewState createState() => TriangleRatingAnimViewState();
}

class TriangleRatingAnimViewState extends State<TriangleRatingAnimView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _startAnimations();
  }

  @override
  void didUpdateWidget(TriangleRatingAnimView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.upRating != widget.upRating ||
        oldWidget.leftRating != widget.leftRating ||
        oldWidget.rightRating != widget.rightRating) {
      _startAnimations();
    }
  }

  void _startAnimations() {
    _controller.reset();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.width, widget.height),
          painter: TrianglePainter(
            upRating: (widget.upRating * _animation.value).toInt(),
            rightRating: (widget.rightRating * _animation.value).toInt(),
            leftRating: (widget.leftRating * _animation.value).toInt(),
            strokeWidth: widget.strokeWidth,
            ratingStrokeWidth: widget.ratingStrokeWidth,
            strokeColor: widget.strokeColor,
            ratingStrokeColor: widget.ratingStrokeColor,
            maxRating: widget.maxRating,
          ),
        );
      },
    );
  }
}

class TrianglePainter extends CustomPainter {
  final int maxRating;
  final int upRating;
  final int leftRating;
  final int rightRating;
  final Color strokeColor;
  final double strokeWidth;
  final Color ratingStrokeColor;
  final double ratingStrokeWidth;

  TrianglePainter({
    required this.maxRating,
    required this.upRating,
    required this.leftRating,
    required this.rightRating,
    required this.strokeWidth,
    required this.ratingStrokeWidth,
    required this.strokeColor,
    required this.ratingStrokeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final outerPaint = Paint()
      ..color = ratingStrokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = ratingStrokeWidth;

    final fillPaint = Paint()
      ..color = ratingStrokeColor.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final circlePaint = Paint()
      ..color = ratingStrokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final circleFillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // 计算三角形顶点坐标
    final p1 = Offset(size.width / 2, 0); // 顶部顶点
    final p2 = Offset(0, size.height); // 左下顶点
    final p3 = Offset(size.width, size.height); // 右下顶点

    // 绘制外部三角形
    final path = Path()
      ..moveTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy)
      ..lineTo(p3.dx, p3.dy)
      ..close();
    canvas.drawPath(path, paint);

    // 计算重心
    final centroid = Offset(
      (p1.dx + p2.dx + p3.dx) / 3,
      (p1.dy + p2.dy + p3.dy) / 3,
    );

    // 绘制顶点到重心的连线
    canvas.drawLine(p1, centroid, paint);
    canvas.drawLine(p2, centroid, paint);
    canvas.drawLine(p3, centroid, paint);

    // 根据评分计算动态顶点
    final dynamicP1 = Offset(
      centroid.dx + (p1.dx - centroid.dx) * (upRating / maxRating),
      centroid.dy + (p1.dy - centroid.dy) * (upRating / maxRating),
    );
    final dynamicP2 = Offset(
      centroid.dx + (p2.dx - centroid.dx) * (leftRating / maxRating),
      centroid.dy + (p2.dy - centroid.dy) * (leftRating / maxRating),
    );
    final dynamicP3 = Offset(
      centroid.dx + (p3.dx - centroid.dx) * (rightRating / maxRating),
      centroid.dy + (p3.dy - centroid.dy) * (rightRating / maxRating),
    );

    // 绘制内部动态三角形
    final ratingPath = Path()
      ..moveTo(dynamicP1.dx, dynamicP1.dy)
      ..lineTo(dynamicP2.dx, dynamicP2.dy)
      ..lineTo(dynamicP3.dx, dynamicP3.dy)
      ..close();
    canvas.drawPath(ratingPath, outerPaint);
    canvas.drawPath(ratingPath, fillPaint);

    // 绘制动态点上的空心圆
    const circleRadius = 5.0;
    canvas.drawCircle(dynamicP1, circleRadius, circlePaint);
    canvas.drawCircle(dynamicP1, circleRadius - 1.5, circleFillPaint); // 填充白色
    canvas.drawCircle(dynamicP2, circleRadius, circlePaint);
    canvas.drawCircle(dynamicP2, circleRadius - 1.5, circleFillPaint); // 填充白色
    canvas.drawCircle(dynamicP3, circleRadius, circlePaint);
    canvas.drawCircle(dynamicP3, circleRadius - 1.5, circleFillPaint); // 填充白色
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
