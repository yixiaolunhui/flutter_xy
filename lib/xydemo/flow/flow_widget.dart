import 'package:flutter/material.dart';

///流布局
class FlowWidget extends StatefulWidget {
  //最大行数
  final int maxLines;

  //标签列表
  final List<Text> children;

  //展开按钮
  final Widget? expandBtn;

  //收起按钮
  final Widget? retractBtn;

  const FlowWidget({
    super.key,
    required this.children,
    this.maxLines = -1,
    this.expandBtn,
    this.retractBtn,
  });

  @override
  State<FlowWidget> createState() => _FlowWidgetState();
}

class _FlowWidgetState extends State<FlowWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double widthSoFar = 0.0;
        int lines = 0;
        List<Widget> toDisplay = [];
        for (int i = 0; i < widget.children.length; i++) {
          final textWidget = widget.children[i];
          final textWidth = _getTextWidth(textWidget, context);
          if (widthSoFar + textWidth > constraints.maxWidth) {
            lines++;
            widthSoFar = textWidth + 20;
            if (lines >= widget.maxLines &&
                !isExpanded &&
                widget.expandBtn != null) {
              toDisplay.add(GestureDetector(
                onTap: () {
                  setState(() {
                    isExpanded = true;
                  });
                },
                child: widget.expandBtn,
              ));
              break;
            }
          } else {
            widthSoFar += textWidth + 20;
          }

          toDisplay.add(Container(
            margin: const EdgeInsets.all(5.0),
            padding: const EdgeInsets.all(10.0),
            color: Colors.teal,
            child: textWidget,
          ));
        }

        if (isExpanded && widget.retractBtn != null) {
          toDisplay.add(GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = false;
              });
            },
            child: widget.retractBtn,
          ));
        }

        return SingleChildScrollView(
          child: Wrap(
            children: toDisplay,
          ),
        );
      },
    );
  }


  ///获取text的宽度
  double _getTextWidth(Text text, BuildContext context) {
    final painter = TextPainter(
      text: TextSpan(text: text.data, style: text.style),
      maxLines: text.maxLines,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return painter.size.width;
  }
}
