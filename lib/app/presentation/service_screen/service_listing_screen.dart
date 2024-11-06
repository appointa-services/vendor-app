import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/data_models/vendor_data_models.dart';

class ServiceListingScreen extends StatefulWidget {
  final bool isSettingScreen;

  const ServiceListingScreen({super.key, this.isSettingScreen = false});

  @override
  State<ServiceListingScreen> createState() => _ServiceListingScreenState();
}

class _ServiceListingScreenState extends State<ServiceListingScreen> {
  ServiceController controller = Get.put(ServiceController());
  RefreshController refreshController = RefreshController();
  DashboardController dashboardController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: GestureDetector(
        onTap: () {
          controller.clearData();
          pushPage(const AddUpdateServiceScreen());
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
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          p16,
          MediaQuery.of(context).padding.top + p16,
          p16,
          0,
        ),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(Icons.arrow_back_rounded),
                ),
                15.horizontal(),
                S24Text(widget.isSettingScreen ? "Services" : "Choose Service"),
              ],
            ),
            15.vertical(),
            CommonSearchFiled(
              hintText: "Search Service",
              onSearch: (search) {
                controller
                  ..isSearch.value = true
                  ..filterUser(search);
              },
              onClose: () {
                controller.isSearch.value = false;
              },
            ),
            10.vertical(),
            Obx(
              () => Expanded(
                child: SmartRefresher(
                  controller: refreshController,
                  onRefresh: () async {
                    await dashboardController.getServiceList();
                    refreshController.refreshCompleted();
                  },
                  child: (dashboardController.serviceList.isEmpty &&
                          !dashboardController.isServiceLoad.value)
                      ? const Center(
                          child: S14Text("No services found"),
                        )
                      : ListView.builder(
                          itemCount: dashboardController.isServiceLoad.value
                              ? 10
                              : controller.isSearch.value
                                  ? controller.filterServiceList.length
                                  : dashboardController.serviceList.length,
                          padding: const EdgeInsets.only(bottom: 60),
                          itemBuilder: (context, index) {
                            ServiceModel? data = dashboardController
                                    .isServiceLoad.value
                                ? null
                                : controller.isSearch.value
                                    ? controller.filterServiceList[index]
                                    : dashboardController.serviceList[index];
                            return ServiceWidget(
                              isLoad: dashboardController.isServiceLoad.value,
                              serviceData: data,
                              onTap: () {
                                if (widget.isSettingScreen) {
                                  Get.find<ServiceController>()
                                      .assignData(index);
                                  pushPage(const AddUpdateServiceScreen());
                                } else {
                                  Get.back(result: data);
                                }
                              },
                            );
                          },
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
