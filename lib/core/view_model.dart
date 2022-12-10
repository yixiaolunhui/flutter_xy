import 'package:flutter/cupertino.dart';

class ViewModel extends ChangeNotifier {
  bool _dispose = false;

  @override
  void dispose() {
    super.dispose();
    _dispose = true;
  }

  @override
  void notifyListeners() {
    if (!_dispose) {
      super.notifyListeners();
    }
  }

  /*
   * 与系统统一方法刷新UI
   */
  void setState(VoidCallback fn) {
    fn();
    notifyListeners();
  }
}
