import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/data_models/user_model.dart';

class ClientListingScreen extends StatelessWidget {
  final bool isBack;

  const ClientListingScreen({super.key, this.isBack = false});

  @override
  Widget build(BuildContext context) {
    RefreshController refreshController = RefreshController();
    DashboardController dashboardController = Get.find();
    ClientController controller = Get.put(ClientController());
    return Scaffold(
      floatingActionButton: isBack
          ? null
          : GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.addClientScreen);
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
              mainAxisAlignment:
                  isBack ? MainAxisAlignment.start : MainAxisAlignment.center,
              children: [
                if (isBack)
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Icon(Icons.arrow_back_rounded),
                  ),
                if (isBack) 15.horizontal(),
                S24Text(isBack ? "Select Clients" : "Clients"),
              ],
            ),
            15.vertical(),
            CommonSearchFiled(
              hintText: "Search Client",
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
            Expanded(
              child: SmartRefresher(
                controller: refreshController,
                onRefresh: () {
                  refreshController.refreshCompleted();
                  dashboardController.getUserList();
                },
                child: Obx(
                  () => ListView.builder(
                    itemCount: dashboardController.isUserLoad.value
                        ? 10
                        : controller.isSearch.value
                            ? controller.filterUserList.length
                            : dashboardController.userList.length,
                    padding: const EdgeInsets.only(top: 10),
                    primary: false,
                    itemBuilder: (context, index) {
                      UserModel? user = dashboardController.isUserLoad.value
                          ? null
                          : controller.isSearch.value
                              ? controller.filterUserList[index]
                              : dashboardController.userList[index];
                      return ClientWidget(
                        isLoad: dashboardController.isUserLoad.value,
                        data: user,
                        onTap: () {
                          if (isBack) {
                            Get.back(result: user);
                          } else {
                            controller
                              ..selectedUser = user!
                              ..getBookingByUser();
                            Get.toNamed(AppRoutes.clientDetailScreen);
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
