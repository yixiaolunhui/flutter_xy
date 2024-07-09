import 'dart:async';

import 'package:flutter/material.dart';

class DragWidget extends StatefulWidget {
  const DragWidget({super.key, required this.child, this.onTap});

  final GestureTapCallback? onTap;
  final Widget child;

  @override
  State<StatefulWidget> createState() => _DragWidgetState();
}

class _DragWidgetState extends State<DragWidget> {
  String currentFps = "";
  Offset offset = const Offset(50, 30);
  Timer? refreshTimer;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, state) {
      return Positioned(
        top: offset.dy,
        left: offset.dx,
        child: GestureDetector(
          onPanUpdate: (detail) {
            state(() {
              offset =
                  _calOffset(MediaQuery.of(context).size, offset, detail.delta);
            });
          },
          onTap: widget.onTap,
          child: widget.child,
        ),
      );
    });
  }

  Offset _calOffset(Size size, Offset offset, Offset nextOffset) {
    var dx = 0.0;
    //水平方向偏移量不能小于0不能大于屏幕最大宽度
    if (offset.dx + nextOffset.dx <= 0) {
      dx = 0;
    } else if (offset.dx + nextOffset.dx >= (size.width - 50)) {
      dx = size.width - 50;
    } else {
      dx = offset.dx + nextOffset.dx;
    }
    var dy = 0.0;
    //垂直方向偏移量不能小于0不能大于屏幕最大高度
    if (offset.dy + nextOffset.dy >= (size.height - 100)) {
      dy = size.height - 100;
    } else if (offset.dy + nextOffset.dy <= kToolbarHeight) {
      dy = kToolbarHeight;
    } else {
      dy = offset.dy + nextOffset.dy;
    }
    return Offset(
      dx,
      dy,
    );
  }
}
