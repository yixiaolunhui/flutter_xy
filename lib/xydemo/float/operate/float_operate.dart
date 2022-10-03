import 'package:flutter/cupertino.dart';

/*
 * 运营浮窗
 * A widget that controls where a child of a [Stack] is positioned.
 */
class FloatOperateWidget extends StatefulWidget {
  const FloatOperateWidget({
    Key? key,
    required this.child,
    this.top,
    this.bottom,
    this.width,
    this.height,
    this.isScrolling,
    this.duration = 200,
    this.alpha = 1.0,
    this.scrollAlpha = 1.0,
    this.percent = 1.0,
    this.scrollPercent = 0.5,
  }) : super(key: key);

  final Widget child;
  final double? top;
  final double? bottom;
  final double? width;
  final double? height;

  //是否滑动中
  final bool? isScrolling;

  //动画时长(水平动画)
  final int duration;

  //默认透明度
  final double? alpha;

  //滚动时透明度
  final double? scrollAlpha;

  //默认显示百分比
  final double? percent;

  //滚动显示百分比
  final double? scrollPercent;

  @override
  State<FloatOperateWidget> createState() => _FloatOperateWidgetState();
}

class _FloatOperateWidgetState extends State<FloatOperateWidget>
    with SingleTickerProviderStateMixin {
  //动画控制器
  late AnimationController _animationController;

  //平移动画
  late Animation<Offset> _slideAnimation;

  //透明度动画
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    //动画控制器
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: widget.duration));
    //平移动画
    _slideAnimation = Tween(
            begin: Offset(1.0 - (widget.percent ?? 1), 0),
            end: Offset(1.0 - (widget.scrollPercent ?? 0.5), 0))
        .animate(_animationController);
    //透明度动画
    _fadeAnimation = Tween(begin: widget.alpha, end: widget.scrollAlpha)
        .animate(_animationController);
  }

  @override
  void didUpdateWidget(covariant FloatOperateWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isScrolling == true) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.top,
      right: 0,
      bottom: widget.bottom,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: widget.child,
        ),
      ),
    );
  }
}
