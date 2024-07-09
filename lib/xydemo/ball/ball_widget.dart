import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_xy/application.dart';
import 'package:flutter_xy/xydemo/ball/ball_model.dart';
import 'package:sensors_plus/sensors_plus.dart';

class PhysicsBallWidget extends StatefulWidget {
  final List<Ball> ballList;
  final double height;
  final double width;

  const PhysicsBallWidget({
    required this.ballList,
    required this.width,
    required this.height,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PhysicsBallState();
}

class _PhysicsBallState extends State<PhysicsBallWidget> {
  List<Widget> badgeBallList = [];
  List<ValueKey<BadgeBallConfig>> keyList = [];
  late Size ballSize;

  @override
  void initState() {
    super.initState();
    fillKeyList();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      App.get().addPersistentFrameCallback(travelHitMap);
    });
  }

  @override
  void dispose() {
    App.get().removePersistentFrameCallback(travelHitMap);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    fillWidgetList();
    return Stack(
      children: badgeBallList,
    );
  }

  void fillKeyList() {
    var badgeSize = (widget.width - 20) / 6;
    badgeSize = (badgeSize >= 84.0 || badgeSize <= 0.0 || !badgeSize.isFinite)
        ? 84.0
        : badgeSize;
    var maxCount = ((widget.height - badgeSize) ~/ badgeSize) *
        (widget.width ~/ badgeSize);
    if (widget.ballList.length >= maxCount) {
      badgeSize = 50.0;
    }
    ballSize = Size(badgeSize, badgeSize);
    var initOffsetX = 0.0;
    var initOffsetY = widget.height - badgeSize;
    for (var element in widget.ballList) {
      keyList.add(ValueKey<BadgeBallConfig>(
        BadgeBallConfig()
          ..size = ballSize
          ..name = element.name
          ..setPosition(Offset(initOffsetX, initOffsetY)),
      ));
      initOffsetX += badgeSize;
      if (initOffsetX + badgeSize > widget.width - 20) {
        initOffsetX = 0;
        initOffsetY -= badgeSize;
      }
    }
  }

  void fillWidgetList() {
    badgeBallList.clear();
    for (var e in keyList) {
      badgeBallList.add(
        BallItemWidget(
          key: e,
          limitWidth: widget.width,
          limitHeight: widget.height,
          onTap: () {},
        ),
      );
    }
  }

  void travelHitMap(Duration timeStamp) {
    for (var i = 0; i < keyList.length - 1; i++) {
      for (var j = i + 1; j < keyList.length; j++) {
        hit(keyList[i].value, keyList[j].value);
      }
    }
  }

  void hit(BadgeBallConfig a, BadgeBallConfig b) {
    final distance = a.size.height / 2 + b.size.height / 2;
    final w = b.getCurrentCenter().dx - a.getCurrentCenter().dx;
    final h = b.getCurrentCenter().dy - a.getCurrentCenter().dy;

    if (sqrt(w * w + h * h) <= distance) {
      var aOriginSpeed = a.getCurrentSpeed();
      var bOriginSpeed = b.getCurrentSpeed();
      var aOffset = a.getCurrentPosition();

      var angle = atan2(h, w);
      var sinNum = sin(angle);
      var cosNum = cos(angle);

      var aCenter = [0.0, 0.0];
      var bCenter = coordinateTranslate(w, h, sinNum, cosNum, true);

      var aSpeed = coordinateTranslate(
          aOriginSpeed.x, aOriginSpeed.y, sinNum, cosNum, true);
      var bSpeed = coordinateTranslate(
          bOriginSpeed.x, bOriginSpeed.y, sinNum, cosNum, true);

      var vxTotal = aSpeed[0] - bSpeed[0];
      aSpeed[0] = (2 * 10 * bSpeed[0]) / 20;
      bSpeed[0] = vxTotal + aSpeed[0];

      var overlap = distance - (aCenter[0] - bCenter[0]).abs();
      aCenter[0] -= overlap;
      bCenter[0] += overlap;

      var aRotatePos =
          coordinateTranslate(aCenter[0], aCenter[1], sinNum, cosNum, false);
      var bRotatePos =
          coordinateTranslate(bCenter[0], bCenter[1], sinNum, cosNum, false);

      var bOffsetX = aOffset.dx + bRotatePos[0];
      var bOffsetY = aOffset.dy + bRotatePos[1];
      var aOffsetX = aOffset.dx + aRotatePos[0];
      var aOffsetY = aOffset.dy + aRotatePos[1];

      var aSpeedF =
          coordinateTranslate(aSpeed[0], aSpeed[1], sinNum, cosNum, false);
      var bSpeedF =
          coordinateTranslate(bSpeed[0], bSpeed[1], sinNum, cosNum, false);

      a.afterCollusion(
          Offset(aOffsetX, aOffsetY), Speed(aSpeedF[0], aSpeedF[1]));
      b.afterCollusion(
          Offset(bOffsetX, bOffsetY), Speed(bSpeedF[0], bSpeedF[1]));
    }
  }

