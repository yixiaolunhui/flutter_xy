import 'package:flutter/material.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}

abstract class PageState<T extends StatefulWidget> extends BaseState<T>
    with PageResumeMixin {
  int pageInitStartTime = 0;
  int pageInitFinishTime = 0;

  static final List<BuildContext> contextHistory = [];

  PageState() {
    pageInitStartTime = DateTime.now().millisecondsSinceEpoch;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addToContextHistory();
      pageInitFinishTime = DateTime.now().millisecondsSinceEpoch;
      var initTime = pageInitFinishTime - pageInitStartTime;
      print("route=${RouteHistoryObserver.topRouteName} time=$initTime");
    });
  }

  @override
  void dispose() {
    _removeFromContextHistory();
    super.dispose();
  }

  void _addToContextHistory() {
    if (!mounted) return;
    if (contextHistory.contains(context)) return;
    contextHistory.add(context);
  }

  void _removeFromContextHistory() {
    if (contextHistory.isEmpty) return;
    contextHistory.removeWhere((element) => element == context);
  }
}

class RouteHistoryObserver with WidgetsBindingObserver {
  static bool _initialized = false;

  static Route? _currTopRoute;
  static String? _currTopRouteName;
  static final Map<Route, Set<VoidCallback>> _resumeCallbacks = {};
  static final Map<Route, Set<VoidCallback>> _pauseCallbacks = {};

  static Route<dynamic>? get topRoute => _currTopRoute;

  static String? get topRouteName => _currTopRouteName;

  static void init() {
    if (_initialized) {
      return;
    }
    _initialized = true;
    (NavigationHistoryObserver().historyChangeStream)
        .listen(_onRouteHistoryChange);
    WidgetsBinding.instance.addObserver(RouteHistoryObserver());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _onEngineResume();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        _onEnginePause();
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  static void _onRouteHistoryChange(dynamic historyChange) {
    if (NavigationHistoryObserver().history.isEmpty) return;
    var topRoute = NavigationHistoryObserver().top;
    // push页面时候 pause上一个页面
    if (historyChange.action == NavigationStackAction.push) {
      var preRoute = (historyChange as HistoryChange).oldRoute;
      var callbackList = _pauseCallbacks[preRoute];
      if (callbackList != null) {
        for (var callback in callbackList) {
          callback.call();
        }
      }
    }
    if (topRoute == _currTopRoute) {
      return;
    }
    _currTopRoute = topRoute;
    _currTopRouteName = Uri.parse(_currTopRoute?.settings.name ?? "").path;
    var callbackList = _resumeCallbacks[topRoute];
    if (callbackList == null) {
      return;
    }
    for (var callback in callbackList) {
      callback.call();
    }
  }

  static void addResumeCallback(Route route, VoidCallback callback) {
    var callbackList = _resumeCallbacks[route];
    if (callbackList == null) {
      callbackList = {};
      _resumeCallbacks[route] = callbackList;
    }
    if (callbackList.add(callback) && _currTopRoute == route) {
      callback.call();
    }
  }

  static void removeResumeCallback(Route route, VoidCallback callback) {
    var callbackList = _resumeCallbacks[route];
    if (callbackList == null) {
      return;
    }
    callbackList.remove(callback);
  }

  static void addPauseCallback(Route route, VoidCallback callback) {
    var callbackList = _pauseCallbacks[route];
    if (callbackList == null) {
      callbackList = {};
      _pauseCallbacks[route] = callbackList;
    }
    callbackList.add(callback);
  }

  static void removePauseCallback(Route route, VoidCallback callback) {
    var callbackList = _pauseCallbacks[route];
    if (callbackList == null) {
      return;
    }
    callbackList.remove(callback);
  }

  static void _onEngineResume() {
    if (_currTopRoute == null) {
      return;
    }
    var callbackList = _resumeCallbacks[_currTopRoute];
    if (callbackList == null) {
      return;
    }
    for (var callback in callbackList) {
      callback.call();
    }
  }

  static void _onEnginePause() {
    if (_currTopRoute == null) {
      return;
    }
    var callbackList = _pauseCallbacks[_currTopRoute];
    if (callbackList == null) {
      return;
    }
    for (var callback in callbackList) {
      callback.call();
    }
  }
}

mixin PageResumeMixin<T extends StatefulWidget> on State<T> {
  Route? _route;

  @override
  void didChangeDependencies() {
    _route ??= ModalRoute.of(context);
    if (_route != null) {
      RouteHistoryObserver.addResumeCallback(_route!, onResume);
      RouteHistoryObserver.addPauseCallback(_route!, onPause);
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _route ??= ModalRoute.of(context);
    if (_route != null) {
      RouteHistoryObserver.removeResumeCallback(_route!, onResume);
      RouteHistoryObserver.removePauseCallback(_route!, onPause);
    }
    super.dispose();
  }

  bool isTopRoute() => RouteHistoryObserver._currTopRoute == _route;

  void onResume() {}

  void onPause() {}
}
