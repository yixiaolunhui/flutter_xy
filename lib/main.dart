import 'package:flutter/material.dart';
import 'package:flutter_xy/home.dart';
import 'package:flutter_xy/utils/system_bar_utils.dart';

void main() {
  StatusBarUtil.setBarStatus(false);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Android小样',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}
