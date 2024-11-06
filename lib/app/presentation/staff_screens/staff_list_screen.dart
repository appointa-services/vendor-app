import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:salon_user/app/common_widgets/img_loader.dart';
import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/data_models/vendor_data_models.dart';
import 'package:shimmer/shimmer.dart';

class StaffListScreen extends StatelessWidget {
  final bool isSelection;

  const StaffListScreen({super.key, this.isSelection = false});

  @override
  Widget build(BuildContext context) {
    StaffController staffController =
        Get.put(StaffController(), permanent: true);
    DashboardController controller = Get.find();
    RefreshController refreshController = RefreshController();
    return CommonAppbar(
      floatingAction: isSelection
          ? null
          : GestureDetector(
              onTap: () {
                staffController.fillData();
                Get.toNamed(AppRoutes.addStaffMember);
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
      title: AppStrings.staffMember,
      padd: const EdgeInsets.all(p16),
      scrollPhysics: const NeverScrollableScrollPhysics(),
      children: [
        CommonSearchFiled(
          hintText: "Search staff member",
          onSearch: (search) {
            staffController
              ..isSearch.value = true
              ..filterUser(search);
          },
          onClose: () {
            staffController.isSearch.value = false;
          },
        ),
        10.vertical(),
        Obx(
          () {
            return Expanded(
              child: SmartRefresher(
                primary: false,
                controller: refreshController,
                onRefresh: () async {
                  await controller.getStaffList();
                  refreshController.refreshCompleted();
                },
                child: controller.staffList.isEmpty &&
                        !controller.isStaffLoad.value
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: const Center(
                          child: S14Text("No staff member found"),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: controller.isStaffLoad.value
                            ? 10
                            : staffController.isSearch.value
                                ? staffController.filterStaffList.length
                                : controller.staffList.length,
                        padding: const EdgeInsets.only(top: 10, bottom: 20),
                        itemBuilder: (context, index) {
                          StaffModel? data;
                          if (!controller.isStaffLoad.value) {
                            data = staffController.isSearch.value
                                ? staffController.filterStaffList[index]
                                : controller.staffList[index];
                          }
                          if (data == null) {
                            return Shimmer.fromColors(
                              baseColor: AppColor.shimmerBaseColor,
                              highlightColor: AppColor.shimmerHighlightColor,
                              child: const Column(
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(),
                                      Padding(
                                        padding: EdgeInsets.only(left: 15),
                                        child: LoadingWidget(),
                                      ),
                                      Spacer(),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: AppColor.primaryColor,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                  Divider(height: 30),
                                ],
                              ),
                            );
                          } else {
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (isSelection) {
                                      Get.back(result: data);
                                    } else {
                                      Get.find<StaffController>().fillData(
                                        data: data,
                                        index: index,
                                      );
                                      Get.toNamed(AppRoutes.addStaffMember);
                                    }
                                  },
                                  child: ColoredBox(
                                    color: Colors.transparent,
                                    child: Row(
                                      children: [
                                        ClipOval(
                                          child: ImgLoader(
                                            imageUrl: data.image,
                                            height: 50,
                                            boxFit: BoxFit.cover,
                                            width: 50,
                                          ),
                                        ),
                                        15.horizontal(),
                                        S16Text(
                                          "${data.firstName} ${data.lastName}",
                                          color: AppColor.grey100,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        const Spacer(),
                                        const Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: AppColor.primaryColor,
                                          size: 18,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Divider(
                                  height: 30,
                                  color: AppColor.grey40,
                                ),
                              ],
                            );
                          }
                        },
                      ),
              ),
            );
          },
        ),
      ],
    );
  }
}
