import 'package:flutter/material.dart';
import 'package:flutter_xy/widgets/xy_app_bar.dart';
import 'package:flutter_xy/xydemo/flow/tag_flow_view.dart';

class TagFlowPage extends StatelessWidget {
  const TagFlowPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: XYAppBar(
            title: '折叠标签',
            onBack: () {
              Navigator.pop(context);
            }),
        body: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TagFlowWidget(
                  items: const [
                    '衣服',
                    'T恤宽松男',
                    '男鞋',
                    '香蕉苹果',
                    '休闲裤',
                    '牛仔裤',
                    '红薯',
                    '红薯',
                    '红薯',
                    '红薯',
                    '西红柿',
                    '更多商品',
                    '热销商品',
                    '最新商品',
                    '特价商品',
                    '限时特价商品',
                    '限时商品',
                    '热门商品',
                  ],
                  maxRows: 3,
                  spaceHorizontal: 8,
                  spaceVertical: 8,
                  itemHeight: 30,
                  horizontalPadding: 8,
                  itemBgColor: Colors.lightBlue.withAlpha(30),
                  itemStyle: const TextStyle(height: 1.1),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
              ],
            )),
      ),
    );
  }
}
