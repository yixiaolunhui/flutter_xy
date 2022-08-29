import 'package:flutter/material.dart';
import 'package:flutter_xy/widgets/xy_app_bar.dart';
import 'package:flutter_xy/xydemo/clock/clock_view.dart';

///绘制钟表
class ClockPage extends StatefulWidget {
  const ClockPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ClockPageState();
  }
}

class ClockPageState extends State<ClockPage> {
  //是否绘制边框
  bool isDrawBorder = true;

  //是否绘制刻度
  bool isDrawScale = true;

  //是否绘制数字
  bool isDrawNumber = true;

  //是否绘制移动小球
  bool isDrawMoveBall = false;

  //是否绘制时针
  bool isDrawHourHand = true;

  //是否绘制分针
  bool isDrawMinuteHand = true;

  //是否绘制秒针
  bool isDrawSecondHand = true;

  //是否绘制中间圆圈
  bool isDrawMiddleCircle = true;

  //是否移动
  bool isMove = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: XYAppBar(
          title: "钟表",
          onBack: () {
            Navigator.pop(context);
          }),
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            child: Center(
              child: ClockView(
                radius: 150,
                isDrawBorder: isDrawBorder,
                isDrawScale: isDrawScale,
                isDrawNumber: isDrawNumber,
                isDrawMoveBall: isDrawMoveBall,
                isDrawHourHand: isDrawHourHand,
                isDrawMinuteHand: isDrawMinuteHand,
                isDrawSecondHand: isDrawSecondHand,
                isDrawMiddleCircle: isDrawMiddleCircle,
                isMove: isMove,
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.deepPurple,
              child: ListView(
                children: <Widget>[
                  SwitchListTile(
                    title: Text('是否绘制边框'),
                    value: isDrawBorder,
                    onChanged: (value) {
                      setState(() {
                        isDrawBorder = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: Text('是否绘制刻度'),
                    value: isDrawScale,
                    onChanged: (value) {
                      setState(() {
                        isDrawScale = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: Text('是否绘制数字'),
                    value: isDrawNumber,
                    onChanged: (value) {
                      setState(() {
                        isDrawNumber = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: Text('是否绘制时针'),
                    value: isDrawHourHand,
                    onChanged: (value) {
                      setState(() {
                        isDrawHourHand = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: Text('是否绘制分针'),
                    value: isDrawMinuteHand,
                    onChanged: (value) {
                      setState(() {
                        isDrawMinuteHand = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: Text('是否绘制秒针'),
                    value: isDrawSecondHand,
                    onChanged: (value) {
                      setState(() {
                        isDrawSecondHand = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: Text('是否绘制中间圆'),
                    value: isDrawMiddleCircle,
                    onChanged: (value) {
                      setState(() {
                        isDrawMiddleCircle = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: Text('是否绘制移动小球'),
                    value: isDrawMoveBall,
                    onChanged: (value) {
                      setState(() {
                        isDrawMoveBall = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: Text('是否移动'),
                    value: isMove,
                    onChanged: (value) {
                      setState(() {
                        isMove = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
