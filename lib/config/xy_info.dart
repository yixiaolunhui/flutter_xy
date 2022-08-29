import 'package:flutter/cupertino.dart';

///小样组信息
class UIGroupInfo {
  // 小样组名称
  String groupName;

  // 描述
  String desc;

  // 是否展开
  bool isExpand;

  // 子Widget
  List<UIGroupInfo>? children;

  // 点击回调
  Function(BuildContext context)? onClick;

  UIGroupInfo({
    this.groupName = "",
    this.desc = "",
    this.isExpand = false,
    this.children,
    this.onClick,
  });
}
