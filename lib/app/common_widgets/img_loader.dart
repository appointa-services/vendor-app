import 'package:cached_network_image/cached_network_image.dart';
import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:shimmer/shimmer.dart';

class ImgLoader extends StatelessWidget {
  final String imageUrl;
  final double? borderRad;
  final double? height;
  final double? width;
  final Widget? placeholder;
  final BoxFit? boxFit;

  const ImgLoader({
    super.key,
    required this.imageUrl,
    this.borderRad,
    this.height,
    this.width,
    this.placeholder,
    this.boxFit,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: boxFit,
      height: height ?? 80,
      width: width ?? 80,
      progressIndicatorBuilder: (context, url, progress) {
        return Shimmer.fromColors(
          baseColor: AppColor.shimmerBaseColor,
          highlightColor: AppColor.shimmerHighlightColor,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRad ?? 8),
              color: AppColor.grey100,
            ),
            child: SizedBox(
              height: height ?? 80,
              width: width ?? 80,
            ),
          ),
        );
      },
      errorWidget: (context, url, error) =>
          placeholder ??
          const Icon(
            Icons.image_not_supported_rounded,
          ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final double? rad;
  const LoadingWidget({super.key, this.height, this.width, this.rad});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColor.shimmerBaseColor,
      highlightColor: AppColor.shimmerHighlightColor,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(rad ?? 5),
        child: ColoredBox(
          color: AppColor.grey100,
          child: SizedBox(
            height: height ?? 15,
            width: width ?? 100,
          ),
        ),
      ),
    );
  }
}
