import 'package:flutter/material.dart';
import 'package:flutter_xy/r.dart';
import 'package:flutter_xy/widgets/xy_app_bar.dart';
import 'package:flutter_xy/xydemo/carousel/carousel_widget.dart';

/*
 * 旋转木马
 */
class CarouselPage extends StatefulWidget {
  const CarouselPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CarouselShowState();
}

class CarouselShowState extends State<CarouselPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: XYAppBar(
          title: "旋转木马",
          onBack: () {
            Navigator.pop(context);
          }),
      body: Container(
        alignment: Alignment.center,
        child: Stack(
          children: [
            CarouselWidget(
              deviationRatio: 0.8,
              minScale: 0.5,
              childWidth: 85,
              childHeight: 85,
              isAuto: true,
              circleScale: 1,
              children: [
                Image.asset(
                  R.muma_png,
                  filterQuality: FilterQuality.high,
                ),
                Image.asset(
                  R.muma_png,
                  filterQuality: FilterQuality.high,
                ),
                Image.asset(
                  R.muma_png,
                  filterQuality: FilterQuality.high,
                ),
                Image.asset(
                  R.muma_png,
                  filterQuality: FilterQuality.high,
                ),
                Image.asset(
                  R.muma_png,
                  filterQuality: FilterQuality.high,
                ),
                Image.asset(
                  R.muma_png,
                  filterQuality: FilterQuality.high,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
