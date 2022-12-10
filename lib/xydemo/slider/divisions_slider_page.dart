import 'package:flutter/material.dart';
import 'package:flutter_xy/xydemo/slider/divisions_slider.dart';

import '../../widgets/xy_app_bar.dart';

class DivisionsSliderPage extends StatefulWidget {
  const DivisionsSliderPage({Key? key}) : super(key: key);

  @override
  State<DivisionsSliderPage> createState() => _DivisionsSliderPageState();
}

class _DivisionsSliderPageState extends State<DivisionsSliderPage> {
  var defaultValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: XYAppBar(
          title: "分段滑块",
          onBack: () {
            Navigator.pop(context);
          },
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "$defaultValue",
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              DivisionsSlider(
                value: defaultValue,
                onChanged: (value) {
                  defaultValue = value;
                  setState(() {});
                },
                divisions: const [0, 10, 30, 60, 100, 150],
                max: 150,
              ),
            ],
          ),
        ));
  }
}
