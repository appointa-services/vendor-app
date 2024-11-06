import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:salon_user/app/utils/all_dependency.dart';

import '../../../data_models/vendor_data_models.dart';

class CheckoutScreen extends GetView<VendorNBookingController> {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    VendorNBookingController controller = Get.find();
    InputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: AppColor.primaryColor,
        width: 1.4,
      ),
    );
    return CommonAppbar(
      title: AppStrings.bookingCheckout,
      children: [
        Padding(
          padding: const EdgeInsets.all(p16),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColor.primaryLightColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        widget(
                          Icons.calendar_month,
                          DateFormat("MMMM, dd yyyy")
                              .format(controller.selectedDate!),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: widget(
                            Icons.access_time_rounded,
                            "${controller.selectedTime} (${controller.duration} min duration)",
                          ),
                        ),
                        GestureDetector(
                          onTap: () => MapsLauncher.launchCoordinates(
                            controller
                                    .vendorData.value?.businessData?.latitude ??
                                22.75481,
                            controller.vendorData.value?.businessData
                                    ?.longitude ??
                                73.511554,
                            controller
                                .vendorData.value?.businessData?.businessName,
                          ),
                          child: widget(
                            Icons.location_on_rounded,
                            controller.vendorData.value?.businessData
                                    ?.businessAddress ??
                                "",
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Divider(height: 0),
                  ),
                  const S14Text(
                    AppStrings.services,
                    fontWeight: FontWeight.w600,
                  ),
                  ...List.generate(
                    controller.selectedService.length,
                    (index) {
                      ServiceModel data = controller.serviceList.firstWhere(
                          (e) => e.id == controller.selectedService[index]);
                      return rowText(
                        "${data.serviceName} (${data.serviceTime} min)",
                        controller.getEmployeeRate(data),
                      );
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
                    child: DottedLine(
                      dashColor: AppColor.grey40,
                    ),
                  ),
                  rowText(
                    AppStrings.subTotal,
                    controller.finalPrice.toString(),
                  ),
                  Obx(
                    () => rowText(
                      AppStrings.discount,
                      controller.couponCode.value.isEmpty ? "0" : "10%",
                      minus: "-",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: TextField(
                      controller: controller.coupon,
                      cursorColor: AppColor.primaryColor,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 10,
                        ),
                        hintText: "Enter discount code",
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          color: AppColor.grey60,
                        ),
                        suffixIcon: TextButton(
                          onPressed: () {
                            if (controller.coupon.text.isNotEmpty) {
                              if (controller.coupon.text == "Appointa") {
                                controller.couponCode.value = "Appointa";
                                showSnackBar(
                                  "10% Discount applied successfully",
                                  color: AppColor.primaryColor,
                                );
                              } else {
                                controller.couponCode.value = "";
                                showSnackBar("Invalid discount code");
                              }
                            }
                          },
                          isSemanticButton: false,
                          style: const ButtonStyle(
                            overlayColor: WidgetStateColor.transparent,
                          ),
                          child: const S14Text(
                            "Apply",
                            color: AppColor.grey100,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: AppColor.grey60,
                            width: 1,
                          ),
                        ),
                        fillColor: AppColor.white,
                        focusedBorder: border,
                      ),
                    ),
                  ),
                  15.vertical(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RotatedBox(
                        quarterTurns: 2,
                        child: SvgPicture.asset(AppAssets.halfCircle),
                      ),
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: DottedLine(
                            dashColor: AppColor.grey60,
                          ),
                        ),
                      ),
                      SvgPicture.asset(AppAssets.halfCircle),
                    ],
                  ),
                  Obx(
                    () => rowText(
                      AppStrings.total,
                      controller.couponCode.value.isEmpty
                          ? controller.finalPrice.toString()
                          : "${(controller.finalPrice * 0.9).toInt()}",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: CommonBtn(
            text: AppStrings.payNow,
            onTap: () => controller.addBooking(),
          ),
        ),
      ],
    );
  }

  Widget widget(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColor.grey80,
          size: 18,
        ),
        5.horizontal(),
        Expanded(
          child: S14Text(
            text,
            color: AppColor.primaryColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget rowText(String title, String money, {String? minus = ""}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          S14Text(
            title,
            color: AppColor.grey100,
            fontWeight: FontWeight.w700,
          ),
          S14Text(
            "$minus₹$money",
            color: AppColor.primaryColor,
            fontWeight: FontWeight.w700,
          ),
        ],
      ),
    );
  }
}
