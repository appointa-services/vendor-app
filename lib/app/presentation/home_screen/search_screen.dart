import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/data_models/user_model.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.find<HomeController>();
    return PopScope(
      onPopInvoked: (didPop) {
        controller
          ..searchController.clear()
          ..searchVendorList.clear()
          ..update();
      },
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.transparent,
                      child: Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 20,
                        color: AppColor.grey100,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: p16,
                  vertical: 10,
                ),
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const S24Text("Venue or Service"),
                      Padding(
                        padding: const EdgeInsets.only(top: p16, bottom: 5),
                        child: CommonTextField(
                          controller: controller.searchController,
                          prefixIcon: AppAssets.search2Ic,
                          hintText: "Search any Venue or Service",
                          isProfileScreen: true,
                          onChange: (value) =>
                              controller.searchVendor(value ?? ""),
                        ),
                      ),
                      if (controller.searchController.text.length > 2)
                        const S18Text(
                          "Near your location",
                          fontWeight: FontWeight.w700,
                        ),
                      if (controller.searchController.text.length > 2 &&
                          controller.searchVendorList.isEmpty)
                        const SizedBox(
                          height: 150,
                          child: Center(
                            child: S18Text(
                              "No search found",
                              color: AppColor.grey60,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.searchVendorList.length,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        itemBuilder: (context, index) {
                          UserModel user = controller.searchVendorList[index];
                          return SearchWidget(index: index, userData: user);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
