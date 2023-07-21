import 'dart:math';

import 'package:flutter/material.dart';

class SoundWaveWidget extends StatefulWidget {
  const SoundWaveWidget({
    Key? key,
    required this.soundLevel,
    this.count = 5,
  }) : super(key: key);

  final ValueNotifier<double> soundLevel;
  final int count;

  @override
  State<StatefulWidget> createState() => _SoundWaveState();
}

class _SoundWaveState extends State<SoundWaveWidget>
    with TickerProviderStateMixin {
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _initAnim();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _buildPaints(),
    );
  }

  void _initAnim() {
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _waveController.repeat();
  }

  List<Widget> _buildPaints() {
    var paints = <Widget>[];
    for (var i = 0; i < widget.count; i++) {
      paints.add(CustomPaint(
        painter: _WavePainter(
          isMain: i == 0,
          soundLevel: widget.soundLevel,
          progress: i.toDouble() / widget.count.toDouble(),
          animation: _waveController,
        ),
        size: const Size(double.infinity, 60),
      ));
    }
    return paints;
  }
}

class _WavePainter extends CustomPainter {
  final ValueNotifier<double> soundLevel;
  final bool isMain;
  final double progress;
  final Animation<double> animation;
  final Paint _wavePaint = Paint();
  final double _frequency = 1.2;
  final double _idleAmplitude = 0.1;
  final double _density = 15.0;

  _WavePainter({
    required this.isMain,
    required this.soundLevel,
    required this.progress,
    required this.animation,
  }) : super(repaint: Listenable.merge([soundLevel, animation])) {
    var opacity = min(1.0, ((1 - progress) / 3.0 * 2.0) + (1.0 / 3.0));
    _wavePaint.shader = LinearGradient(
      colors: [
        Colors.red.withOpacity(isMain ? 1 : opacity),
        Colors.deepPurple.withOpacity(isMain ? 1 : opacity),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ).createShader(Rect.largest);
    _wavePaint.style = PaintingStyle.stroke;
    _wavePaint.strokeWidth = isMain ? 2 : 0;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var amplitude = max(soundLevel.value - 0.4, _idleAmplitude);
    var height = size.height;
    var width = size.width;
    var mid = size.width / 2.0;
    var path = Path()..moveTo(0, height / 2);
    var normedAmplitude = (1.5 * (1 - progress) - 0.5) * amplitude;
    var x = -_density;
    while (x < width + _density * 2) {
      var scaling = -pow(x / mid - 1, 2) + 1;
      var step1 = 2 * pi * (x / width) * _frequency - animation.value * 2 * pi;
      var step2 = sin(step1);
      var step3 = scaling * height * normedAmplitude * step2 * 0.5;
      var y = step3 + (height * 0.5);
      path.lineTo(x, y.toDouble());
      x += _density;
    }
    canvas.drawPath(path, _wavePaint);
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) {
    return false;
  }
}
