import 'dart:math' show pi;

import 'package:flutter/material.dart';

import 'loading.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("动画"),
      ),
      body: const Center(child: LoadingView()),
    );
  }
}


