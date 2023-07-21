import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_xy/widgets/xy_app_bar.dart';
import 'package:flutter_xy/xydemo/wave/wave_widget.dart';

class WavePage extends StatefulWidget {
  const WavePage({super.key});

  @override
  State<WavePage> createState() => _WavePageState();
}

class _WavePageState extends State<WavePage> {
  late ValueNotifier<double> _soundLevel;
  Timer? volumeTimer;

  @override
  void initState() {
    super.initState();
    _soundLevel = ValueNotifier(0);
    _startVolumeTimer();
  }

  /// 开始声波模拟
  void _startVolumeTimer() {
    _stopVolumeTimer();
    const duration = Duration(milliseconds: 30);
    const tickCount = 100;
    volumeTimer = Timer.periodic(duration, (timer) {
      var progress = 5 / tickCount;
      var value = (sin(progress * 2 * pi) + 1) / 1.5;
      _soundLevel.value = value;
    });
  }

  /// 停止声波模拟
  void _stopVolumeTimer() {
    if (volumeTimer != null) {
      volumeTimer?.cancel();
      volumeTimer = null;
    }
  }

  @override
  void dispose() {
    _stopVolumeTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: XYAppBar(
        title: "声波",
        backgroundColor: Colors.transparent,
        titleColor: Colors.black,
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: Stack(
        children: [
          Positioned.fill(
            left: 0,
            right: 0,
            bottom: 0,
            top: 0,
            child: Center(
              child: SoundWaveWidget(soundLevel: _soundLevel),
            ),
          ),
        ],
      ),
    );
  }
}
