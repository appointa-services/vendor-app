import 'package:cached_network_image/cached_network_image.dart';
import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:shimmer/shimmer.dart';

class ImageNet extends StatelessWidget {
  final String src;
  final double? width;
  final double? shimmerWidth;
  final double? height;
  final double? shimmerHeight;
  final Widget? widget;
  const ImageNet(
    this.src, {
    super.key,
    this.width,
    this.height,
    this.widget,
    this.shimmerWidth,
    this.shimmerHeight,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: src,
      width: width,
      height: height,
      errorWidget: (context, error, stackTrace) =>
          widget ??
          Shimmer.fromColors(
            baseColor: AppColor.shimmerBaseColor,
            highlightColor: AppColor.shimmerHighlightColor,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: SizedBox(
                width: shimmerWidth ?? 45,
                height: shimmerHeight ?? 45,
              ),
            ),
          ),
      progressIndicatorBuilder: (context, child, loadingProgress) =>
          widget ??
          Shimmer.fromColors(
            baseColor: AppColor.shimmerBaseColor,
            highlightColor: AppColor.shimmerHighlightColor,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: SizedBox(
                height: shimmerHeight ?? 50,
                width: shimmerWidth ?? 50,
              ),
            ),
          ),
    );
  }
}
