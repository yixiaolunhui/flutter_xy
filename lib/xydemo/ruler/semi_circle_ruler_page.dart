import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_xy/xydemo/ruler/semi_circle_ruler_widget.dart';

import '../../widgets/xy_app_bar.dart';

/*
 * 半圆刻度尺页面
 */
class SemiCircleRulerPage extends StatefulWidget {
  const SemiCircleRulerPage({Key? key}) : super(key: key);

  @override
  State<SemiCircleRulerPage> createState() => _SemiCircleRulerPageState();
}

class _SemiCircleRulerPageState extends State<SemiCircleRulerPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: XYAppBar(
        title: "半圆刻度尺",
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: const Center(
        widthFactor: 1,
        heightFactor: 1,
        child: SemiCircleRulerWidget(),
      ),
    );
  }
}
