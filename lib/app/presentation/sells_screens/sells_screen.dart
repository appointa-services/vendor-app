import 'package:salon_user/app/utils/all_dependency.dart';

class SellsScreen extends StatelessWidget {
  const SellsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SellsController());
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
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(
                  height: 35,
                  child: GetBuilder<SellsController>(
                    builder: (controller) {
                      return ListView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.zero,
                        children: [
                          pageViewBtn(
                            title: AppStrings.today,
                            isSelected:
                                controller.selectedTime == AppStrings.today,
                            onTap: () {
                              controller.selectedTime = AppStrings.today;
                              controller.update();
                            },
                          ),
                          pageViewBtn(
                            title: AppStrings.weekly,
                            isSelected:
                                controller.selectedTime == AppStrings.weekly,
                            onTap: () {
                              controller.selectedTime = AppStrings.weekly;
                              controller.update();
                            },
                          ),
                          pageViewBtn(
                            title: AppStrings.monthly,
                            isSelected:
                                controller.selectedTime == AppStrings.monthly,
                            onTap: () {
                              controller.selectedTime = AppStrings.monthly;
                              controller.update();
                            },
                          ),
                          pageViewBtn(
                            title: AppStrings.yearly,
                            isSelected:
                                controller.selectedTime == AppStrings.yearly,
                            onTap: () {
                              controller.selectedTime = AppStrings.yearly;
                              controller.update();
                            },
                          ),
                          pageViewBtn(
                            title: AppStrings.upcoming,
                            isSelected:
                                controller.selectedTime == AppStrings.upcoming,
                            onTap: () {
                              controller.selectedTime = AppStrings.upcoming;
                              controller.update();
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
                10.vertical(),
                GetBuilder<SellsController>(
                  builder: (controller) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColor.primaryColor),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          children: [
                            Expanded(
                              child: pageViewBtn(
                                isType: true,
                                title: AppStrings.byEmployee,
                                isSelected: controller.selectedType ==
                                    AppStrings.byEmployee,
                                onTap: () {
                                  controller.selectedType =
                                      AppStrings.byEmployee;
                                  controller.update();
                                },
                              ),
                            ),
                            Expanded(
                              child: pageViewBtn(
                                isType: true,
                                title: AppStrings.byService,
                                isSelected: controller.selectedType ==
                                    AppStrings.byService,
                                onTap: () {
                                  controller.selectedType =
                                      AppStrings.byService;
                                  controller.update();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                GetBuilder<SellsController>(
                  builder: (controller) {
                    bool isEmployee =
                        controller.selectedType == AppStrings.byEmployee;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return IntrinsicHeight(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Row(
                              children: [
                                if (isEmployee)
                                  const CircleAvatar(
                                    backgroundColor: AppColor.grey20,
                                    backgroundImage:
                                        AssetImage(AppAssets.dummyPerson1),
                                  ),
                                const VerticalDivider(thickness: 2, width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      S16Text(
                                        isEmployee
                                            ? "Employee name"
                                            : "Service name",
                                        fontWeight: FontWeight.w700,
                                      ),
                                      3.vertical(),
                                      if (isEmployee)
                                        const DualText(
                                            text1: "Assigned service",
                                            text2: "5"),
                                      if (isEmployee) 1.5.vertical(),
                                      const DualText(
                                          text1: "Total appointment",
                                          text2: "10"),
                                    ],
                                  ),
                                ),
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SText(
                                      "Total",
                                      size: 10,
                                      color: AppColor.grey80,
                                    ),
                                    S16Text(
                                      "${AppStrings.rupee} 100",
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
                    );
                  },
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                S12Text("Total revenue:"),
                SText(
                  "${AppStrings.rupee} 1000",
                  size: 20,
                  fontWeight: FontWeight.w700,
                )
              ],
            ),
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
