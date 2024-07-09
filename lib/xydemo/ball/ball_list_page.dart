import 'package:flutter/material.dart';
import 'package:flutter_xy/xydemo/ball/ball_model.dart';
import 'package:flutter_xy/xydemo/ball/ball_widget.dart';

class BallListPage extends StatefulWidget {
  const BallListPage({super.key});

  @override
  State<BallListPage> createState() => _BallListPageState();
}

class _BallListPageState extends State<BallListPage> {
  final List<Ball> badgeList = [
    Ball(name: '北京'),
    Ball(name: '上海'),
    Ball(name: '天津'),
    Ball(name: '徐州'),
    Ball(name: '南京'),
    Ball(name: '苏州'),
    Ball(name: '杭州'),
    Ball(name: '合肥'),
    Ball(name: '武汉'),
    Ball(name: '常州'),
    Ball(name: '香港'),
    Ball(name: '澳门'),
    Ball(name: '新疆'),
    Ball(name: '成都'),
    Ball(name: '宿迁'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PhysicsBallWidget(
            ballList: badgeList,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
        ],
      ),
    );
  }
}
