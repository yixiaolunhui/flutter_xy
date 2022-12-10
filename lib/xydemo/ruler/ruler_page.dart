import 'package:flutter/material.dart';
import 'package:flutter_xy/core/data_binding_widget.dart';
import 'package:flutter_xy/widgets/xy_app_bar.dart';
import 'package:flutter_xy/xydemo/ruler/ruler_view.dart';
import 'package:flutter_xy/xydemo/ruler/ruler_view_model.dart';

///尺子
class RulerPage extends StatefulWidget {
  const RulerPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return RulerState();
  }
}

class RulerState extends State<RulerPage> {
  RulerViewModel viewModel = RulerViewModel();
  @override
  Widget build(BuildContext context) {
    print("-------------------------------build");
    return Scaffold(
      appBar: XYAppBar(
        title: "尺子",
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            NotifierWidget<RulerViewModel>(
              viewModel: viewModel,
              onInit: (viewModel) {},
              builder: (context, viewModel, child) {
                return Text(
                  "${viewModel.num}",
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                );
              },
            ),
            const SizedBox(height: 30),
            RulerView(
              width: MediaQuery.of(context).size.width.ceil(),
              height: 60,
              value: viewModel.num,
              minValue: 40,
              maxValue: 100,
              step: 2,
              subScaleWidth: 10,
              subScaleCountPerScale: 10,
              scaleColor: Colors.black,
              scaleWidth: 2,
              scaleTextColor: Colors.black,
              scaleTextWidth: 15,
              onSelectedChanged: (result) {
                viewModel.updateNum(result);
              },
            ),
          ],
        ),
      ),
    );
  }
}