  List<double> coordinateTranslate(
      double x, double y, double sin, double cos, bool reverse) {
    return reverse
        ? [x * cos + y * sin, y * cos - x * sin]
        : [x * cos - y * sin, y * cos + x * sin];
  }
}

class BallItemWidget extends StatefulWidget {
  final double limitWidth;
  final double limitHeight;
  final Function onTap;

  const BallItemWidget({
    required this.limitWidth,
    required this.limitHeight,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => BallItemState();
}

class BallItemState extends State<BallItemWidget> {
  final List<StreamSubscription<dynamic>> _streamSubscriptions = [];
  late BadgeBallConfig config;
  Duration sensorInterval = SensorInterval.normalInterval;
  var color = Color.fromARGB(
    255,
    Random().nextInt(256),
    Random().nextInt(256),
    Random().nextInt(256),
  );

  Timer? timer;
  double x = 0;
  double y = 0;

  double limitY = 0;
  double limitX = 0;

  @override
  void initState() {
    super.initState();
    initData();
    // 包含重力的加速度
    _streamSubscriptions.add(
      accelerometerEventStream(samplingPeriod: sensorInterval).listen(
        (AccelerometerEvent event) {
          config.setAcceleration(
            -double.parse(event.x.toStringAsFixed(1)) * 50,
            double.parse(event.y.toStringAsFixed(1)) * 50,
          );
        },
      ),
    );
    // 不包括重力的加速度
    _streamSubscriptions.add(
      userAccelerometerEventStream(samplingPeriod: sensorInterval).listen(
        (UserAccelerometerEvent event) {
          config.inertiaStart(
            double.parse(event.x.toStringAsFixed(1)) * 50,
            -double.parse(event.y.toStringAsFixed(1)) * 20,
          );
        },
      ),
    );
    timer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
      if (!SchedulerBinding.instance.hasScheduledFrame) {
        SchedulerBinding.instance.scheduleFrame();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      App.get().addPersistentFrameCallback(updatePosition);
    });
  }

  @override
  void dispose() {
    super.dispose();
    for (var subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    App.get().removePersistentFrameCallback(updatePosition);
    timer?.cancel();
    timer = null;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      left: x,
      top: y,
      duration: const Duration(milliseconds: 16),
      child: GestureDetector(
        onTap: () {
          widget.onTap.call();
        },
        child: Container(
          width: config.size.width,
          alignment: Alignment.center,
          height: config.size.height,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2.w),
          ),
          child: Text(
            config.name,
            style: TextStyle(fontSize: 16.w, color: Colors.red),
          ),
        ),
      ),
    );
  }

  void initData() {
    limitX = widget.limitWidth;
    limitY = widget.limitHeight;
    config = (widget.key as ValueKey<BadgeBallConfig>).value;
    config.collusionCallback = (offset) {
      setState(() {
        x = offset.dx;
        y = offset.dy;
        config.setPosition(offset);
      });
    };
    x = config.getCurrentPosition().dx;
    y = config.getCurrentPosition().dy;
  }

  void updatePosition(Duration timeStamp) {
    setState(() {
      var tempX = config.getOffset().dx;
      var tempY = config.getOffset().dy;
      // 左边界
      if (tempX < 0) {
        tempX = 0;
        config.setOppositeSpeed(true, false);
      }
      // 右边界
      if (tempX > limitX - config.size.width) {
        tempX = limitX - config.size.width;
        config.setOppositeSpeed(true, false);
      }
      // 上边界
      if (tempY < 0) {
        tempY = 0;
        config.setOppositeSpeed(false, true);
      }
      // 下边界
      if (tempY > limitY - config.size.height) {
        tempY = limitY - config.size.height;
        config.setOppositeSpeed(false, true);
      }
      x = tempX;
      y = tempY;
      config.setPosition(Offset(x, y));
    });
  }
}
