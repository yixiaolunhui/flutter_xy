import 'package:flutter/material.dart';
import 'package:flutter_xy/xydemo/emoji/emoji_anim_widget.dart';

import '../../widgets/xy_app_bar.dart';

class EmojiAnimPage extends StatefulWidget {
  const EmojiAnimPage({super.key});

  @override
  State<EmojiAnimPage> createState() => _EmojiAnimPageState();
}

class _EmojiAnimPageState extends State<EmojiAnimPage> {
  final _emojiKey = GlobalKey<EmojiAnimWidgetState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            appBar: XYAppBar(
                title: "表情雨",
                backgroundColor: Colors.white,
                onBack: () {
                  Navigator.pop(context);
                }),
            body: EmojiAnimWidget(
              key: _emojiKey,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              emojiNum: 80,
            )),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: MaterialButton(
            onPressed: () {
              _emojiKey.currentState?.startEmojiAnim("😒");
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.brown,
              ),
              child: const Text(
                "表情雨",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        )
      ],
    );
  }
}
