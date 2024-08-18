// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'dart:ui' as ui;
//
// typedef ClickCallBack = void Function(int postion, String url);
//
// class DynamicPageView extends StatefulWidget {
//   final List<String> _urls;
//   final BuildContext _context;
//   final ClickCallBack clickCallBack;
//
//   DynamicPageView(Key key, this._context, this._urls,
//       {this.clickCallBack})
//       : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() {
//     return DynamicPageState();
//   }
// }
//
// class DynamicPageState extends State<DynamicPageView> {
//   var _defaultHeight = 300.0;
//
//   var _currentIndex = 0;
//   var _nextIndex = 0;
//   var _pageViewHeight;
//   var _showIndex = 0;
//
//   List<double> _heightList = List.empty(growable: true);
//   List<Widget> _widgetList = List.empty(growable: true);
//
//   PageController _pageController;
//
//   MediaQueryData queryData;
//
//   @override
//   void initState() {
//     super.initState();
//     queryData = MediaQuery.of(widget._context);
//     _pageViewHeight = _defaultHeight;
//     _heightList = List.generate(widget._urls.length, (index) => _defaultHeight);
//     _pageController = PageController();
//     _pageController.addListener(() {
//       setState(() {
//         //向左滑
//         if (_pageController.page > _currentIndex) {
//           _currentIndex = _pageController.page.floor();
//           _nextIndex = _pageController.page.ceil();
//           /* print(
//               "向左滑--->value = ${_pageController.page}\n current index = $_currentIndex");*/
//           _pageViewHeight = _heightList[_currentIndex] +
//               (_heightList[_nextIndex] - _heightList[_currentIndex]) *
//                   (_pageController.page - _currentIndex);
//         }
//         //向右滑
//         else if (_pageController.page < _currentIndex) {
//           _currentIndex = _pageController.page.ceil();
//           _nextIndex = _pageController.page.floor();
//           /*print(
//               "向右滑--->value = ${_pageController.page}\n current index = $_currentIndex");*/
//           _pageViewHeight = _heightList[_currentIndex] +
//               (_heightList[_nextIndex] - _heightList[_currentIndex]) *
//                   (_currentIndex - _pageController.page);
//         }
//       });
//     });
//     print(queryData.toString());
//     for (var i = 0; i < widget._urls.length; i++) {
//       _widgetList.add(GestureDetector(
//         child: Image.network(
//           widget._urls[i],
//           fit: BoxFit.fill,
//         ),
//         onTap: () {
//           widget.clickCallBack?.call(i, widget._urls[i]);
//         },
//       ));
//       loadImage(widget._urls[i]).then((value) {
//         _heightList[i] = (value.height.toDouble() /
//                 queryData.devicePixelRatio) *
//             (queryData.size.width / (value.width / queryData.devicePixelRatio));
//         print("第$i张图片的宽度是--->${value.width},高度是--->${value.height}");
//         if (i == 0) {
//           setState(() {
//             _pageViewHeight = _heightList[0];
//           });
//         }
//       });
//     }
//   }
//
//   Future<ui.Image> loadImage(String url) async {
//     ImageStream stream =
//         new NetworkImage(url).resolve(ImageConfiguration.empty);
//     Completer<ui.Image> completer = new Completer<ui.Image>();
//     ImageStreamListener listener;
//     listener = new ImageStreamListener((ImageInfo frame, bool synchronousCall) {
//       final ui.Image image = frame.image;
//       completer.complete(image);
//       stream.removeListener(listener);
//     });
//     stream.addListener(listener);
//     return completer.future;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         width: double.infinity,
//         height: _pageViewHeight,
//         child: Stack(
//           // alignment: Alignment.bottomRight,
//           children: [
//             PageView(
//               onPageChanged: (index) {
//                 setState(() {
//                   _showIndex = index;
//                 });
//               },
//               controller: _pageController,
//               children: _widgetList,
//             ),
//             Positioned(
//               child: ClipRRect(
//                   borderRadius: BorderRadius.all(Radius.circular(15)),
//                   child: Container(
//                     padding: EdgeInsets.fromLTRB(7, 2, 7, 2),
//                     color: Colors.black54,
//                     child: Text(
//                       "${_showIndex + 1}/${_heightList.length}",
//                       style: TextStyle(color: Colors.white, fontSize: 11),
//                     ),
//                   )),
//               right: 15,
//               bottom: 10,
//             ),
//           ],
//         ));
//   }
//
//   void setUrls(List<String> url) {
//     widget._urls.clear();
//     setState(() {
//       widget._urls.addAll(url);
//     });
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _pageController.dispose();
//   }
// }
