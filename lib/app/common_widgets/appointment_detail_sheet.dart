import 'package:salon_user/app/utils/all_dependency.dart';

class AppointmentDetailSheet extends StatelessWidget {
  const AppointmentDetailSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          color: AppColor.white,
        ),
        child: GetBuilder<HomeController>(
          builder: (controller) {
            return controller.isPymentScreen
                ? const PaymentOptionWidget()
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 32),
                            child: DecoratedBox(
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    p16, p16, p16, 42),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const S14Text(
                                      "Edit",
                                      color: AppColor.white,
                                    ),
                                    const Column(
                                      children: [
                                        S18Text(
                                          "Comfirm",
                                          fontWeight: FontWeight.w600,
                                          color: AppColor.white,
                                        ),
                                        SText(
                                          "Book by user",
                                          size: 10,
                                          color: AppColor.white,
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () => Get.back(),
                                      child: const Icon(
                                        Icons.close_rounded,
                                        color: AppColor.white,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            left: 0,
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              padding: const EdgeInsets.symmetric(
                                horizontal: p16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColor.grey60),
                                borderRadius: BorderRadius.circular(10),
                                color: AppColor.white,
                              ),
                              child: IntrinsicHeight(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const S12Text("Start"),
                                          5.vertical(),
                                          const S16Text(
                                            "12:45 PM",
                                            fontWeight: FontWeight.w700,
                                            color: AppColor.grey100,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const VerticalDivider(
                                      thickness: 2,
                                      color: AppColor.grey40,
                                      width: 25,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const S12Text("Date"),
                                          5.vertical(),
                                          const S16Text(
                                            "Today",
                                            fontWeight: FontWeight.w700,
                                            color: AppColor.grey100,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(p16),
                        child: Column(
                          children: [
                            ClientWidget(onTap: () {}),
                            IntrinsicHeight(
                              child: Row(
                                children: [
                                  const VerticalDivider(
                                    thickness: 2,
                                    width: 0,
                                    color: AppColor.grey40,
                                  ),
                                  15.horizontal(),
                                  const S16Text(
                                    "Employee name",
                                    color: AppColor.grey100,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ],
                              ),
                            ),
                            const Divider(color: AppColor.grey20, height: 25),
                            IntrinsicHeight(
                              child: Row(
                                children: [
                                  const VerticalDivider(
                                    thickness: 2,
                                    width: 0,
                                    color: AppColor.grey40,
                                  ),
                                  15.horizontal(),
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      S16Text(
                                        "Beard Shave",
                                        color: AppColor.grey100,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      S12Text("12:45 PM - 01:15 PM • 30 min")
                                    ],
                                  ),
                                  const Spacer(),
                                  const S16Text(
                                    "${AppStrings.rupee} 150",
                                    fontWeight: FontWeight.w700,
                                    color: AppColor.primaryColor,
                                  )
                                ],
                              ),
                            ),
                            const Divider(color: AppColor.grey20, height: 25),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SText(
                                      "Total",
                                      size: 10,
                                      color: AppColor.grey80,
                                    ),
                                    S16Text(
                                      "${AppStrings.rupee} 150",
                                      fontWeight: FontWeight.w700,
                                      color: AppColor.grey100,
                                    ),
                                  ],
                                )
                              ],
                            ),
                            18.vertical(),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => Get.back(),
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: AppColor.grey80),
                                      borderRadius: BorderRadius.circular(8),
                                      color: AppColor.white,
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Icon(
                                        Icons.delete_outline_rounded,
                                        color: AppColor.grey100,
                                      ),
                                    ),
                                  ),
                                ),
                                12.horizontal(),
                                Expanded(
                                  child: CommonBtn(
                                    text: "Checkout",
                                    borderRad: 10,
                                    onTap: () {
                                      Get.find<HomeController>()
                                          .isPymentScreen = true;
                                      Get.find<HomeController>().update();
                                    },
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }
}
