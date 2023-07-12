import 'package:flutter/material.dart';

class TxBannerWidget extends StatefulWidget {
  const TxBannerWidget({
    super.key,
    required this.width,
    required this.height,
  });

  final int width;
  final int height;

  @override
  State<TxBannerWidget> createState() => _TxBannerWidgetState();
}

class _TxBannerWidgetState extends State<TxBannerWidget> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {

      },
    );
  }
}
