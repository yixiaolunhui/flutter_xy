import 'package:flutter/material.dart';

///自定义AppBar
class XYAppBar extends AppBar {
  XYAppBar({
    Key? key,
    String? title,
    VoidCallback? onBack,
    List<Widget>? actions,
  }) : super(
          key: key,
          brightness: Brightness.light,
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          actions: actions,
          title: Text(
            title ?? "",
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: onBack == null
              ? Container()
              : IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    onBack.call();
                  },
                ),
        );
}
