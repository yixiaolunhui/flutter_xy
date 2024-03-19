import 'package:flutter/material.dart';
import 'package:flutter_xy/xydemo/scan/scan_line_moving_bar.dart';

import '../../widgets/xy_app_bar.dart';

class ScanLinePage extends StatefulWidget {
  const ScanLinePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return ScanLineState();
  }
}

class ScanLineState extends State<ScanLinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: XYAppBar(
        title: "Scan Line Moving Bar",
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: Center(
        child: Stack(
          children: [
            /// 这里是你的二维码扫描控件
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Colors.blue,
                ),
              ),
            ),

            /// 盖在上面
            ScanLineMovingBar(
              width: 200,
              height: 200,
              lineColor: Colors.red,
              lineHeight: 2,
            ),
          ],
        ),
      ),
    );
  }
}
