import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xy/xydemo/common/widget/level_widget.dart';

import '../../widgets/xy_app_bar.dart';

class CommonWidgetPage extends StatefulWidget {
  const CommonWidgetPage({super.key});

  @override
  State<CommonWidgetPage> createState() => _CommonWidgetPageState();
}

class _CommonWidgetPageState extends State<CommonWidgetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.deepPurple.withAlpha(50),
        appBar: XYAppBar(
          title: "底部弹出布局",
          backgroundColor: Colors.transparent,
          titleColor: Colors.white,
          onBack: () {
            Navigator.pop(context);
          },
        ),
        body: Stack(
          children: [
            LevelWidget(level: 6)
          ],
        ));
  }
}
