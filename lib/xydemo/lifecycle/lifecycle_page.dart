import 'package:flutter/material.dart';
import 'package:flutter_xy/utils/log_utils.dart';
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const LifecycleNextPage();
                    },
                  ));
                },
                child: const Text("跳转"),
              ),
              ElevatedButton(
                onPressed: () {
                  _showDialog(context);
                },
                child: const Text("弹出框"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Dialog Title'),
          content: const Text('This is the content of the dialog.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  void onCreate() {
    super.onCreate();
    logger.d("LifecyclePage----onCreate");
  }

  @override
  void onPause() {
    super.onPause();
    logger.d("LifecyclePage----onPause");
  }

  @override
  void onResume() {
    super.onResume();
    logger.d("LifecyclePage----onResume");
  }

  @override
  void onDestroy() {
    logger.d("LifecyclePage----onDestroy");
    super.onDestroy();
  }
}
