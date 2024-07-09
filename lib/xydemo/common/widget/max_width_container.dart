import 'dart:math';

import 'package:flutter/material.dart';

/// 最大宽度限制 Container
class MaxWidthContainer extends StatefulWidget {
  const MaxWidthContainer({
    Key? key,
    required this.child,
    required this.maxWidth,
  }) : super(key: key);
  final Widget child;
  final double maxWidth;

  @override
  State<MaxWidthContainer> createState() => _MaxWidthContainerState();
}

class _MaxWidthContainerState extends State<MaxWidthContainer> {
  final GlobalKey _key = GlobalKey();
  double? width;
  double opacity = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var widgetWidth = _key.currentContext?.size?.width ?? 0;
      setState(() {
        opacity = 1;
        width = min(widget.maxWidth, widgetWidth);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: SizedBox(
        key: _key,
        width: width,
        child: widget.child,
      ),
    );
  }
}
