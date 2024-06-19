import 'package:flutter/material.dart';
import 'package:flutter_xy/widgets/xy_app_bar.dart';

import 'loop_scroll_widget.dart';

class LoopScrollPage extends StatefulWidget {
  const LoopScrollPage({Key? key}) : super(key: key);

  @override
  State<LoopScrollPage> createState() => _LoopScrollPageState();
}

class _LoopScrollPageState extends State<LoopScrollPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: XYAppBar(
        title: "标签循环滚动控件",
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: Center(
        child: LoopScrollWidget(
          items: productReviews,
          itemBuilder: (BuildContext context, int rowIndex, int index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              child: Text(
                productReviews[rowIndex][index],
                style: const TextStyle(fontSize: 16, height: 1.1),
              ),
            );
          },
        ),
      ),
    );
  }

  final List<List<String>> productReviews = [
    [
      '这件衣服质量很好',
      '喜欢非常满意',
      '性价比很高',
      '做工比较精细',
      '包装精美',
      '物超所值推荐',
      '非常好用',
      '款式非常漂亮',
      '服务周到',
      '物流迅速快',
    ],
    [
      '值得购买',
      '商品品质一流',
      '五星好评',
      '超级棒',
      '价格实惠',
      '收到货完美无缺',
      '非常贴心',
      '购物很满意',
      '推荐购买',
      '产品超出预期',
    ],
  ];
}
