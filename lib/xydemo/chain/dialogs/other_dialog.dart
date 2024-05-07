import 'package:flutter/material.dart';
import 'package:flutter_xy/application.dart';
import 'package:flutter_xy/xydemo/chain/chain.dart';

///其他弹窗（用于案例中插入用）
class OtherDialog implements ChainInterceptor {
  @override
  void intercept(ChainHandler chain) {
    showDialog(
      context: App.get().context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('其他弹出框'),
          content: const Text('这个是一个弹出框的内容文案'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                chain.proceed();
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                chain.proceed();
              },
              child: const Text('确认'),
            ),
          ],
        );
      },
    );
  }
}
