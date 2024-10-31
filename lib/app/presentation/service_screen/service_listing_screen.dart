import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:salon_user/app/utils/all_dependency.dart';

class ServiceListingScreen extends StatefulWidget {
  final bool isSettingScreen;
  const ServiceListingScreen({super.key, this.isSettingScreen = false});

  @override
  State<ServiceListingScreen> createState() => _ServiceListingScreenState();
}

class _ServiceListingScreenState extends State<ServiceListingScreen> {
  ServiceController controller = Get.put(ServiceController(), permanent: true);
  RefreshController refreshController = RefreshController();
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
              onSearch: (search) {},
            ),
            10.vertical(),
            GetBuilder<ServiceController>(
              builder: (controller) {
                return Expanded(
                  child: SmartRefresher(
                    controller: refreshController,
                    onRefresh: () async {
                      await controller.getServiceList();
                      refreshController.refreshCompleted();
                    },
                    child: (controller.serviceList.isEmpty &&
                            !controller.isServiceLoad)
                        ? const Center(
                            child: S14Text("No services found"),
                          )
                        : ListView.builder(
                            itemCount: controller.isServiceLoad
                                ? 10
                                : controller.serviceList.length,
                            padding: const EdgeInsets.only(bottom: 60),
                            itemBuilder: (context, index) {
                              return ServiceWidget(
                                isLoad: controller.isServiceLoad,
                                serviceData: controller.isServiceLoad
                                    ? null
                                    : controller.serviceList[index],
                                onTap: () {
                                  if (widget.isSettingScreen) {
                                    controller.assignData(index);
                                    pushPage(const AddUpdateServiceScreen());
                                  } else {
                                    Get.back(result: true);
                                  }
                                },
                              );
                            },
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
