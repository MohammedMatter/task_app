import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CircleAvatarStyle extends StatelessWidget {
  bool? isSelected;
  Color? color;
  double? radius;
  VoidCallback? method;
  ImageProvider? bgImage;
  CircleAvatarStyle({
    this.bgImage,
    required this.radius,
    this.method,
    required this.isSelected,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: method,
      child: SizedBox(
        child: CircleAvatar(
          backgroundImage: bgImage,
          radius: radius,
          backgroundColor: color,
          child: isSelected!
              ? const Icon(
                  Icons.done,
                  color: Colors.white,
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
