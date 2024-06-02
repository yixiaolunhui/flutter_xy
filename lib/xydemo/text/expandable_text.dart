import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;
  final TextStyle? textStyle;

  const ExpandableText({
    Key? key,
    required this.text,
    required this.maxLines,
    this.textStyle,
  }) : super(key: key);

  @override
  ExpandableTextState createState() => ExpandableTextState();
}

class ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final maxWidth = constraints.maxWidth;
        final textSpan = TextSpan(
          text: widget.text,
          style: widget.textStyle ?? const TextStyle(color: Colors.black),
        );

        final textPainter = TextPainter(
          text: textSpan,
          maxLines: isExpanded ? null : widget.maxLines,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout(maxWidth: maxWidth);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isExpanded
                ? _buildExpandedText()
                : _buildCollapsedText(textPainter, maxWidth),
          ],
        );
      },
    );
  }

  Widget _buildCollapsedText(TextPainter textPainter, double maxWidth) {
    final expandSpan = TextSpan(
      text: " 展开",
      style: const TextStyle(color: Colors.blue),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
    );

    final linkTextSpan = TextSpan(
      text: '...',
      style: widget.textStyle ?? const TextStyle(color: Colors.black),
      children: [expandSpan],
    );

    final linkPainter = TextPainter(
      text: linkTextSpan,
      textDirection: TextDirection.ltr,
    );
    linkPainter.layout(maxWidth: maxWidth);

    final position = textPainter.getPositionForOffset(
        Offset(maxWidth - linkPainter.width, textPainter.height));
    final endOffset =
        textPainter.getOffsetBefore(position.offset) ?? position.offset;
    final truncatedText = widget.text.substring(0, endOffset);

    return RichText(
      text: TextSpan(
        text: truncatedText,
        style: widget.textStyle ?? const TextStyle(color: Colors.black),
        children: [linkTextSpan],
      ),
      maxLines: widget.maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildExpandedText() {
    final collapseSpan = TextSpan(
      text: " 收起",
      style: const TextStyle(color: Colors.blue),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
    );

    return RichText(
      text: TextSpan(
        text: widget.text,
        style: widget.textStyle ?? const TextStyle(color: Colors.black),
        children: [collapseSpan],
      ),
    );
  }
}
