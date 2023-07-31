import 'package:flutter/material.dart';
import 'package:flutter_xy/route/route_const.dart';
import 'package:flutter_xy/xydemo/arguments/arguments_next_page.dart';
import 'package:flutter_xy/xydemo/arguments/arguments_test_page.dart';

class RoutePathConst {
  static var routePaths = <String, Widget Function(BuildContext context)>{
    RouteConst.routeTest: (context) =>  ArgumentsTestPage(),
    RouteConst.routeNext: (context) => ArgumentsNextPage(),
  };
}
