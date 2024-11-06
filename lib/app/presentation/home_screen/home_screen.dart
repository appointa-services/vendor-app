import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:salon_user/app/common_widgets/booking_loader.dart';
import 'package:salon_user/app/common_widgets/img_loader.dart';
import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/data_models/booking_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DashboardController dashboardController = Get.find();
    HomeController controller = Get.put(HomeController());
    RefreshController refreshController = RefreshController();
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
                    child: Obx(
                      () {
                        return dashboardController.isStaffLoad.value &&
                                dashboardController.staffList.isEmpty
                            ? Shimmer.fromColors(
                                baseColor: AppColor.shimmerBaseColor,
                                highlightColor: AppColor.shimmerHighlightColor,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    3,
                                    (index) => Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Column(
                                        children: [
                                          const LoadingWidget(
                                            height: 15,
                                            width: 80,
                                          ),
                                          if (index == 0) 5.vertical(),
                                          if (index == 0)
                                            const LoadingWidget(
                                              height: 5,
                                              width: 20,
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : ListView(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                children: List.generate(
                                  dashboardController.staffList.length + 1,
                                  (index) {
                                    String text = index == 0
                                        ? "All"
                                        : dashboardController
                                            .staffList[index - 1].firstName;
                                    bool isSelected =
                                        controller.selectedEmp.value == text;
                                    return GestureDetector(
                                      onTap: () {
                                        controller.selectedEmp.value = text;
                                        if (index != 0) {
                                          controller.selectedEmpId.value =
                                              dashboardController
                                                      .staffList[index - 1]
                                                      .id ??
                                                  "";
                                        }
                                        controller.getFilterBooking();
                                        controller.update();
                                      },
                                      child: ColoredBox(
                                        color: Colors.transparent,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left: index == 0 ? p16 : 8,
                                            right: index == 4 ? p16 : 8,
                                          ),
                                          child: Column(
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
                                                margin: const EdgeInsets.only(
                                                  top: 3,
                                                ),
                                                width: 10,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    10,
                                                  ),
                                                  color: isSelected
                                                      ? AppColor.grey100
                                                      : Colors.transparent,
                                                ),
                                              )
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
                  Obx(
                    () => Expanded(
                      child: SmartRefresher(
                        controller: refreshController,
                        onRefresh: () {
                          dashboardController.getAllData();
                          refreshController.refreshCompleted();
                        },
                        child: !controller.isBookingLoad.value &&
                                controller.filterBookingList.isEmpty
                            ? const Center(
                                child: S16Text("No booking found"),
                              )
                            : ListView.builder(
                                primary: false,
                                itemCount: controller.isBookingLoad.value
                                    ? 5
                                    : controller.filterBookingList.length,
                                padding:
                                    const EdgeInsets.fromLTRB(p16, 0, p16, 60),
                                itemBuilder: (context, index) {
                                  BookingModel? data =
                                      controller.isBookingLoad.value
                                          ? null
                                          : controller.filterBookingList[index];
                                  return BookingLoader(
                                    isLoad: controller.isBookingLoad.value,
                                    data: data,
                                  );
                                },
                              ),
                      ),
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
                          controller
                            ..focusedDay = date
                            ..headerText = isSameDay(DateTime.now(), date)
                                ? "Today"
                                : DateFormat("dd MMMM, yyyy").format(date)
                            ..isCalenderOpen = false
                            ..getFilterBooking()
                            ..update();
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
