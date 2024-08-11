import 'package:flutter/material.dart';
import 'package:flutter_xy/xydemo/vp/height_widget.dart';

class DynamicPageView extends StatefulWidget {
  final List<Widget> pages;
  final void Function(int index, Widget widget)? onPageTap;

  DynamicPageView({
    required this.pages,
    this.onPageTap,
  });

  @override
  _DynamicPageViewState createState() => _DynamicPageViewState();
}

class _DynamicPageViewState extends State<DynamicPageView> {
  final PageController _pageController = PageController();
  double _pageViewHeight = 300.0;
  List<double> _heightList = [];
  var _currentIndex = 0;
  var _nextIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_onPageScroll);
  }

  void _onPageScroll() {
    setState(() {
      //向左滑
      if (_pageController.page! > _currentIndex) {
        _currentIndex = _pageController.page!.floor();
        _nextIndex = _pageController.page!.ceil();
        _pageViewHeight = _heightList[_currentIndex] +
            (_heightList[_nextIndex] - _heightList[_currentIndex]) *
                (_pageController.page! - _currentIndex);
      }
      //向右滑
      else if (_pageController.page! < _currentIndex) {
        _currentIndex = _pageController.page!.ceil();
        _nextIndex = _pageController.page!.floor();
        _pageViewHeight = _heightList[_currentIndex] +
            (_heightList[_nextIndex] - _heightList[_currentIndex]) *
                (_currentIndex - _pageController.page!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.pages.length,
        itemBuilder: (context, index) {
          return widget.pages[index];
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
