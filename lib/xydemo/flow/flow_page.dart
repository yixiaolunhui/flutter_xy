import 'package:flutter/material.dart';
import 'package:flutter_xy/widgets/xy_app_bar.dart';
import 'package:flutter_xy/xydemo/flow/flow_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> items = List.generate(29, (index) => "Item$index");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: XYAppBar(
          title: "Flutter流布局",
          onBack: (){
            Navigator.pop(context);
          },
        ),
        body: FlowWidget(
          maxLines: 2,
          expandBtn: Container(
            height: 40,
            width: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              "展开",
              style: TextStyle(fontSize: 16),
            ),
          ),
          retractBtn: Container(
            height: 40,
            width: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              "收起",
              style: TextStyle(fontSize: 16),
            ),
          ),
          children: items.map((e) {
            return Text(
              e,
              style: const TextStyle(fontSize: 16),
            );
          }).toList(),
        ));
  }
}
