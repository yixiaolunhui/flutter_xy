import 'package:flutter/material.dart';
import 'package:flutter_xy/xydemo/carousel/carousel_page.dart';
import 'package:flutter_xy/xydemo/clock/clock_page.dart';
import 'package:flutter_xy/xydemo/ruler/ruler_page.dart';

import 'xy_info.dart';

class UIGroupDataConfig {
  static List<UIGroupInfo> getAllXY() {
    List<UIGroupInfo> groupList = [];
    //分组1
    groupList.add(_getXYGroup1());
    //分组2
    groupList.add(_getXYGroup2());
    return groupList;
  }

  ///自定义Widget
  static UIGroupInfo _getXYGroup1() {
    List<UIGroupInfo> children = [];

    children.add(UIGroupInfo(
      groupName: "自定义钟表",
      desc: "自定义钟表",
      onClick: (BuildContext context) {
        Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return const ClockPage();
          },
        ));
      },
    ));
    children.add(UIGroupInfo(
      groupName: "自定义尺子",
      desc: "自定义尺子",
      onClick: (BuildContext context) {
        Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return const RulerPage();
          },
        ));
      },
    ));
    children.add(UIGroupInfo(
      groupName: "旋转木马",
      desc: "旋转木马",
      onClick: (BuildContext context) {
        Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return const CarouselPage();
          },
        ));
      },
    ));

    return UIGroupInfo(
        groupName: "自定义Widget", children: children, isExpand: false);
  }

  ///高仿Widget
  static UIGroupInfo _getXYGroup2() {
    List<UIGroupInfo> children = [];
    return UIGroupInfo(
        groupName: "高仿Widget", children: children, isExpand: false);
  }
}
