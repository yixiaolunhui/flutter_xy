import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
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
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    SchedulerBinding.instance.addPersistentFrameCallback((timeStamp) {
      _persistentFrameCallbackList.forEach((element) {
        element.call(timeStamp);
      });
    });
  }

  // 持久帧回调数组
  final List<FrameCallback> _persistentFrameCallbackList = [];

  // 添加持久帧回调
  void addPersistentFrameCallback(FrameCallback callback) {
    _persistentFrameCallbackList.add(callback);
  }

  // 删除持久帧回调
  void removePersistentFrameCallback(FrameCallback callback) {
    _persistentFrameCallbackList.remove(callback);
  }
}
