import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/data_models/user_model.dart';

import '../../common_widgets/image_network.dart';
import '../../common_widgets/img_loader.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ProfileController controller = Get.find();
    return CommonAppbar(
      title: AppStrings.favourite,
      padding: EdgeInsets.zero,
      isRefresher: true,
      onRefresh: () => controller.getFavList(),
      children: [
        Obx(
          () => !controller.isLoad.value && controller.favouriteList.isEmpty
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: const Center(
                    child: S16Text("No data found"),
                  ),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  itemCount: controller.isLoad.value
                      ? 10
                      : controller.favouriteList.length,
                  padding: const EdgeInsets.all(p16),
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.59,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemBuilder: (context, index) {
                    UserModel? userModel;
                    if (!controller.isLoad.value) {
                      userModel = controller.favouriteList[index];
                    }
                    return controller.isLoad.value
                        ? const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LoadingWidget(
                                rad: 10,
                                height: 170,
                                width: double.infinity,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 5),
                                child: LoadingWidget(width: 120, height: 10),
                              ),
                              LoadingWidget(width: 65),
                              Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: LoadingWidget(width: 100, height: 10),
                              ),
                              LoadingWidget(width: 40, height: 12),
                            ],
                          )
                        : GestureDetector(
                            onTap: () => Get.toNamed(AppRoutes.vendorScreen),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: ImageNet(
                                        userModel?.businessData?.logo ?? "",
                                        height: (MediaQuery.sizeOf(context)
                                                    .width /
                                                2) -
                                            24,
                                        width: double.infinity,
                                        boxFit: BoxFit.cover,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Obx(
                                        () => GestureDetector(
                                          onTap: () {
                                            if (!(userModel?.isLoad.value ??
                                                true)) {
                                              controller.removeFav(index);
                                            }
                                          },
                                          child: CircleAvatar(
                                            backgroundColor: AppColor.white,
                                            radius: 15,
                                            child: userModel?.isLoad.value ??
                                                    false
                                                ? const Padding(
                                                    padding:
                                                        EdgeInsets.all(8),
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: AppColor.grey100,
                                                    ),
                                                  )
                                                : const Icon(
                                                    Icons.favorite,
                                                    size: 20,
                                                    color: AppColor.redColor,
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                10.vertical(),
                                S12Text(
                                  listToString(
                                    Get.find<HomeController>().getCatNameList(
                                      userModel?.businessData?.selectedCat ??
                                          [],
                                    ),
                                  ),
                                  color: AppColor.primaryColor,
                                ),
                                S16Text(
                                  userModel?.businessData?.businessName ?? "",
                                  maxLines: 1,
                                  color: AppColor.grey100,
                                  fontWeight: FontWeight.w700,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 5,
                                    bottom: 10,
                                  ),
                                  child: S12Text(
                                    userModel
                                            ?.businessData?.businessAddress ??
                                        "",
                                    maxLines: 2,
                                  ),
                                ),
                                const Row(
                                  children: [
                                    Icon(
                                      Icons.star_rate_rounded,
                                      color: AppColor.orange,
                                      size: 15,
                                    ),
                                    S12Text(
                                      "  0",
                                      color: AppColor.primaryColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    S12Text(
                                      " (0)",
                                      color: AppColor.primaryColor,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                  },
                ),
        ),
      ],
    );
  }
}
