import 'package:salon_user/app/common_widgets/image_network.dart';
import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/data_models/vendor_data_models.dart';

void serviceDetailSheet(int index, {ServiceModel? data}) {
  Get.bottomSheet(
    ServiceDetailSheet(index: index, data: data),
    isScrollControlled: true,
  );
}

class ServiceDetailSheet extends StatelessWidget {
  final int index;
  final ServiceModel? data;

  const ServiceDetailSheet({super.key, required this.index, this.data});

  @override
  Widget build(BuildContext context) {
    VendorNBookingController controller = Get.find<VendorNBookingController>();
    return PopScope(
      onPopInvoked: (didPop) => controller.currentServiceImg.value = 0,
      child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          child: ColoredBox(
            color: AppColor.white,
            child: SingleChildScrollView(
              primary: false,
              child: Column(
                children: [
                  Obx(
                    () {
                      int current = controller.currentServiceImg.value;
                      return Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          CarouselSlider.builder(
                            itemCount: data?.images.length ?? 6,
                            options: CarouselOptions(
                              viewportFraction: 1,
                              aspectRatio: 1.3,
                              onPageChanged: (index, reason) {
                                controller.currentServiceImg.value = index;
                                controller.update();
                              },
                            ),
                            itemBuilder: (context, index, realIndex) {
                              return ImageNet(
                                data?.images[index] ?? "",
                                width: double.infinity,
                                boxFit: BoxFit.cover,
                              );
                            },
                          ),
                          GetBuilder<VendorNBookingController>(
                            builder: (controller) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  data?.images.length ?? 6,
                                  (index) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 2,
                                      vertical: 10,
                                    ),
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: current == index
                                            ? AppColor.orange
                                            : AppColor.white,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 4,
                                          horizontal: current == index ? 12 : 4,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          Positioned(
                            top: 10,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColor.white,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 25,
                                  vertical: 3,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(p16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SText(
                          data?.serviceName ?? "",
                          size: 20,
                          fontWeight: FontWeight.w700,
                        ),
                        5.vertical(),
                        Row(
                          children: [
                            S16Text(
                              "${AppStrings.rupee}${data?.price ?? ""}",
                              color: AppColor.primaryColor,
                              fontWeight: FontWeight.w700,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              child: CircleAvatar(
                                radius: 2,
                                backgroundColor: AppColor.grey40,
                              ),
                            ),
                            S14Text(
                              "${data?.serviceTime} min",
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                        const Divider(height: 35),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 5),
                          child: S16Text(
                            AppStrings.aboutService,
                            fontWeight: FontWeight.w700,
                            color: AppColor.grey100,
                          ),
                        ),
                        ReadMoreText(
                          data?.aboutService ?? "",
                          isExpandable: true,
                          trimLength: 200,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColor.grey80,
                            fontWeight: FontWeight.w500,
                          ),
                          moreStyle: const TextStyle(
                            color: AppColor.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                          lessStyle: const TextStyle(
                            color: AppColor.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        20.vertical(),
                        GetBuilder<VendorNBookingController>(
                          builder: (controller) {
                            bool isContain =
                                controller.selectedService.contains(data?.id);
                            return CommonBtn(
                              text: isContain
                                  ? AppStrings.removeFromBooking
                                  : AppStrings.addToBooking,
                              onTap: () {
                                controller.selectRemoveService(data!);
                                Get.back();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
