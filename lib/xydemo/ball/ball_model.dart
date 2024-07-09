import 'dart:ui';

/// 球类，表示每个球的基本信息
class Ball {
  final String name;

  Ball({required this.name});
}

/// 配置类，用于管理每个球的状态和行为
class BadgeBallConfig {
  // 加速度
  final Acceleration _acceleration = Acceleration(0, 0);
  // 时间常量，用于计算位移和速度
  final double time = 0.02;
  // 碰撞回调函数
  late Function(Offset) collusionCallback;
  // 大小
  Size size = const Size(100, 100);
  // 速度
  Speed _speed = Speed(0, 0);
  // 当前位置
  late Offset _position;
  // 名称
  late String name;
  // 衰减系数，用于模拟碰撞后的速度衰减
  double oppositeAccelerationCoefficient = 0.7;

  /// 设置球的位置
  void setPosition(Offset offset) {
    _position = offset;
  }

  /// 设置初速度
  void setInitSpeed(Speed speed) {
    _speed = speed;
  }

  /// 碰撞到墙壁时反转速度并衰减
  void setOppositeSpeed(bool x, bool y) {
    if (x) {
      _speed.x = -_speed.x * oppositeAccelerationCoefficient;
      if (_speed.x.abs() < 5) _speed.x = 0; // 阈值判断
    }
    if (y) {
      _speed.y = -_speed.y * oppositeAccelerationCoefficient;
      if (_speed.y.abs() < 5) _speed.y = 0; // 阈值判断
    }
  }

  /// 设置加速度
  void setAcceleration(double x, double y) {
    _acceleration.x = x * oppositeAccelerationCoefficient;
    _acceleration.y = y * oppositeAccelerationCoefficient;
  }

  /// 获取当前速度
  Speed getCurrentSpeed() => _speed;

  /// 获取当前中心位置
  Offset getCurrentCenter() => Offset(
    _position.dx + size.width / 2,
    _position.dy + size.height / 2,
  );

  /// 获取当前位置
  Offset getCurrentPosition() => _position;

  /// 惯性开始，根据加速度启动速度
  void inertiaStart(double x, double y) {
    if (x.abs() > _acceleration.x.abs()) _speed.x += x;
    if (y.abs() > _acceleration.y.abs()) _speed.y += y;
  }

  /// 碰撞后的处理，更新速度和位置，并调用碰撞回调
  void afterCollusion(Offset offset, Speed speed) {
    _speed = Speed(
      speed.x * oppositeAccelerationCoefficient,
      speed.y * oppositeAccelerationCoefficient,
    );
    _position = offset;
    collusionCallback(offset);
  }

  /// 获取当前偏移量，主要变化逻辑在此处理
  Offset getOffset() {
    // 计算位移，考虑加速度和速度的影响
    var offsetX = (_acceleration.x.abs() < 5 && _speed.x.abs() < 3) ? 0.0 : _speed.x * time + (_acceleration.x * time * time) / 2;
    var offsetY = (_acceleration.y.abs() < 5 && _speed.y.abs() < 6) ? 0.0 : _speed.y * time + (_acceleration.y * time * time) / 2;

    // 更新位置
    _position = Offset(_position.dx + offsetX, _position.dy + offsetY);

    // 更新速度
    _speed = Speed(
      _speed.x + _acceleration.x * time,
      _speed.y + _acceleration.y * time,
    );

    return _position;
  }
}

/// 速度类，表示二维平面上的速度
class Speed {
  double x;
  double y;

  Speed(this.x, this.y);
}

/// 加速度类，表示二维平面上的加速度
class Acceleration {
  double x;
  double y;

  Acceleration(this.x, this.y);
}
