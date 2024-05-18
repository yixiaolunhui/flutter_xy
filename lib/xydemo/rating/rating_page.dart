import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_xy/xydemo/rating/rating_anim_widget.dart';

import '../../widgets/xy_app_bar.dart';

class RatingPage extends StatefulWidget {
  const RatingPage({super.key});

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  var upRating = 2;
  var leftRating = 3;
  var rightRating = 5;
  var maxRating = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: XYAppBar(
          title: "三角形评分控件",
          onBack: () {
            Navigator.pop(context);
          },
        ),
        body: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "时间管理",
                style: TextStyle(
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: 5.w),
              TriangleRatingAnimView(
                height: 200.w,
                width: 280.w,
                upRating: upRating,
                leftRating: leftRating,
                rightRating: rightRating,
                maxRating: maxRating,
                strokeWidth: 1.5.w,
                ratingStrokeWidth: 3.w,
              ),
              SizedBox(height: 5.w),
              Row(
                children: [
                  SizedBox(width: 10.w),
                  Text(
                    "成本控制",
                    style: TextStyle(
                      fontSize: 12.sp,
                    ),
                  ),
                  const Expanded(child: SizedBox.shrink()),
                  Text(
                    "质量保证",
                    style: TextStyle(
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(width: 10.w),
                ],
              ),
              SizedBox(height: 50.w),
              ElevatedButton(
                onPressed: () {
                  updateRatingData();
                },
                child: const Text("更改数据"),
              )
            ],
          ),
        ));
  }

  /// 更新星数指标数据
  void updateRatingData() {
    final random = Random();
    maxRating = 5 + random.nextInt(6);
    upRating = 1 + random.nextInt(maxRating);
    leftRating = 1 + random.nextInt(maxRating);
    rightRating = 1 + random.nextInt(maxRating);
    setState(() {});
  }
}
