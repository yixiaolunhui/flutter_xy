import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_xy/widgets/xy_app_bar.dart';

/*
 * TODO 正则 （待开发）
 */
class RegularPage extends StatefulWidget {
  const RegularPage({Key? key}) : super(key: key);

  @override
  State<RegularPage> createState() => _RegularPageState();
}

class _RegularPageState extends State<RegularPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: XYAppBar(
        title: "正则表达式",
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              inputFormatters: [
                //只允许输入字母（大小写）
                // FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                //只允许输入数字
                // FilteringTextInputFormatter.digitsOnly,
                // 8~20 位同时包含数字和大小写字母，符号仅限 !@＃$％^*()
                // const pattern = /(?![0-9A-Z]+$)(?![0-9a-z]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,20}$/;
                // PasswordInputFormatter(),
              ],
              onChanged: (value) {},
            )
          ],
        ),
      ),
    );
  }
}

/*
 *  自定义TextInputFormatter
 */
class PasswordInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    StringBuffer stringBuffer = StringBuffer();
    return TextEditingValue(
      //当前的文本
      text: stringBuffer.toString(),
      //光标的位置
      selection: TextSelection.collapsed(
        //设置光标的位置在 文本最后
        offset: stringBuffer.toString().length,
      ),
    );
  }
}
