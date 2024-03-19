import 'package:flutter/material.dart';

import '../../widgets/xy_app_bar.dart';


class XieChengHomePage extends StatefulWidget {
  const XieChengHomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return XieChengHomePageState();
  }
}

class XieChengHomePageState extends State<XieChengHomePage> with TickerProviderStateMixin {
  late TabController tabController;

  List<String> tabs = [
    "飞机票",
    "火车高铁票",
    "公交车",
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Colors.red,
          appBar: XYAppBar(
            title: "Trapezoid Indicator Example",
            onBack: () {
              Navigator.pop(context);
            },
          ),
          body: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: CustomTabbarWidget(
                  tabController: tabController,
                  tabs: tabs,
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: const [
                    Center(child: Text('Tab 1 Content')),
                    Center(child: Text('Tab 2 Content')),
                    Center(child: Text('Tab 3 Content')),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

class CustomTabbarWidget extends StatefulWidget {
  final TabController tabController;
  final List<String> tabs;

  const CustomTabbarWidget({
    Key? key,
    required this.tabController,
    required this.tabs,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CustomTabbarState();
  }
}

class CustomTabbarState extends State<CustomTabbarWidget> {
  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var tabWidth = constraints.maxWidth / widget.tabs.length;
      var currentWidth = tabWidth * 1.5;
      var offset =
          (constraints.maxWidth - currentWidth) / (widget.tabs.length - 1);
      return Container(
        width: constraints.maxWidth,
        child: Stack(
          children: [
            SizedBox(
              width: constraints.maxWidth,
              height: 60,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(80),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Row(
                  children: widget.tabs.asMap().keys.map((index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: index == widget.tabController.index
                          ? currentWidth
                          : offset,
                      child: InkWell(
                        key: ObjectKey(index),
                        onTap: () {
                          widget.tabController.animateTo(index);
                          setState(() {});
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            widget.tabs[index],
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              left: widget.tabController.index * offset,
              bottom: 0,
              child: IgnorePointer(
                child: ClipPath(
                  clipper:
                      TrapezoidClipper(tabController: widget.tabController),
                  child: Container(
                      height: 60,
                      alignment: Alignment.center,
                      width: currentWidth,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                widget.tabs[widget.tabController.index],
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.blue),
                              ),
                            ),
                          ),
                          TextUnderline(
                              text: widget.tabs[widget.tabController.index],
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.blue),
                              lineColor: Colors.blue,
                              height: 4),
                        ],
                      )),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class TrapezoidClipper extends CustomClipper<Path> {
  TrapezoidClipper({required this.tabController});

  TabController tabController;

  @override
  Path getClip(Size size) {
    var isLeft = tabController.index == 0;
    var isRight = tabController.index == tabController.length - 1;
    double inset = size.width * 0.1;
    double radius = 8.0;
    // path.moveTo(isLeft ? 0 : inset, 0);
    // path.lineTo(isRight ? size.width : size.width - inset, 0);
    // path.lineTo(size.width, size.height);
    // path.lineTo(0, size.height);

    final path = Path()
      ..moveTo(radius, 0) // 移动到起始点
      ..lineTo(size.width - radius, 0) // 顶边线
      ..quadraticBezierTo(size.width, 0, size.width, radius) // 右上角圆角
      ..lineTo(size.width, size.height - radius) // 右边线
      ..quadraticBezierTo(
          size.width, size.height, size.width - radius, size.height) // 右下角圆角
      ..lineTo(radius, size.height) // 底边线
      ..quadraticBezierTo(0, size.height, 0, size.height - radius) // 左下角圆角
      ..lineTo(0, radius) // 左边线
      ..quadraticBezierTo(0, 0, radius, 0); // 左上角圆角

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class TextUnderline extends StatelessWidget {
  const TextUnderline({
    Key? key,
    required this.text,
    required this.style,
    required this.lineColor,
    required this.height,
  }) : super(key: key);
  final String text;
  final TextStyle style;
  final Color lineColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: style,
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    var textWidth = textPainter.width;
    return Container(
      width: textWidth,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(height),
        ),
        color: lineColor,
      ),
    );
  }
}
