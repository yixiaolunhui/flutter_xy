import 'package:flutter/material.dart';

class TagFlowWidget extends StatefulWidget {
  final List<String> items;
  final int maxRows;
  final double spaceHorizontal;
  final double spaceVertical;
  final double itemHeight;
  final Color? itemBgColor;
  final BorderRadiusGeometry? borderRadius;
  final double? horizontalPadding;
  final TextStyle? itemStyle;

  const TagFlowWidget({
    Key? key,
    required this.items,
    required this.maxRows,
    required this.itemHeight,
    this.borderRadius,
    this.horizontalPadding,
    this.spaceHorizontal = 0,
    this.spaceVertical = 0,
    this.itemBgColor,
    this.itemStyle,
  }) : super(key: key);

  @override
  TagFlowWidgetState createState() => TagFlowWidgetState();
}

class TagFlowWidgetState extends State<TagFlowWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final maxWidth = constraints.maxWidth;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Flow(
              delegate: TagFlowDelegate(
                maxRows: widget.maxRows,
                isExpanded: isExpanded,
                maxWidth: maxWidth,
                itemHeight: widget.itemHeight,
                spaceHorizontal: widget.spaceHorizontal,
                spaceVertical: widget.spaceVertical,
                itemCount: widget.items.length,
              ),
              children: [
                ...widget.items.map((item) {
                  return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: widget.horizontalPadding ?? 0,
                      ),
                      height: widget.itemHeight,
                      decoration: BoxDecoration(
                        color: widget.itemBgColor,
                        borderRadius: widget.borderRadius,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item,
                            style: widget.itemStyle,

                          ),
                        ],
                      ));
                }).toList(),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: widget.horizontalPadding ?? 0,
                    ),
                    height: widget.itemHeight,
                    decoration: BoxDecoration(
                      color: widget.itemBgColor,
                      borderRadius: widget.borderRadius,
                    ),
                    child: Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class TagFlowET {
  static int maxRowCount = 0;
}

class TagFlowDelegate extends FlowDelegate {
  final double maxWidth;
  final double spaceHorizontal;
  final double spaceVertical;
  int maxRows;
  final bool isExpanded;
  double height = 0;
  final double itemHeight;
  final int itemCount;

  TagFlowDelegate({
    required this.maxWidth,
    required this.itemCount,
    required this.spaceHorizontal,
    required this.spaceVertical,
    required this.maxRows,
    required this.isExpanded,
    required this.itemHeight,
  }) {
    if (!isExpanded) {
      TagFlowET.maxRowCount = maxRows;
    }
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    TagFlowET.maxRowCount = _getMaxRowCount(context);
    if (maxRows >= TagFlowET.maxRowCount) {
      maxRows = TagFlowET.maxRowCount;
    }
    double x = 0;
    double y = 0;
    double rowHeight = 0;
    int rowCount = 1;
    for (int i = 0; i < context.childCount; i++) {
      final childSize = context.getChildSize(i)!;
      final arrowBtnSize = context.getChildSize(context.childCount - 1)!;

      if (rowCount >= maxRows &&
          !isExpanded &&
          (x + childSize.width + arrowBtnSize.width) >= maxWidth) {
        context.paintChild(
          context.childCount - 1,
          transform: Matrix4.translationValues(x, y, 0),
        );
        break;
      }

      if (x + childSize.width > maxWidth) {
        x = 0;
        y += rowHeight + spaceVertical;
        rowHeight = 0;
        rowCount++;
      }

      if (!(i == context.childCount - 1 && isExpanded && rowCount <= maxRows)) {
        context.paintChild(
          i,
          transform: Matrix4.translationValues(x, y, 0),
        );
      }

      x += childSize.width + spaceHorizontal;
      rowHeight = childSize.height;
    }
  }

  int _getMaxRowCount(FlowPaintingContext context) {
    double x = 0;
    var rowCount = 1;
    for (int i = 0; i < context.childCount; i++) {
      final childSize = context.getChildSize(i)!;
      final arrowSize = context.getChildSize(context.childCount - 1)!;
      if (x + childSize.width > maxWidth) {
        x = 0;
        rowCount++;
      }
      if (i == context.childCount - 1 &&
          (x + childSize.width + arrowSize.width) > maxWidth) {
        rowCount++;
      }
      x += childSize.width + spaceHorizontal;
    }
    return rowCount;
  }

  @override
  Size getSize(BoxConstraints constraints) {
    final height = (itemHeight * TagFlowET.maxRowCount) +
        (spaceVertical * (TagFlowET.maxRowCount - 1));
    return Size(constraints.maxWidth, height);
  }

  @override
  bool shouldRelayout(covariant FlowDelegate oldDelegate) {
    return oldDelegate != this ||
        (oldDelegate as TagFlowDelegate).isExpanded != isExpanded;
  }

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) {
    return oldDelegate != this ||
        (oldDelegate as TagFlowDelegate).isExpanded != isExpanded;
  }
}
