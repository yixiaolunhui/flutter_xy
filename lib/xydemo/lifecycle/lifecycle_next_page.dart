import 'package:flutter/material.dart';
import 'package:flutter_xy/widgets/xy_app_bar.dart';
import 'package:flutter_xy/xydemo/lifecycle/core/page_state.dart';

class LifecycleNextPage extends StatefulWidget {
  const LifecycleNextPage({super.key});

  @override
  State<LifecycleNextPage> createState() => _LifecycleNextPageState();
}

class _LifecycleNextPageState extends PageState<LifecycleNextPage> {
  @override
  void initState() {
    super.initState();
    print("LifecycleNextPage----initState");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: XYAppBar(
        title: "Flutter生命周期第二页",
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: const SafeArea(
        child: Center(
          child: Text(
            "第二页",
            style: TextStyle(fontSize: 30),
          ),
        ),
      ),
    );
  }

  @override
  void onPause() {
    super.onPause();
    print("LifecycleNextPage----onPause");
  }

  @override
  void onResume() {
    super.onResume();
    print("LifecycleNextPage----onResume");
  }

  @override
  void dispose() {
    print("LifecycleNextPage----dispose");
    super.dispose();
  }
}
