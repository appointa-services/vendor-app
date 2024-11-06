import 'package:salon_user/data_models/booking_model.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/all_dependency.dart';
import 'image_network.dart';
import 'img_loader.dart';

class BookingLoader extends StatelessWidget {
  final bool isLoad;
  final BookingModel? data;

  const BookingLoader({super.key, required this.isLoad, this.data});

  @override
  Widget build(BuildContext context) {
    return isLoad
        ? Shimmer.fromColors(
            baseColor: AppColor.shimmerBaseColor,
            highlightColor: AppColor.shimmerHighlightColor,
            child: child(),
          )
        : child();
  }

  Widget child() {
    HomeController controller = Get.find();
    return GestureDetector(
      onTap: () {
        if (!isLoad && data != null) {
          controller.isPaymentScreen = false;
          Get.bottomSheet(
            AppointmentDetailSheet(data: data!),
            isDismissible: false,
            isScrollControlled: true,
          );
        }
      },
      child: ColoredBox(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: 15,
            top: 10,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (data == null)
                    const LoadingWidget(
                      width: 50,
                      height: 10,
                    )
                  else
                    S14Text(
                      DateFormat("hh:mm a").format(
                        DateTime.fromMillisecondsSinceEpoch(
                          data!.orderDate,
                        ),
                      ),
                      fontWeight: FontWeight.w600,
                      color: AppColor.grey100,
                    ),
                  3.vertical(),
                  if (data == null)
                    const LoadingWidget(
                      width: 30,
                      height: 8,
                    )
                  else
                    S12Text("${data!.duration} min"),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: isLoad && data == null
                        ? AppColor.grey100
                        : statusColor(data!.status),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const SizedBox(height: 30, width: 2),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (data == null)
                      const LoadingWidget(height: 12)
                    else
                      S16Text(
                        data!.userName,
                        fontWeight: FontWeight.w600,
                        color: AppColor.grey100,
                      ),
                    if (data == null)
                      const Padding(
                        padding: EdgeInsets.only(top: 3, bottom: 2),
                        child: LoadingWidget(
                          width: 80,
                          height: 8,
                        ),
                      )
                    else
                      S12Text(
                        listToString(
                            data!.serviceList
                                .map((e) => e.serviceName)
                                .toList(),
                            comaReplacer: " +"),
                        maxLines: 1,
                      ),
                    if (data == null)
                      const LoadingWidget(
                        width: 50,
                        height: 6,
                      )
                    else
                      Obx(
                        () => controller.selectedEmp.value == AppStrings.all
                            ? SText(
                                data!.employeeName,
                                size: 10,
                                fontWeight: FontWeight.w500,
                              )
                            : const SizedBox(),
                      ),
                    1.vertical(),
                  ],
                ),
              ),
              ClipOval(
                child: data == null || data!.userImg.isEmpty
                    ? const CircleAvatar(backgroundColor: AppColor.grey40)
                    : ImageNet(data!.userImg, height: 40, width: 40),
              )
            ],
          ),
        ),
      ),
    );
  }
}
