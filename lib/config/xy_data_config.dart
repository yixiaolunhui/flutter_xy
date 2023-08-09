import 'package:flutter/material.dart';
import 'package:flutter_xy/xydemo/arguments/arguments_test_page.dart';
import 'package:flutter_xy/xydemo/carousel/carousel_page.dart';
import 'package:flutter_xy/xydemo/clock/clock_page.dart';
import 'package:flutter_xy/xydemo/code/code_page.dart';
import 'package:flutter_xy/xydemo/emoji/emoji_anim_page.dart';
import 'package:flutter_xy/xydemo/ruler/ruler_page.dart';
import 'package:flutter_xy/xydemo/ruler/semi_circle_ruler_page.dart';
import 'package:flutter_xy/xydemo/tx/tx_banner_page.dart';
import 'package:flutter_xy/xydemo/wave/wave_page.dart';

import '../xydemo/darg/drag_bottom_sheet_page.dart';
import '../xydemo/float/float_page.dart';
import '../xydemo/float/operate/float_operate_page.dart';
import '../xydemo/lifecycle/lifecycle_page.dart';
import '../xydemo/num/num_anim_page.dart';
import '../xydemo/slider/divisions_slider_page.dart';
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
    children.add(UIGroupInfo(
      groupName: "悬浮窗",
      desc: "悬浮窗",
      onClick: (BuildContext context) {
        Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return const FloatPage();
          },
        ));
      },
    ));
    children.add(UIGroupInfo(
      groupName: "量角器",
      desc: "量角器",
      onClick: (BuildContext context) {
        Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return const SemiCircleRulerPage();
          },
        ));
      },
    ));
    children.add(UIGroupInfo(
      groupName: "分段滑块",
      desc: "分段滑块",
      onClick: (BuildContext context) {
        Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return DivisionsSliderPage();
          },
        ));
      },
    ));
    children.add(UIGroupInfo(
      groupName: "表情雨",
      desc: "表情雨",
      onClick: (BuildContext context) {
        Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return const EmojiAnimPage();
          },
        ));
      },
    ));
    children.add(UIGroupInfo(
      groupName: "声波",
      desc: "声波",
      onClick: (BuildContext context) {
        Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return const WavePage();
          },
        ));
      },
    ));
    children.add(UIGroupInfo(
      groupName: "数字动画",
      desc: "数字动画",
      onClick: (BuildContext context) {
        Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return const NumAnimPage();
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
    children.add(UIGroupInfo(
      groupName: "验证码",
      desc: "验证码",
      onClick: (BuildContext context) {
        Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return const CodePage();
          },
        ));
      },
    ));
    children.add(UIGroupInfo(
      groupName: "运营悬浮窗",
      desc: "运营悬浮窗",
      onClick: (BuildContext context) {
        Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return const FloatOperatePage();
          },
        ));
      },
    ));
    children.add(UIGroupInfo(
      groupName: "底部弹出框",
      desc: "底部弹出框（支持手势关闭）",
      onClick: (BuildContext context) {
        Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return const DragBottomSheetPage();
          },
        ));
      },
    ));
    children.add(UIGroupInfo(
      groupName: "腾讯视频Banner",
      desc: "腾讯视频Banner",
      onClick: (BuildContext context) {
        Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return const ImageClippingPage();
          },
        ));
      },
    ));
    children.add(UIGroupInfo(
      groupName: "界面跳转参数处理",
      desc: "界面跳转参数处理",
      onClick: (BuildContext context) {
        Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return ArgumentsTestPage();
          },
        ));
      },
    ));
    children.add(UIGroupInfo(
      groupName: "Flutter生命周期",
      desc: "Flutter生命周期",
      onClick: (BuildContext context) {
        Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return const LifecyclePage();
          },
        ));
      },
    ));
    return UIGroupInfo(groupName: "功能类", children: children, isExpand: false);
  }
}
