import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/data_models/vendor_data_models.dart';

class BookServiceScreen extends GetView<VendorNBookingController> {
  const BookServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) => controller.finalPrice = 0,
      child: GetBuilder<VendorNBookingController>(
        builder: (controller) {
          return CommonAppbar(
            onBackTap: () {
              controller.employeeBooking.clear();
              controller.selectedSpecialist.value = -1;
            },
            title: AppStrings.bookService,
            bottomWidget: const BottomBookNowWidget(isServiceList: null),
            padding: const EdgeInsets.all(p16),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const S16Text(
                    AppStrings.yrServiceOrder,
                    fontWeight: FontWeight.w700,
                    color: AppColor.grey100,
                  ),
                  if (!controller.isBookingScreen)
                    GestureDetector(
                      onTap: () {
                        controller.finalPrice = 0;
                        Get.back();
                      },
                      child: const S14Text(
                        AppStrings.addMore,
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 15),
                itemCount: controller.selectedService.length,
                itemBuilder: (context, index) {
                  ServiceModel data = controller.serviceList.firstWhere(
                      (e) => e.id == controller.selectedService[index]);
                  return BookingServiceContainer(index: index, data: data);
                },
              ),
              const S16Text(
                AppStrings.specialist,
                fontWeight: FontWeight.w700,
                color: AppColor.grey100,
              ),
              SpecialistWidget(
                selectIndex: controller.selectedSpecialist.value,
                staffList: controller.staffList
                    .where(
                      (p0) => controller.selectedService.any(
                        (element) => p0.serviceList.any((e) => e == element),
                      ),
                    )
                    .toList(),
                onTap: (index, id) {
                  if (controller.selectedSpecialist.value != index) {
                    controller.selectedSpecialist.value = index;
                    controller.selectedSpecialistId.value = id;
                    controller.getFinalPrice(id);
                    controller.getBooking();
                    controller.timeList.clear();
                    controller.update();
                  }
                },
              ),
              if (controller.dateList.isNotEmpty) 15.vertical(),
              if (controller.dateList.isNotEmpty)
                const S16Text(
                  AppStrings.chooseDate,
                  fontWeight: FontWeight.w700,
                  color: AppColor.grey100,
                ),
              if (controller.dateList.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 22),
                  child: SizedBox(
                    height: 75,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: controller.dateList.length,
                      itemBuilder: (context, index) {
                        DateTime date = controller.dateList[index];
                        return GetBuilder<VendorNBookingController>(
                          builder: (controller) {
                            bool isSelected = controller.selectedDate != null
                                ? controller.selectedDate == date
                                : false;
                            return GestureDetector(
                              onTap: () {
                                controller.getTime(date);
                                controller.selectedDate = date;
                                controller.update();
                              },
                              child: AnimatedContainer(
                                duration: Durations.long1,
                                width: 50,
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: isSelected
                                      ? AppColor.primaryColor
                                      : AppColor.primaryLightColor,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    S12Text(
                                      DateFormat("EEE").format(date),
                                      color: isSelected
                                          ? AppColor.grey40
                                          : AppColor.grey80,
                                    ),
                                    SText(
                                      date.day.toString(),
                                      size: 20,
                                      fontWeight: FontWeight.w700,
                                      color: isSelected
                                          ? AppColor.white
                                          : AppColor.grey100,
                                    ),
                                    S12Text(
                                      DateFormat("MMM").format(date),
                                      color: isSelected
                                          ? AppColor.grey40
                                          : AppColor.grey80,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              if (controller.timeList.isNotEmpty)
                const S16Text(
                  AppStrings.chooseTime,
                  fontWeight: FontWeight.w700,
                  color: AppColor.grey100,
                ),
              if (controller.timeList.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 20),
                  child: SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: controller.timeList.length,
                      itemBuilder: (context, index) {
                        String time = controller.timeList[index];
                        return GetBuilder<VendorNBookingController>(
                          builder: (controller) {
                            bool isSelected = controller.selectedTime == time;
                            return GestureDetector(
                              onTap: () {
                                controller.selectedTime = time;
                                controller.update();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(right: 10),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: isSelected
                                      ? AppColor.primaryLightColor
                                      : AppColor.white,
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColor.primaryColor
                                        : AppColor.grey60,
                                  ),
                                ),
                                child: S14Text(
                                  time,
                                  color: isSelected
                                      ? AppColor.primaryColor
                                      : AppColor.grey100,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
