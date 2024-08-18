import 'package:flutter/material.dart';
import 'package:flutter_xy/r.dart';
import 'package:flutter_xy/xydemo/vp/pageview/auto_height_page_view.dart';

import '../../widgets/xy_app_bar.dart';

class AutoHeightPageViewPage extends StatefulWidget {
  const AutoHeightPageViewPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AutoHeightPageViewState();
}

class AutoHeightPageViewState extends State<AutoHeightPageViewPage> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: XYAppBar(
          title: '自适用高度PageView',
          onBack: () {
            Navigator.pop(context);
          }),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              AutoHeightPageView(
                pageController: _pageController,
                children: [
                  Container(
                    color: Colors.white,
                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Container(
                          color: Colors.red,
                          height: 50,
                          alignment: Alignment.center,
                          child: const Text("第一个界面"),
                        ),
                        Container(
                          color: Colors.yellow,
                          height: 50,
                          alignment: Alignment.center,
                          child: const Text("第一个界面"),
                        ),
                        Container(
                          color: Colors.blue,
                          height: 50,
                          alignment: Alignment.center,
                          child: const Text("第一个界面"),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      color: Colors.green,
                      height: 250,
                      child: const Center(child: Text('第二个界面'))),
                ],
              ),
              Image.asset(
                R.vp_content_jpg,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fill,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
