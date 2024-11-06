import 'package:salon_user/app/common_widgets/img_loader.dart';
import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/data_models/user_model.dart';
import 'package:shimmer/shimmer.dart';

import 'image_network.dart';

class ClientWidget extends StatelessWidget {
  final Function() onTap;
  final bool isSelect;
  final bool isLoad;
  final UserModel? data;

  const ClientWidget({
    super.key,
    required this.onTap,
    this.isSelect = false,
    this.isLoad = false,
    this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isLoad)
          Shimmer.fromColors(
            baseColor: AppColor.shimmerBaseColor,
            highlightColor: AppColor.shimmerHighlightColor,
            child: child(),
          )
        else
          child(),
        if (!isSelect) const Divider(color: AppColor.grey20, height: 25),
      ],
    );
  }

  Widget child() {
    return GestureDetector(
      onTap: isLoad
          ? null
          : isSelect
              ? null
              : onTap,
      child: ColoredBox(
        color: Colors.transparent,
        child: Row(
          children: [
            ClipOval(
              child: data == null || data?.image == null
                  ? const CircleAvatar(
                      radius: 25,
                      backgroundColor: AppColor.grey40,
                    )
                  : ImageNet(data!.image ?? "", height: 50, width: 50),
            ),
            15.horizontal(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (data != null)
                    S16Text(
                      data!.name,
                      fontWeight: FontWeight.w600,
                      color: AppColor.grey100,
                    )
                  else
                    const LoadingWidget(height: 12),
                  3.vertical(),
                  if (data != null)
                    S12Text(data!.mobile)
                  else
                    const LoadingWidget(height: 8, width: 50),
                ],
              ),
            ),
            if (isSelect) 8.horizontal(),
            if (isSelect)
              GestureDetector(
                onTap: onTap,
                child: const Icon(
                  Icons.delete,
                  color: AppColor.orange,
                ),
              )
          ],
        ),
      ),
    );
  }
}
