import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/data_models/booking_model.dart';
import '../../common_widgets/image_network.dart';
import 'admin_controller.dart';

class AdminStatsScreen extends GetView<AdminController> {
  const AdminStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    RefreshController refreshController = RefreshController();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: p16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: S24Text("Sales", textAlign: TextAlign.center),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 2, right: 10),
                      child: Icon(Icons.arrow_back_ios),
                    ),
                  ),
                ],
              ),
              15.vertical(),
              Expanded(
                child: Obx(
                  () {
                    bool isEmployee =
                        controller.selectedType.value == AppStrings.byVendor;
                    return SmartRefresher(
                      controller: refreshController,
                      onRefresh: () async {
                        controller.getAllData();
                        refreshController.refreshCompleted();
                      },
                      child: ListView(
                        padding: EdgeInsets.zero,
                        primary: false,
                        children: [
                          SizedBox(
                            height: 35,
                            child: GetBuilder<AdminController>(
                              builder: (controller) {
                                return ListView(
                                  scrollDirection: Axis.horizontal,
                                  padding: EdgeInsets.zero,
                                  children: [
                                    AppStrings.today,
                                    AppStrings.weekly,
                                    AppStrings.monthly,
                                    AppStrings.yearly,
                                    AppStrings.upcoming,
                                  ]
                                      .map((e) => pageViewBtn(
                                            title: e,
                                            isSelected:
                                                controller.selectedTime.value ==
                                                    e,
                                            onTap: () =>
                                                controller.changeDate(e),
                                          ))
                                      .toList(),
                                );
                              },
                            ),
                          ),
                          10.vertical(),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColor.primaryColor),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Row(
                                children: [
                                  AppStrings.byVendor,
                                  AppStrings.byBooking,
                                ]
                                    .map(
                                      (e) => Expanded(
                                        child: pageViewBtn(
                                          isType: true,
                                          title: e,
                                          isSelected:
                                              controller.selectedType.value ==
                                                  e,
                                          onTap: () {
                                            controller.selectedType.value = e;
                                            controller.update();
                                          },
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                          if (isEmployee
                              ? controller.byEmpList.isNotEmpty
                              : controller.getFilterBooking(null).isNotEmpty)
                            ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              padding: const EdgeInsets.only(top: 20),
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: isEmployee
                                  ? controller.byEmpList.length
                                  : controller.getFilterBooking(null).length,
                              itemBuilder: (context, index) {
                                BookingModel? service;
                                ByVendorModel? vendor;
                                if (isEmployee) {
                                  vendor = controller.byEmpList[index];
                                } else {
                                  service =
                                      controller.getFilterBooking(null)[index];
                                }
                                return IntrinsicHeight(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Row(
                                      children: [
                                        if (isEmployee)
                                          ClipOval(
                                            child: ImageNet(
                                              vendor?.employeeImg ?? "",
                                              height: 40,
                                              width: 40,
                                            ),
                                          ),
                                        const VerticalDivider(
                                          thickness: 2,
                                          width: 20,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              S16Text(
                                                isEmployee
                                                    ? vendor?.vendorName ??
                                                        "Staff"
                                                    : service?.userName ??
                                                        "Service",
                                                fontWeight: FontWeight.w700,
                                              ),
                                              3.vertical(),
                                              if (isEmployee) 1.5.vertical(),
                                              DualText(
                                                text1: vendor == null
                                                    ? "Total service"
                                                    : "Total appointment",
                                                text2: vendor
                                                        ?.totalAppointment ??
                                                    service?.serviceList.length
                                                        .toString() ??
                                                    "1",
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const SText(
                                              "Total",
                                              size: 10,
                                              color: AppColor.grey80,
                                            ),
                                            S16Text(
                                              "${AppStrings.rupee} "
                                              "${vendor?.totalPrice ?? service?.finalPrice ?? ""}",
                                              color: AppColor.grey100,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          else
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.7,
                              child: const Center(
                                child: Text("No data found"),
                              ),
                            )
                        ],
                      ),
                    );
                  },
                ),
              ),
              Obx(
                () {
                  return controller.totalRevenue.value == 0
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const S12Text("Total revenue:"),
                              SText(
                                "${AppStrings.rupee} ${controller.totalRevenue.value}",
                                size: 20,
                                fontWeight: FontWeight.w700,
                              )
                            ],
                          ),
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget pageViewBtn({
    required String title,
    required bool isSelected,
    required Function() onTap,
    bool isType = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        alignment: Alignment.center,
        padding:
            EdgeInsets.symmetric(horizontal: 20, vertical: isType ? 10 : 0),
        child: S14Text(
          title,
          textAlign: TextAlign.center,
          color: isSelected ? AppColor.white : AppColor.primaryColor,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
    );
  }
}
