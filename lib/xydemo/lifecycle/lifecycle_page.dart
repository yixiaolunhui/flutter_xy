import 'package:flutter/material.dart';
import 'package:flutter_xy/widgets/xy_app_bar.dart';
import 'package:flutter_xy/xydemo/lifecycle/core/page_state.dart';

import 'lifecycle_next_page.dart';

class LifecyclePage extends StatefulWidget {
  const LifecyclePage({super.key});

  @override
  State<LifecyclePage> createState() => _LifecyclePageState();
}

class _LifecyclePageState extends PageState<LifecyclePage> {
  @override
  void initState() {
    super.initState();
    print("LifecyclePage----initState");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: XYAppBar(
        title: "Flutter生命周期",
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return const LifecycleNextPage();
                },
              ));
            },
            child: const Text("跳转"),
          ),
        ),
      ),
    );
  }

  @override
  void onPause() {
    super.onPause();
    print("LifecyclePage----onPause");
  }

  @override
  void onResume() {
    super.onResume();
    print("LifecyclePage----onResume");
  }

  @override
  void dispose() {
    print("LifecyclePage----dispose");
    super.dispose();
  }
}
