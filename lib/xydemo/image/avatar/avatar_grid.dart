import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AvatarGroup extends StatelessWidget {
  final List<String> imageUrls;
  final double size;
  final double space;
  final Color color;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;

  const AvatarGroup({
    Key? key,
    required this.imageUrls,
    this.size = 150.0,
    this.space = 4.0,
    this.color = Colors.grey,
    this.borderWidth = 3.0,
    this.borderColor = Colors.grey,
    this.borderRadius = 4.0,
  }) : super(key: key);

  double get width {
    return size - borderWidth * 2;
  }

  int get itemCount {
    return imageUrls.length;
  }

  double get itemWidth {
    if (itemCount == 1) {
      return width;
    } else if (itemCount >= 2 && itemCount <= 4) {
      return (width - space) / 2;
    } else {
      return (width - 2 * space) / 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: borderColor, width: borderWidth),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      width: size,
      height: size,
      child: Stack(
        children: _buildAvatarStack(),
      ),
    );
  }

  List<Widget> _buildAvatarStack() {
    List<Widget> avatars = [];
    for (int i = 0; i < imageUrls.length; i++) {
      double left = 0;
      double top = 0;
      if (itemCount == 1) {
        left = 0;
        top = 0;
      } else if (itemCount == 2) {
        left = i * itemWidth + i * space;
        top = (width - itemWidth) / 2;
      } else if (itemCount == 3) {
        if (i == 0) {
          left = (width - itemWidth) / 2;
          top = 0;
        } else {
          left = (i - 1) * itemWidth + (i - 1) * space;
          top = itemWidth + space;
        }
      } else if (itemCount == 4) {
        if (i == 0 || i == 1) {
          left = i * itemWidth + i * space;
          top = 0;
        } else {
          left = (i - 2) * itemWidth + (i - 2) * space;
          top = itemWidth + space;
        }
      } else if (itemCount == 5) {
        if (i == 0 || i == 1) {
          left =
              (width - itemWidth * 2 - space) / 2 + i * itemWidth + i * space;
          top = (width - itemWidth * 2 - space) / 2;
        } else {
          left = (i - 2) * itemWidth + (i - 2) * space;
          top = (width - itemWidth * 2 - space) / 2 + itemWidth + space;
        }
      } else if (itemCount == 6) {
        var topOffset = (width - 2 * itemWidth - space) / 2;
        left = (i % 3) * itemWidth + (i % 3) * space;
        top = topOffset + (i / 3).floor() * itemWidth + (i / 3).floor() * space;
      } else if (itemCount == 7) {
        if (i == 0) {
          left = (width - itemWidth) / 2;
          top = 0;
        } else {
          left = ((i - 1) % 3) * itemWidth + ((i - 1) % 3) * space;
          top = itemWidth +
              space +
              ((i - 1) / 3).floor() * itemWidth +
              ((i - 1) / 3).floor() * space;
        }
      } else if (itemCount == 8) {
        if (i == 0 || i == 1) {
          left =
              (width - itemWidth * 2 - space) / 2 + i * itemWidth + i * space;
          top = 0;
        } else {
          left = ((i - 2) % 3) * itemWidth + ((i - 2) % 3) * space;
          top = itemWidth +
              space +
              ((i - 2) / 3).floor() * itemWidth +
              ((i - 2) / 3).floor() * space;
        }
      } else if (itemCount == 9) {
        left = (i % 3) * itemWidth + (i % 3) * space;
        top = (i / 3).floor() * itemWidth + (i / 3).floor() * space;
      }

      avatars.add(Positioned(
        left: left,
        top: top,
        child: ClipRect(
          child: CachedNetworkImage(
            imageUrl: imageUrls[i],
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            width: itemWidth,
            height: itemWidth,
            fit: BoxFit.cover,
          ),
        ),
      ));
    }

    return avatars;
  }
}