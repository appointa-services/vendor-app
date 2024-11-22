import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:salon_user/app/presentation/admin_screens/admin_stats_screen.dart';
import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/data_models/vendor_data_models.dart';

import 'admin_controller.dart';

class AdminHomeScreen extends GetView<AdminController> {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    RefreshController refreshController = RefreshController();
    return Scaffold(
      appBar: AppBar(
        title: const S18Text("Admin"),
        leading: IconBtn(
          onPressed: () => Get.to(const AdminStatsScreen()),
          icon: const Icon(Icons.bar_chart),
        ),
        actions: [
          IconBtn(
            onPressed: () => controller.logout(),
            icon: const Icon(Icons.logout),
          ),
        ],
        centerTitle: true,
      ),
      body: GetBuilder<AdminController>(
        builder: (controller) {
          return SmartRefresher(
            controller: refreshController,
            onRefresh: () {
              refreshController.refreshCompleted();
              controller.getAllData();
            },
            child: ListView(
              padding: const EdgeInsets.all(p16),
              children: [
                const S16Text("Category"),
                SizedBox(
                  height: 95,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    primary: false,
                    padding: const EdgeInsets.only(top: 10),
                    itemCount: controller.categoryList.length + 1,
                    itemBuilder: (context, index) {
                      CategoryModel? data;
                      if (index != controller.categoryList.length) {
                        data = controller.categoryList[index];
                      }
                      return Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: SizedBox(
                          width: 60,
                          child: GestureDetector(
                            onTap: () {},
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: AppColor.primaryLightColor,
                                  radius: 30,
                                  child: data == null
                                      ? const Icon(
                                          Icons.add,
                                          color: AppColor.primaryColor,
                                        )
                                      : Image.network(
                                          data.catImg,
                                          width: 28,
                                        ),
                                ),
                                8.vertical(),
                                S14Text(
                                  data != null ? data.catName : "Add",
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 8),
                  child: S16Text("Total user"),
                ),
                Row(
                  children: [
                    countWidget(
                      "User",
                      controller.userList.length.toString(),
                    ),
                    10.horizontal(),
                    countWidget(
                      "Vendor",
                      controller.vendorList.length.toString(),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 8),
                  child: S16Text("Revenue detail"),
                ),
                if (controller.bookingList.isNotEmpty)
                  Row(
                    children: [
                      countWidget(
                        "Total transaction",
                        controller.bookingList.isEmpty
                            ? "0"
                            : "${AppStrings.rupee}"
                                "${controller.bookingList.where(
                                      (element) =>
                                          element.status ==
                                          AppStrings.completed,
                                    ).map(
                                      (e) => int.parse(e.finalPrice),
                                    ).reduce(
                                      (value, element) => value + element,
                                    )}",
                      ),
                      10.horizontal(),
                      countWidget(
                        "Total profile",
                        "${AppStrings.rupee}100",
                      ),
                    ],
                  ),
                const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 8),
                  child: S16Text("Bookings detail"),
                ),
                Row(
                  children: [
                    countWidget(
                      "Total bookings",
                      controller.bookingList.length.toString(),
                    ),
                    10.horizontal(),
                    countWidget(
                      "Completed bookings",
                      controller.bookingList
                          .where((element) =>
                              element.status == AppStrings.completed)
                          .length
                          .toString(),
                    ),
                  ],
                ),
                10.vertical(),
                Row(
                  children: [
                    countWidget(
                        "Upcoming bookings",
                        controller.bookingList
                            .where((element) =>
                                element.status == AppStrings.cancelled)
                            .length
                            .toString()),
                    10.horizontal(),
                    countWidget(
                        "Canceled bookings",
                        controller.bookingList
                            .where((element) =>
                                element.status == AppStrings.upcoming)
                            .length
                            .toString()),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget countWidget(String title, String count) {
    return Expanded(
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColor.primaryLightColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Column(
            children: [
              S16Text(
                title,
                color: AppColor.grey80,
                fontWeight: FontWeight.w500,
              ),
              4.vertical(),
              S24Text(count),
            ],
          ),
        ),
      ),
    );
  }
}

class IconBtn extends IconButton {
  const IconBtn({
    super.key,
    required super.onPressed,
    required super.icon,
  });
}
