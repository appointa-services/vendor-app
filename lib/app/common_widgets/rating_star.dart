import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class RatingStar extends StatelessWidget {
  final double rating;
  final double? size;

  const RatingStar({super.key, required this.rating, this.size});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        star(index: 1),
        star(index: 2),
        star(index: 3),
        star(index: 4),
        star(index: 5),
      ],
    );
  }

  Widget star({required double index}) {
    return Icon(
      (rating >= index)
          ? Icons.star
          : rating > (index - 1)
              ? Icons.star_half
              : Icons.star_border,
      color: AppColor.orange,
      size: size ?? 15,
    );
  }
}
