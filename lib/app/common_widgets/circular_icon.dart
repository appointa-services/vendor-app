import 'package:flutter/material.dart';
import 'package:salon_user/app/utils/app_colors.dart';

class CircularIcon extends StatelessWidget {
  final IconData icon;
  final Function() onTap;
  final Color? color;
  final Color? backColor;
  const CircularIcon({
    super.key,
    required this.icon,
    required this.onTap,
    this.color,
    this.backColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: backColor ?? AppColor.white,
        radius: 24,
        child: Icon(
          icon,
          color: color ?? AppColor.primaryColor,
        ),
      ),
    );
  }
}
