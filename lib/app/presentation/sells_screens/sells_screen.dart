import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:salon_user/app/utils/all_dependency.dart';
import '../../common_widgets/image_network.dart';

class SellsScreen extends GetView<SellsController> {
  const SellsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    RefreshController refreshController = RefreshController();
    return Padding(
      padding: EdgeInsets.fromLTRB(
        p16,
        MediaQuery.of(context).padding.top + p16,
        p16,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const S24Text(
            "Sales",
            textAlign: TextAlign.center,
          ),
          15.vertical(),
          Expanded(
            child: Obx(
              () {
                bool isEmployee =
                    controller.selectedType.value == AppStrings.byEmployee;
                return SmartRefresher(
                  controller: refreshController,
                  onRefresh: () async {
                    await Get.find<DashboardController>().getAllData();
                    await Get.find<HomeController>().getBooking();
                    refreshController.refreshCompleted();
                  },
                  child: ListView(
                    padding: EdgeInsets.zero,
                    primary: false,
                    children: [
                      SizedBox(
                        height: 35,
                        child: GetBuilder<SellsController>(
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
                                            controller.selectedTime.value == e,
                                        onTap: () => controller.changeDate(e),
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
                              AppStrings.byEmployee,
                              AppStrings.byService,
                            ]
                                .map(
                                  (e) => Expanded(
                                    child: pageViewBtn(
                                      isType: true,
                                      title: e,
                                      isSelected:
                                          controller.selectedType.value == e,
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
                      ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        padding: const EdgeInsets.only(top: 20),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: isEmployee
                            ? controller.byEmpList.length
                            : controller.bySerList.length,
                        itemBuilder: (context, index) {
                          ByServiceModel? service;
                          ByEmployeeModel? employee;
                          if (isEmployee) {
                            employee = controller.byEmpList[index];
                          } else {
                            service = controller.bySerList[index];
                          }
                          return IntrinsicHeight(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Row(
                                children: [
                                  if (isEmployee)
                                    ClipOval(
                                      child: ImageNet(
                                        employee?.employeeImg ?? "",
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
                                              ? employee?.employeeName ??
                                                  "Staff"
                                              : service?.serviceName ??
                                                  "Service",
                                          fontWeight: FontWeight.w700,
                                        ),
                                        3.vertical(),
                                        if (isEmployee)
                                          DualText(
                                            text1: "Assigned service",
                                            text2:
                                                employee?.assignService ?? "1",
                                          ),
                                        if (isEmployee) 1.5.vertical(),
                                        DualText(
                                          text1: "Total appointment",
                                          text2: employee?.totalAppointment ??
                                              service?.totalAppointment ??
                                              "1",
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SText(
                                        "Total",
                                        size: 10,
                                        color: AppColor.grey80,
                                      ),
                                      S16Text(
                                        "${AppStrings.rupee} "
                                        "${employee?.totalPrice ?? service?.totalPrice ?? ""}",
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
