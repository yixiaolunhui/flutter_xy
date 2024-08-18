import 'package:flutter/material.dart';
import 'full_animation.dart';

void main() {
  runApp(AnimationExampleApp());
}

class AnimationExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animation Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AnimationPage(),
    );
  }
}

class AnimationPage extends StatelessWidget {
  const AnimationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animation Example'),
      ),
      body: Center(
        child: GestureDetector(
          onLongPress: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => FullAnimation()));
          },
          child: Container(
            width: 200,
            height: 200,
            color: Colors.grey[300],
            child: const Center(child: Text('Long Press Me')),
          ),
        ),
      ),
    );
  }
}
