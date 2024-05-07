import 'package:flutter/material.dart';
import 'package:flutter_xy/application.dart';
import 'package:flutter_xy/xydemo/chain/chain.dart';

import 'other_dialog.dart';

///第3个弹窗
class ThreeDialog implements ChainInterceptor {
  @override
  void intercept(ChainHandler chain) {
    showDialog(
      context: App.get().context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('第3个弹出框'),
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
                chain.addChain(OtherDialog(), index: chain.currentIndex);
                chain.proceed();
              },
              child: const Text('添加其他弹出框'),
            ),
          ],
        );
      },
    );
  }
}
