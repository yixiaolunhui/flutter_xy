import 'package:flutter/material.dart';
import 'package:flutter_xy/widgets/xy_app_bar.dart';
import 'package:flutter_xy/xydemo/ruler/ruler_view.dart';

///尺子
class RulerPage extends StatefulWidget {
  const RulerPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return RulerState();
  }
}

class RulerState extends State<RulerPage> {
  int number = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: XYAppBar(
        title: "尺子",
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "$number",
              style: const TextStyle(fontSize: 20, color: Colors.black),
            ),
            const SizedBox(height: 30),
            RulerView(
              width: MediaQuery.of(context).size.width.ceil(),
              height: 60,
              value: number,
              minValue: 40,
              maxValue: 100,
              step: 2,
              subScaleWidth: 10,
              subScaleCountPerScale: 10,
              scaleColor: Colors.black,
              scaleWidth: 2,
              scaleTextColor: Colors.black,
              scaleTextWidth: 15,
              onSelectedChanged: (result) {
                setState(() {
                  number = result;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
