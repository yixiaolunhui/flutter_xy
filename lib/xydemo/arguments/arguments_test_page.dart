import 'package:flutter/material.dart';
import 'package:flutter_xy/route/route_const.dart';
import 'package:flutter_xy/widgets/xy_app_bar.dart';
import 'package:flutter_xy/xydemo/arguments/arguments_next_page.dart';

class ArgumentsTestPage extends StatefulWidget {
  const ArgumentsTestPage({super.key});

  @override
  State<ArgumentsTestPage> createState() => _ArgumentsTestPageState();
}

class _ArgumentsTestPageState extends State<ArgumentsTestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: XYAppBar(
        title: "界面跳转参数处理",
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: _bodyWidget(),
    );
  }

  _bodyWidget() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            "${RouteConst.routeNext}?name=dalong&&address=江苏省南京市",
            arguments: (TestArguments("一笑轮回", "江苏省徐州市")),
          );
        },
        child: const Text("跳转到下一页"),
      ),
    );
  }
}
