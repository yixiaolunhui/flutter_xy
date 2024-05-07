import 'package:flutter/material.dart';
import 'package:flutter_xy/widgets/xy_app_bar.dart';
import 'package:flutter_xy/xydemo/chain/dialogs/four_dialog.dart';
import 'package:flutter_xy/xydemo/chain/dialogs/one_dialog.dart';
import 'package:flutter_xy/xydemo/chain/dialogs/three_dialog.dart';
import 'package:flutter_xy/xydemo/chain/dialogs/two_dialog.dart';

import 'chain.dart';

class ChainDialogPage extends StatefulWidget {
  const ChainDialogPage({super.key});

  @override
  State<ChainDialogPage> createState() => _ChainDialogPageState();
}

class _ChainDialogPageState extends State<ChainDialogPage> {
  var chainHelper = ChainHelper.builder();

  @override
  void initState() {
    super.initState();
  }

  //显示对话框
  void showDialogs() {
    chainHelper.addChain(OneDialog());
    chainHelper.addChain(TwoDialog());
    chainHelper.addChain(ThreeDialog());
    chainHelper.addChain(FourDialog());
    chainHelper.execute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: XYAppBar(
        title: "Flutter弹框链",
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  showDialogs();
                },
                child: const Text("启动弹框链"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
