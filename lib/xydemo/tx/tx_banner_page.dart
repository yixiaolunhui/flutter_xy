import 'package:flutter/material.dart';
import 'package:flutter_xy/r.dart';
import 'package:flutter_xy/xydemo/tx/tx_banner_widget.dart';

import '../../widgets/xy_app_bar.dart';

class ImageClippingPage extends StatefulWidget {
  const ImageClippingPage({Key? key}) : super(key: key);

  @override
  _ImageClippingPageState createState() => _ImageClippingPageState();
}

class _ImageClippingPageState extends State<ImageClippingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: XYAppBar(
          title: "腾讯视频Banner",
          backgroundColor: Colors.transparent,
          titleColor: Colors.white,
          onBack: () {
            Navigator.pop(context);
          },
        ),
        body: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 32,
              margin: const EdgeInsets.all(16),
              height: 240,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: TxBannerWidget(
                  children: [
                    Image.asset(
                      R.img1_jpg,
                      fit: BoxFit.fill,
                    ),
                    Image.asset(
                      R.img2_jpg,
                      fit: BoxFit.fill,
                    ),
                    Image.asset(
                      R.img3_jpg,
                      fit: BoxFit.fill,
                    ),
                    Image.asset(
                      R.img4_jpg,
                      fit: BoxFit.fill,
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
