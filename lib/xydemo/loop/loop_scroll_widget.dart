import 'dart:async';

import 'package:flutter/material.dart';

class LoopScrollWidget extends StatefulWidget {
  final List<List<dynamic>> items;
  final double? rowHeight;
  final Widget Function(BuildContext context, int rowIndex, int index)
      itemBuilder;

  const LoopScrollWidget({
    Key? key,
    this.rowHeight = 50,
    required this.items,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  LoopScrollWidgetState createState() => LoopScrollWidgetState();
}

class LoopScrollWidgetState extends State<LoopScrollWidget> {
  late final List<ScrollController> _scrollControllers;
  late final List<bool> _isScrollingList;
  final double _scrollIncrement = 4.0;
  final Duration _scrollDuration = const Duration(milliseconds: 50);
  Timer? _scrollTimer;

  @override
  void initState() {
    super.initState();
    _scrollControllers =
        List.generate(widget.items.length, (index) => ScrollController());
    _isScrollingList = List.generate(widget.items.length, (index) => false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    for (var controller in _scrollControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(widget.items.length, (rowIndex) {
        return GestureDetector(
          onPanDown: (_) => _isScrollingList[rowIndex] = true,
          onPanEnd: (_) => _isScrollingList[rowIndex] = false,
          onTapUp: (_) => _isScrollingList[rowIndex] = false,
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollEndNotification) {
                _isScrollingList[rowIndex] = false;
              }
              return false;
            },
            child: SizedBox(
              height: widget.rowHeight,
              child: ListView.builder(
                controller: _scrollControllers[rowIndex],
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final position = index % widget.items[rowIndex].length;
                  return Row(
                    children: [widget.itemBuilder(context, rowIndex, position)],
                  );
                },
              ),
            ),
          ),
        );
      }),
    );
  }

  void _startAutoScroll() {
    _scrollTimer?.cancel();
    _scrollTimer = Timer.periodic(_scrollDuration, (timer) {
      for (var i = 0; i < _scrollControllers.length; i++) {
        if (!_isScrollingList[i] && _scrollControllers[i].hasClients) {
          _scrollControllers[i].animateTo(
            _scrollControllers[i].offset + _scrollIncrement,
            duration: _scrollDuration,
            curve: Curves.linear,
          );
        }
      }
    });
  }
}
