import 'package:flutter/material.dart';

/// 底部弹出Widget
/// 1、支持手势下拉关闭
/// 2、支持动画弹出收起
/// 3、支持弹出无法关闭
class DragBottomSheetWidget extends StatefulWidget {
  DragBottomSheetWidget({
    required Key key,
    required this.builder,
    this.duration,
    this.childHeightRatio = 0.8,
    this.onStateChange,
  }) : super(key: key);

  Function(bool)? onStateChange;

  final double childHeightRatio;

  final Duration? duration;

  final ScrollableWidgetBuilder builder;

  @override
  State<DragBottomSheetWidget> createState() => DragBottomSheetWidgetState();
}

class DragBottomSheetWidgetState extends State<DragBottomSheetWidget>
    with TickerProviderStateMixin {
  final controller = DraggableScrollableController();

  //是否可以关闭
  bool isCanClose = true;

  //是否展开
  bool isExpand = false;

  double verticalDistance = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future show({bool isCanClose = true}) {
    return controller
        .animateTo(1,
            duration: widget.duration ?? const Duration(milliseconds: 200),
            curve: Curves.linear)
        .then((value) {
      if (!isCanClose) {
        setState(() {
          this.isCanClose = isCanClose;
        });
      }
    });
  }

  void hide() {
    controller.animateTo(
      0,
      duration: widget.duration ?? const Duration(milliseconds: 200),
      curve: Curves.linear,
    );
  }

  void _dragJumpTo(double y) {
    var size = y / MediaQuery.of(context).size.height;
    controller.jumpTo(widget.childHeightRatio - size);
  }

  void _dragEndChange() {
    controller.size >= widget.childHeightRatio / 2
        ? controller.animateTo(
            1,
            duration: widget.duration ?? const Duration(milliseconds: 200),
            curve: Curves.linear,
          )
        : hide();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        if (notification.extent == widget.childHeightRatio) {
          if (!isExpand) {
            isExpand = true;
            widget.onStateChange?.call(true);
          }
        } else if (notification.extent < 0.00001) {
          if (isExpand) {
            isExpand = false;
            widget.onStateChange?.call(false);
          }
        }
        return true;
      },
      child: DraggableScrollableSheet(
        initialChildSize: isCanClose && !isExpand ? 0 : widget.childHeightRatio,
        minChildSize: isCanClose ? 0 : widget.childHeightRatio,
        maxChildSize: widget.childHeightRatio,
        expand: true,
        snap: true,
        controller: controller,
        builder: (BuildContext context, ScrollController scrollController) {
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onVerticalDragDown: (details) {
              verticalDistance = 0;
            },
            onVerticalDragUpdate: (details) {
              verticalDistance += details.delta.dy;
              _dragJumpTo(verticalDistance);
            },
            onVerticalDragEnd: (details) {
              _dragEndChange();
            },
            child: widget.builder.call(context, scrollController),
          );
        },
      ),
    );
  }
}
