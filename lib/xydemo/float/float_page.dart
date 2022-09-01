import 'package:flutter/material.dart';
import 'package:flutter_xy/xydemo/float/flutter_float.dart';

import '../../widgets/xy_app_bar.dart';

class FloatPage extends StatefulWidget {
  const FloatPage({Key? key}) : super(key: key);

  @override
  State<FloatPage> createState() => _FloatPageState();
}

class _FloatPageState extends State<FloatPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: XYAppBar(
              title: "钟表",
              onBack: () {
                Navigator.pop(context);
              }),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Text(
                  'this is flutter float',
                ),
              ],
            ),
          ),
        ),
        FloatingView(
          backEdge: true,
          offset: Offset(
            MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height * 3 / 4,
          ),
          //将要执行动画的子view
          child: const CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 40,
            backgroundImage: NetworkImage(
                "https://img2.baidu.com/it/u=2670411182,2972126738&fm=253&fmt=auto&app=138&f=JPEG?w=723&h=500"),
          ),
        ),
        FloatingView(
          backEdge: false,
          offset: const Offset(0, 200),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.deepOrange,
            ),
            child: const Text("我可以移动任何位置哦"),
          ),
        ),
      ],
    );
  }
}
