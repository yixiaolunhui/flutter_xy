import 'package:flutter/material.dart';
import 'package:flutter_xy/widgets/xy_app_bar.dart';
import 'package:flutter_xy/xydemo/arguments/arguments.dart';

/// 测试数据模型
class TestArguments {
  String? name;
  String? address;

  TestArguments(this.name, this.address);
}

///第二页
class ArgumentsNextPage extends StatefulWidget
    with ArgumentsMixin, RouteQueryMixin {
  ArgumentsNextPage({super.key});

  @override
  State<ArgumentsNextPage> createState() => _ArgumentsNextPageState();
}

class _ArgumentsNextPageState extends State<ArgumentsNextPage> {
  /// 传参数据文本
  String get result {
    // Arguments传参数据
    TestArguments? arguments;
    if (widget.arguments != null && widget.arguments is TestArguments) {
      arguments = widget.arguments as TestArguments;
    }

    // 路由拼接的数据
    var params = widget.routeParams;

    // 拼接结果数据
    return "arguments:name=${arguments?.name ?? ""} address=${arguments?.address ?? ""} \nrouteParams=$params";
  }

  @override
  void initState() {
    super.initState();
    print("result=$result}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: XYAppBar(
        title: "第二页",
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: Center(
        child: Text(result),
      ),
    );
  }
}
