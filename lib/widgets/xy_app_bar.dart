import 'package:flutter/material.dart';

///自定义AppBar
class XYAppBar extends AppBar {
  XYAppBar({
    Key? key,
    String? title,
    Color? backgroundColor,
    Color? titleColor,
    VoidCallback? onBack,
    List<Widget>? actions,
  }) : super(
          key: key,
          centerTitle: true,
          backgroundColor: backgroundColor ?? Colors.white,
          elevation: 0,
          actions: actions,
          title: Text(
            title ?? "",
            style: TextStyle(
              color: titleColor ?? Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: onBack == null
              ? Container()
              : IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: titleColor ?? Colors.black,
                  ),
                  onPressed: () {
                    onBack.call();
                  },
                ),
        );
}
