import 'package:flutter/material.dart';
import 'package:flutter_xy/widgets/xy_app_bar.dart';
import 'package:flutter_xy/xydemo/darg/drag_bottom_sheet_widget.dart';

class DragBottomSheetPage extends StatefulWidget {
  const DragBottomSheetPage({super.key});

  @override
  State<DragBottomSheetPage> createState() => _DragBottomSheetPageState();
}

class _DragBottomSheetPageState extends State<DragBottomSheetPage> {
  final GlobalKey<DragBottomSheetWidgetState> bottomSheetKey =
      GlobalKey<DragBottomSheetWidgetState>();

  bool isExpand = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.withAlpha(50),
      appBar: XYAppBar(
        title: "底部弹出布局",
        backgroundColor: Colors.transparent,
        titleColor: Colors.white,
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: Stack(
        children: [
          Positioned(
              top: 0,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  InkWell(
                    onTap: () {
                      if (isExpand) {
                        bottomSheetKey.currentState?.hide();
                      } else {
                        bottomSheetKey.currentState?.show();
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width - 60,
                      alignment: Alignment.center,
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        color: Colors.deepPurple,
                      ),
                      child: Text(
                        isExpand ? "收起" : "弹出",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              )),
          Positioned(
            child: DragBottomSheetWidget(
              key: bottomSheetKey,
              onStateChange: (isExpand) {
                setState(() {
                  this.isExpand = isExpand;
                });
              },
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  alignment: Alignment.topLeft,
                  child: Stack(
                    children: [
                      Container(
                        height: 50,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16)),
                          color: Colors.yellow,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(top: 50),
                          child: ListView.builder(
                            itemCount: 500,
                            controller: scrollController,
                            itemBuilder: (context, index) {
                              return index % 2 == 0
                                  ? Container(
                                      height: 100,
                                      width: MediaQuery.of(context).size.width,
                                      color: Colors.red,
                                    )
                                  : Container(
                                      height: 100,
                                      width: MediaQuery.of(context).size.width,
                                      color: Colors.blue,
                                    );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
