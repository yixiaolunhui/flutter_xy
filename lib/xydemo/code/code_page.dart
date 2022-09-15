import 'package:flutter/material.dart';
import 'package:flutter_xy/widgets/xy_app_bar.dart';
import 'package:flutter_xy/xydemo/code/code_widget.dart';

/*
 * 验证码界面
 */
class CodePage extends StatefulWidget {
  const CodePage({Key? key}) : super(key: key);

  @override
  State<CodePage> createState() => _CodePageState();
}

class _CodePageState extends State<CodePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: XYAppBar(
          title: "验证码",
          onBack: () {
            Navigator.pop(context);
          },
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              CodeWidget(
                height: 50,
                style: CodeStyle.form,
                maxLength: 4,
                itemWidth: 50,
              ),
              const SizedBox(
                height: 50,
              ),
              CodeWidget(
                height: 50,
                style: CodeStyle.rectangle,
                maxLength: 4,
                itemWidth: 50,
              ),
              const SizedBox(
                height: 50,
              ),
              CodeWidget(
                height: 50,
                style: CodeStyle.line,
                maxLength: 6,
                itemWidth: 30,
                itemSpace: 20,
              ),
              const SizedBox(
                height: 50,
              ),
              CodeWidget(
                height: 50,
                style: CodeStyle.circle,
                maxLength: 6,
                itemWidth: 30,
              ),
            ],
          ),
        ));
  }
}
