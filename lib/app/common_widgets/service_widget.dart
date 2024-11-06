import 'package:salon_user/app/common_widgets/img_loader.dart';
import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/data_models/vendor_data_models.dart';
import 'package:shimmer/shimmer.dart';

class ServiceWidget extends StatelessWidget {
  final Function() onTap;
  final bool isSelect;
  final bool isLoad;
  final ServiceModel? serviceData;

  const ServiceWidget({
    super.key,
    required this.onTap,
    this.isSelect = false,
    this.isLoad = false,
    this.serviceData,
  });

  @override
  Widget build(BuildContext context) {
    return isLoad
        ? Shimmer.fromColors(
            baseColor: AppColor.shimmerBaseColor,
            highlightColor: AppColor.shimmerHighlightColor,
            child: child(serviceData),
          )
        : GestureDetector(
            onTap: isSelect ? null : onTap,
            child: child(serviceData),
          );
  }

  Widget child(ServiceModel? serviceData) {
    return ColoredBox(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: isSelect ? 0 : 8),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColor.grey100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const SizedBox(
                  height: 40,
                  width: 2,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (serviceData != null)
                    S16Text(
                      serviceData.serviceName,
                      fontWeight: FontWeight.w600,
                      color: AppColor.grey100,
                    )
                  else
                    const Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: LoadingWidget(),
                    ),
                  if (serviceData != null)
                    S12Text(
                      timeToString(serviceData.serviceTime),
                    )
                  else
                    const LoadingWidget(height: 10, width: 80),
                ],
              ),
            ),
            const Spacer(),
            if (serviceData != null)
              S18Text("${AppStrings.rupee} ${serviceData.price}")
            else
              const LoadingWidget(height: 20, width: 50),
          ],
        ),
      ),
    );
  }
}
