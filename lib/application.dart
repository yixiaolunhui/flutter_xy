import 'package:flutter/cupertino.dart';
import 'package:flutter_xy/utils/system_bar_utils.dart';
import 'package:flutter_xy/xydemo/lifecycle/core/page_state.dart';

class App {
  static App? _instance;

  App._();

  late BuildContext context;

  static App get() {
    _instance ??= App._();
    return _instance!;
  }

  void onCreate() {
    StatusBarUtil.setBarStatus(false);
    RouteHistoryObserver.init();
  }
}
