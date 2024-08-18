import 'package:flutter/material.dart';

class HeightMeasureWidget extends StatefulWidget {
  final Widget child;
  final Function(double height) onHeightChanged;

  const HeightMeasureWidget(
      {super.key, required this.child, required this.onHeightChanged});

  @override
  HeightMeasureState createState() => HeightMeasureState();
}

class HeightMeasureState extends State<HeightMeasureWidget> {
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measureHeight();
    });
  }

  void _measureHeight() {
    final RenderBox? renderBox =
        _key.currentContext!.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      widget.onHeightChanged(renderBox.size.height);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _key,
      child: widget.child,
    );
  }
}
