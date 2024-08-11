import 'package:flutter/material.dart';

class CustomDynamicHeightPageView extends StatefulWidget {
  final List<Widget> pages;

  const CustomDynamicHeightPageView({Key? key, required this.pages})
      : super(key: key);

  @override
  CustomDynamicHeightPageViewState createState() =>
      CustomDynamicHeightPageViewState();
}

class CustomDynamicHeightPageViewState
    extends State<CustomDynamicHeightPageView> {
  final PageController _pageController = PageController();
  final List<double> _heights = [250, 400, 250];
  double _currentHeight = 0;

  @override
  void initState() {
    super.initState();
    _currentHeight = _heights[0];
    _pageController.addListener(_updateHeight);
  }

  void _updateHeight() {
    if (_pageController.position.haveDimensions && _heights.isNotEmpty) {
      double page = _pageController.page ?? 0.0;
      int index = page.floor();
      int nextIndex = (index + 1) < _heights.length ? index + 1 : index;
      double percent = page - index;
      double height =
          _heights[index] + (_heights[nextIndex] - _heights[index]) * percent;
      setState(() {
        _currentHeight = height;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: _currentHeight,
      curve: Curves.easeOut,
      child: PageView(
        controller: _pageController,
        children: widget.pages,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: CustomDynamicHeightPageView(
        pages: [
          Container(
              key: GlobalKey(),
              color: Colors.red,
              height: 200,
              child: const Center(child: Text('Page 2'))),
          Container(
              key: GlobalKey(),
              color: Colors.green,
              height: 300,
              child: const Center(child: Text('Page 2'))),
          Container(
              key: GlobalKey(),
              color: Colors.blue,
              height: 250,
              child: const Center(child: Text('Page 3'))),
        ],
      ),
    ),
  ));
}
