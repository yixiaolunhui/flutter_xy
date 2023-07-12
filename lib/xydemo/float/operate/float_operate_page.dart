import 'package:flutter/material.dart';
import 'package:flutter_xy/widgets/xy_app_bar.dart';
import 'package:flutter_xy/xydemo/float/operate/float_operate.dart';

import '../../../r.dart';

/*
 * 运营悬浮窗界面
 */
class FloatOperatePage extends StatefulWidget {
  const FloatOperatePage({Key? key}) : super(key: key);

  @override
  State<FloatOperatePage> createState() => _FloatOperatePageState();
}

class _FloatOperatePageState extends State<FloatOperatePage> {
  bool isScrolling = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: XYAppBar(
        title: "运营悬浮窗",
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification is ScrollStartNotification) {
                isScrolling = true;
                if (mounted) {
                  setState(() {});
                }
                return true;
              }
              if (scrollNotification is ScrollEndNotification) {
                isScrolling = false;
                if (mounted) {
                  setState(() {});
                }
                return true;
              }
              return false;
            },
            child: ListView(
              children: _itemList(),
            ),
          ),
          FloatOperateWidget(
            top: 50,
            alpha: 1,
            scrollAlpha: 0.5,
            percent: 1,
            scrollPercent: 0,
            isScrolling: isScrolling,
            child: Image.asset(
              R.fudai_png,
              width: 60,
              height: 60,
            ),
          ),
          FloatOperateWidget(
            top: 200,
            alpha: 1,
            scrollAlpha: 0.5,
            percent: 1,
            scrollPercent: 0.35,
            isScrolling: isScrolling,
            child: Image.asset(
              R.fuli1_png,
              width: 60,
              height: 60,
            ),
          ),
          FloatOperateWidget(
            top: 350,
            alpha: 1,
            scrollAlpha: 1.0,
            percent: 1,
            scrollPercent: 0.3,
            isScrolling: isScrolling,
            child: Image.asset(
              R.fuli2_png,
              width: 60,
              height: 60,
            ),
          ),
          FloatOperateWidget(
            top: 500,
            alpha: 1,
            scrollAlpha: 1.0,
            percent: 1,
            scrollPercent: 0.4,
            isScrolling: isScrolling,
            child: Image.asset(
              R.fuli3_png,
              width: 60,
              height: 60,
            ),
          ),
        ],
      ),
    );
  }

  /*
   * Item列表
   */
  _itemList() {
    var childList = <Widget>[];
    for (var i = 0; i < 50; i++) {
      childList.add(Container(
        color: i % 2 == 0 ? Colors.black12 : Colors.white30,
        height: 80,
        alignment: Alignment.center,
        child: Text(
          "测试数据：${i + 1}",
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
      ));
    }
    return childList;
  }
}
