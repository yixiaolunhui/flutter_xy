import 'package:flutter/material.dart';

import '../../widgets/xy_app_bar.dart';
import 'expandable_text.dart';

class ExpandableTextPage extends StatelessWidget {
  const ExpandableTextPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: XYAppBar(
          title: '折叠Text',
          onBack: () {
            Navigator.pop(context);
          }),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: ExpandableText(
          text: '我是一个测试的数据，我是一个测试的数据，我是一个测试的数据，我是一个测试的数据，我是一个测试的数据，我是一个测试的数据，我是一个测试的数据，我是一个测试的数据',
          maxLines: 2,
          textStyle: TextStyle(color: Colors.black,fontSize: 14),
        ),
      ),
    );
  }
}
