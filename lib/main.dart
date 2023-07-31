import 'package:flutter/material.dart';
import 'package:flutter_xy/home.dart';
import 'package:flutter_xy/route/route_path_const.dart';
import 'package:flutter_xy/utils/system_bar_utils.dart';
import 'package:flutter_xy/xydemo/arguments/arguments.dart';

void main() {
  StatusBarUtil.setBarStatus(false);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Android小样',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onGenerateRoute: (settings) {
        var uri = Uri.parse(settings.name ?? "");
        var route = uri.path;
        var params = uri.queryParameters;
        if (!RoutePathConst.routePaths.containsKey(route)) {
          return null;
        }
        return MaterialPageRoute(
          builder: (context) {
            var widgetBuilder = RoutePathConst.routePaths[route];
            var widget = widgetBuilder!(context);
            if (widget is RouteQueryMixin) {
              (widget as RouteQueryMixin).routeParams.addAll(params);
            }
            if (widget is ArgumentsMixin) {
              (widget as ArgumentsMixin).arguments = settings.arguments;
            }
            return widget;
          },
          settings: settings,
        );
      },
      home: HomePage(),
    );
  }
}
