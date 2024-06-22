import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CircularImageList extends StatefulWidget {
  final List<String> imageUrls;
  final int maxDisplayCount;
  final double overlapRatio;
  final double height;
  final Duration animDuration;
  final Duration delayedDuration;

  const CircularImageList({
    super.key,
    required this.imageUrls,
    required this.maxDisplayCount,
    required this.overlapRatio,
    required this.height,
    this.animDuration = const Duration(milliseconds: 500),
    this.delayedDuration = const Duration(seconds: 1),
  });

  @override
  CircularImageListState createState() => CircularImageListState();
}

class CircularImageListState extends State<CircularImageList>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  List<String> _currentImages = [];
  late AnimationController _animationController;
  late Animation<double> _animation;

  int get maxDisplayCount {
    return widget.maxDisplayCount + 1;
  }

  double get circularImageWidth {
    var realCount = maxDisplayCount - 1;
    return realCount * widget.height -
        widget.height * (1 - widget.overlapRatio) * (realCount - 1);
  }

  @override
  void initState() {
    super.initState();
    _currentImages = widget.imageUrls.take(maxDisplayCount).toList();
    _animationController = AnimationController(
      duration: widget.animDuration,
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _currentIndex = (_currentIndex + 1) % widget.imageUrls.length;
            _currentImages.removeAt(0);
            _currentImages.add(widget.imageUrls[_currentIndex]);
          });
          _animationController.reset();
          Future.delayed(widget.delayedDuration, () {
            _animationController.forward();
          });
        }
      });

    Future.delayed(widget.delayedDuration, () {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.none,
      width: circularImageWidth,
      height: widget.height,
      child: Stack(
        clipBehavior: Clip.none,
        children: _buildImageStack(),
      ),
    );
  }

  double _opacity(int index) {
    if (index == 0) {
      return 1 - _animation.value;
    } else if (index == _currentImages.length - 1) {
      return _animation.value;
    } else {
      return 1;
    }
  }

  List<Widget> _buildImageStack() {
    List<Widget> stackChildren = [];
    for (int i = 0; i < _currentImages.length; i++) {
      double leftOffset = i * (widget.height * widget.overlapRatio);
      stackChildren.add(
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Positioned(
              left: leftOffset -
                  (_animation.value * widget.height * widget.overlapRatio),
              child: Opacity(
                opacity: _opacity(i),
                child: child!,
              ),
            );
          },
          child: ClipOval(
            key: ValueKey<String>(_currentImages[i]),
            child: CachedNetworkImage(
              imageUrl: _currentImages[i],
              width: widget.height,
              height: widget.height,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }
    return stackChildren;
  }
}
