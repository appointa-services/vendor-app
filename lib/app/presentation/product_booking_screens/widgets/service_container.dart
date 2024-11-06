import 'package:salon_user/app/common_widgets/image_network.dart';
import 'package:salon_user/app/common_widgets/img_loader.dart';
import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/data_models/vendor_data_models.dart';

class ServiceContainer extends StatelessWidget {
  final int index;
  final ServiceModel? data;

  const ServiceContainer({
    super.key,
    required this.index,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: GestureDetector(
        onTap: () {
          if (data != null) {
            serviceDetailSheet(index, data: data);
          }
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColor.white,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFD9D9D9).withOpacity(0.25),
                blurRadius: 8,
                spreadRadius: 5,
              )
            ],
          ),
          child: data == null
              ? Row(
                  children: [
                    const LoadingWidget(height: 100, width: 100, rad: 10),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const LoadingWidget(width: 100, rad: 5),
                          Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 10),
                            child: Row(
                              children: [
                                const LoadingWidget(
                                  width: 40,
                                  rad: 4,
                                  height: 12,
                                ),
                                10.horizontal(),
                                const LoadingWidget(
                                  width: 60,
                                  rad: 4,
                                  height: 12,
                                ),
                              ],
                            ),
                          ),
                          const LoadingWidget(width: 150, rad: 4, height: 25),
                        ],
                      ),
                    )
                  ],
                )
              : Row(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                      child: ImageNet(
                        data?.images.first ?? "",
                        width: 100,
                        height: 100,
                        boxFit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            S14Text(
                              data?.serviceName ?? "",
                              color: AppColor.grey100,
                              fontWeight: FontWeight.w700,
                            ),
                            3.vertical(),
                            Row(
                              children: [
                                S14Text(
                                  Get.find<VendorNBookingController>()
                                      .getPriceFromEmployeePrice(data!),
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
                                S12Text(
                                  "${data?.serviceTime ?? ""} min",
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                            5.vertical(),
                            Row(
                              children: [
                                Expanded(
                                  child: S12Text(
                                    data?.aboutService ?? "",
                                    maxLines: 2,
                                  ),
                                ),
                                5.horizontal(),
                                GetBuilder<VendorNBookingController>(
                                  builder: (controller) {
                                    bool isContain = controller.selectedService
                                        .contains(data?.id);
                                    return GestureDetector(
                                      onTap: () =>
                                          controller.selectRemoveService(data!),
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: isContain
                                              ? Colors.transparent
                                              : AppColor.primaryColor,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: isContain
                                                ? AppColor.redColor
                                                : AppColor.primaryColor,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Icon(
                                            isContain
                                                ? Icons.remove
                                                : Icons.add,
                                            color: isContain
                                                ? AppColor.redColor
                                                : AppColor.white,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}

class BookingServiceContainer extends StatelessWidget {
  final int index;
  final ServiceModel data;

  const BookingServiceContainer({
    super.key,
    required this.index,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    VendorNBookingController controller = Get.find();
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: GestureDetector(
        onTap: () => serviceDetailSheet(index, data: data),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ImageNet(
                data.images.first ?? "",
                width: 60,
                height: 60,
                boxFit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    S14Text(
                      data.serviceName,
                      color: AppColor.grey100,
                      fontWeight: FontWeight.w700,
                    ),
                    3.vertical(),
                    Row(
                      children: [
                        S14Text(
                          controller.finalPrice == 0
                              ? controller.getPriceFromEmployeePrice(data)
                              : "${AppStrings.rupee}${controller.getEmployeeRate(data)}",
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
                        S12Text(
                          "${data.serviceTime} min",
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            GetBuilder<VendorNBookingController>(
              builder: (controller) {
                return GestureDetector(
                  onTap: () {
                    controller.selectRemoveService(data);
                    controller
                        .getFinalPrice(controller.selectedSpecialistId.value);
                    if (controller.selectedService.isEmpty) {
                      Get.back();
                    }
                  },
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColor.redColor,
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.remove,
                        color: AppColor.redColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SpecialistWidget extends StatelessWidget {
  final int selectIndex;
  final Function(int index, String id)? onTap;
  final List<StaffModel>? staffList;

  const SpecialistWidget({
    super.key,
    this.selectIndex = -1,
    this.onTap,
    this.staffList,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VendorNBookingController>(
      builder: (controller) {
        return SizedBox(
          height: 110,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: staffList?.length ??
                (controller.isStaffLoad.value
                    ? 5
                    : controller.staffList.length),
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(top: 15, bottom: 5),
            itemBuilder: (context, index) {
              bool isSelect = selectIndex == index;
              StaffModel? staff = controller.isStaffLoad.value
                  ? null
                  : staffList?[index] ?? controller.staffList[index];
              return Padding(
                padding: const EdgeInsets.only(right: 15),
                child: staff == null
                    ? const Column(
                        children: [
                          LoadingWidget(
                            height: 60,
                            width: 60,
                            rad: 60,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: LoadingWidget(width: 60, height: 10),
                          )
                        ],
                      )
                    : GestureDetector(
                        onTap: () {
                          if (onTap != null) {
                            onTap!(index, staff.id!);
                          }
                        },
                        child: Column(
                          children: [
                            DecoratedBox(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(staff.image),
                                  fit: BoxFit.cover,
                                ),
                                border: Border.all(
                                  color: isSelect
                                      ? AppColor.primaryColor
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2),
                                child: CircleAvatar(
                                  backgroundColor: isSelect
                                      ? AppColor.grey20.withOpacity(0.8)
                                      : Colors.transparent,
                                  radius: 30,
                                  child: isSelect
                                      ? const Icon(
                                          Icons.check_rounded,
                                          color: AppColor.primaryColor,
                                        )
                                      : null,
                                ),
                              ),
                            ),
                            8.vertical(),
                            SizedBox(
                              width: 64,
                              child: S14Text(
                                staff.firstName,
                                maxLines: 1,
                                fontWeight: FontWeight.w600,
                                color: AppColor.grey100,
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                      ),
              );
            },
          ),
        );
      },
    );
  }
}
