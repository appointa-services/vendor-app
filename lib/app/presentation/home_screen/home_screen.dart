import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return Scaffold(
      floatingActionButton: GestureDetector(
        onTap: () {
          Get.bottomSheet(
            const AddAppointmentScreen(),
            isDismissible: false,
            isScrollControlled: true,
          );
        },
        child: const DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColor.primaryColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 2,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Icon(
              Icons.add_rounded,
              color: AppColor.white,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                controller.isCalenderOpen = false;
                controller.update();
              },
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(p16),
                    child: GestureDetector(
                      onTap: () {
                        controller.isCalenderOpen = true;
                        controller.update();
                      },
                      child: Row(
                        children: [
                          GetBuilder<HomeController>(
                            builder: (controller) {
                              return S24Text("${controller.headerText} ");
                            },
                          ),
                          const Icon(Icons.keyboard_arrow_down_rounded),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 35,
                    child: GetBuilder<HomeController>(
                      builder: (controller) {
                        return ListView(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          children: List.generate(
                            5,
                            (index) {
                              String text =
                                  index == 0 ? "All" : "Employee $index";
                              bool isSelected = controller.selectedEmp == text;
                              return GestureDetector(
                                onTap: () {
                                  controller.selectedEmp = text;
                                  controller.update();
                                },
                                child: ColoredBox(
                                  color: Colors.transparent,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: index == 0 ? p16 : 8,
                                      right: index == 4 ? p16 : 8,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Column(
                                          children: [
                                            S16Text(
                                              text,
                                              fontWeight: isSelected
                                                  ? FontWeight.w700
                                                  : FontWeight.w600,
                                              color: isSelected
                                                  ? AppColor.grey100
                                                  : AppColor.grey80,
                                            ),
                                            Container(
                                              height: 2,
                                              margin:
                                                  const EdgeInsets.only(top: 3),
                                              width: 10,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: isSelected
                                                    ? AppColor.grey100
                                                    : Colors.transparent,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: GetBuilder<HomeController>(
                      builder: (controller) {
                        return ListView.builder(
                          itemCount: 10,
                          padding: const EdgeInsets.fromLTRB(p16, 0, p16, 60),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                controller.isPymentScreen = false;
                                Get.bottomSheet(
                                  const AppointmentDetailSheet(),
                                  isDismissible: false,
                                  isScrollControlled: true,
                                );
                              },
                              child: ColoredBox(
                                color: Colors.transparent,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 15,
                                    top: 10,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const S14Text(
                                            "12: 45 PM",
                                            fontWeight: FontWeight.w600,
                                            color: AppColor.grey100,
                                          ),
                                          3.vertical(),
                                          const S12Text("30 min"),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 15,
                                        ),
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            color: AppColor.grey100,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: const SizedBox(
                                            height: 30,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const S16Text(
                                              "Client name",
                                              fontWeight: FontWeight.w600,
                                              color: AppColor.grey100,
                                            ),
                                            const S12Text("Beard Shave"),
                                            if (controller.selectedEmp == "All")
                                              const SText(
                                                "Employee name",
                                                size: 10,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            1.vertical(),
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      const CircleAvatar(
                                        backgroundColor: AppColor.grey40,
                                        backgroundImage: AssetImage(
                                          AppAssets.dummyPerson1,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            GetBuilder<HomeController>(
              builder: (controller) {
                return controller.isCalenderOpen
                    ? CalenderWidget(
                        focusedDay: controller.focusedDay,
                        onDateSelect: (date) {
                          controller.focusedDay = date;
                          controller.headerText =
                              isSameDay(DateTime.now(), date)
                                  ? "Today"
                                  : DateFormat("dd MMMM, yyyy").format(date);
                          controller.isCalenderOpen = false;
                          controller.update();
                        },
                      )
                    : const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
