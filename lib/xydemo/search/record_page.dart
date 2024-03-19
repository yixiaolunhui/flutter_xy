import 'package:flutter/material.dart';
import 'package:flutter_xy/widgets/xy_app_bar.dart';

import '../../r.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({super.key});

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> with WidgetsBindingObserver {
  //键盘的高度
  double _keyboardHeight = 0;

  final GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: XYAppBar(
        title: "搜索音频识别",
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: Stack(
        children: [
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: TextField(
              decoration: InputDecoration(labelText: "请输入内容"),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            bottom: _offsetHeight <= 0 ? 0 : _offsetHeight,
            left: 0,
            right: 0,
            child: Image.asset(
              R.record_png,
              key: _key,
              width: 50,
              height: 50,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          //键盘高度
          _keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
        });
      }
    });
  }

  /// 录制图标偏移的高度
  double get _offsetHeight {
    if (_keyboardHeight == 0) return 0;
    final screenHeight = MediaQuery.of(context).size.height;
    final inputBox = _key.currentContext?.findRenderObject() as RenderBox?;
    final offset = inputBox?.localToGlobal(Offset.zero);
    final inputPosition = offset?.dy ?? 0;
    final inputHeight = inputBox?.size.height ?? 0;
    var offsetHeight =
        (inputPosition + inputHeight) - (screenHeight - _keyboardHeight);
    return offsetHeight;
  }
}
