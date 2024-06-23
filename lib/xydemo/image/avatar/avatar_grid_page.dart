import 'package:flutter/material.dart';
import 'package:flutter_xy/xydemo/image/avatar/avatar_grid.dart';

import '../../../widgets/xy_app_bar.dart';

class AvatarGridPage extends StatelessWidget {
  AvatarGridPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: XYAppBar(
        title: "微信群头像",
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: 9,
          itemBuilder: (context, index) {
            return LayoutBuilder(builder: (context, constraints) {
              return AvatarGroup(
                size: constraints.maxWidth,
                color: Colors.grey.withAlpha(50),
                borderColor: Colors.redAccent.withAlpha(80),
                borderWidth: 2,
                imageUrls: List.generate(
                    index + 1, (i) => _imageUrls[i % _imageUrls.length]),
              );
            });
          },
        ),
      ),
    );
  }

  final List<String> _imageUrls = [
    'https://files.mdnice.com/user/34651/0d938792-603e-4945-a1d8-e53e605693d8.jpeg',
    'https://files.mdnice.com/user/34651/a3b1fd72-ef80-4e31-8a33-2a57c4d115ce.jpeg',
    'https://files.mdnice.com/user/34651/06de6046-bf3a-454c-a75b-6beeba78408b.jpeg',
    'https://files.mdnice.com/user/34651/010ac7cb-9aa9-4a4d-93bb-14dc2cc0d994.jpeg',
    'https://files.mdnice.com/user/34651/d88604e3-0dae-46f0-ab3f-d9e016516401.jpeg',
    'https://files.mdnice.com/user/34651/91a53974-7bf7-47ba-a303-40d5fb61e31f.jpeg',
    'https://files.mdnice.com/user/34651/6b7ca51c-65d0-4f35-b5c1-2c17ef494fd8.jpeg',
    'https://files.mdnice.com/user/34651/0fbdd801-66d8-487c-bcdd-9afcaa611541.jpeg',
    'https://files.mdnice.com/user/34651/0fbdd801-66d8-487c-bcdd-9afcaa611541.jpeg',
  ];
}
