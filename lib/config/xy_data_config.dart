import 'package:flutter/material.dart';
import 'package:flutter_xy/xydemo/arguments/arguments_test_page.dart';
import 'package:flutter_xy/xydemo/carousel/carousel_page.dart';
import 'package:flutter_xy/xydemo/chain/chain_dialog_page.dart';
import 'package:flutter_xy/xydemo/clock/clock_page.dart';
import 'package:flutter_xy/xydemo/code/code_page.dart';
import 'package:flutter_xy/xydemo/drawingboard/drawing_page.dart';
import 'package:flutter_xy/xydemo/emoji/emoji_anim_page.dart';
import 'package:flutter_xy/xydemo/loading/loading_page.dart';
import 'package:flutter_xy/xydemo/rating/rating_page.dart';
import 'package:flutter_xy/xydemo/ruler/ruler_page.dart';
import 'package:flutter_xy/xydemo/ruler/semi_circle_ruler_page.dart';
import 'package:flutter_xy/xydemo/scan/scan_line_page.dart';
import 'package:flutter_xy/xydemo/tabbar/xc_tabbar_widget.dart';
import 'package:flutter_xy/xydemo/tx/tx_banner_page.dart';
import 'package:flutter_xy/xydemo/wave/wave_page.dart';

import '../xydemo/darg/drag_bottom_sheet_page.dart';
import '../xydemo/float/float_page.dart';
import '../xydemo/float/operate/float_operate_page.dart';
import '../xydemo/image/image_switch_page.dart';
import '../xydemo/lifecycle/lifecycle_page.dart';
import '../xydemo/num/num_anim_page.dart';
import '../xydemo/search/record_page.dart';
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
    children.add(UIGroupInfo(
      groupName: "3D画廊",
      desc: "3D画廊",
      onClick: (BuildContext context) {
        Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return const ImageSwitchPage();
          },
        ));
      },
    ));
    children.add(UIGroupInfo(
      groupName: "搜索音频识别布局",
      desc: "搜索音频识别布局",
      onClick: (BuildContext context) {
        Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return const RecordPage();
          },
        ));
      },
    ));
    children.add(UIGroupInfo(
      groupName: "二维码扫描线",
      desc: "二维码扫描线",
      onClick: (BuildContext context) {
        Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return const ScanLinePage();
          },
        ));
      },
    ));
    children.add(UIGroupInfo(
      groupName: "携程首页类型切换",
      desc: "携程首页类型切换",
      onClick: (BuildContext context) {
        Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return const XieChengHomePage();
          },
        ));
      },
    ));
    children.add(UIGroupInfo(
      groupName: "画板",
      desc: "画板",
      onClick: (BuildContext context) {
        Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return const DrawingPage();
          },
        ));
      },
    ));
    children.add(UIGroupInfo(
      groupName: "Loading动画",
      desc: "Loading动画",
      onClick: (BuildContext context) {
        Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return const LoadingPage();
          },
        ));
      },
    ));
    children.add(UIGroupInfo(
      groupName: "三角形评分控件",
      desc: "三角形评分控件",
      onClick: (BuildContext context) {
        Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return const RatingPage();
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
    children.add(UIGroupInfo(
      groupName: "Flutter弹框链",
      desc: "Flutter弹框链",
      onClick: (BuildContext context) {
        Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return const ChainDialogPage();
          },
        ));
      },
    ));
    return UIGroupInfo(groupName: "功能类", children: children, isExpand: false);
  }
}
