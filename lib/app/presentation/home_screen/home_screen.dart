import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:salon_user/app/common_widgets/image_network.dart';
import 'package:salon_user/app/common_widgets/img_loader.dart';
import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/data_models/user_model.dart';
import 'package:salon_user/data_models/vendor_data_models.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.put(HomeController(), permanent: true);
    RefreshController refreshController = RefreshController();
    return SafeArea(
      child: Obx(
        () {
          return SmartRefresher(
            controller: refreshController,
            onRefresh: () {
              refreshController.refreshCompleted();
              controller.getVendorList();
              controller.getCategoryData();
            },
            child: ListView(
              padding: const EdgeInsets.all(p16),
              children: [
                Row(
                  children: [
                    GetBuilder<HomeController>(
                      builder: (controller) {
                        return Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              S24Text("Hello, ${controller.user?.name}"),
                              const S14Text(AppStrings.findTheService),
                            ],
                          ),
                        );
                      },
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.profileScreen),
                      child: CircleAvatar(
                        backgroundColor: AppColor.primaryColor,
                        child: SvgPicture.asset(
                          AppAssets.personIc,
                          // ignore: deprecated_member_use
                          color: AppColor.white,
                        ),
                      ),
                    ),
                  ],
                ),
                20.vertical(),
                CarouselSlider.builder(
                  itemCount: 3,
                  options: CarouselOptions(
                    aspectRatio: 2.2,
                    enableInfiniteScroll: true,
                    autoPlay: true,
                    viewportFraction: 0.95,
                    disableCenter: false,
                    padEnds: false,
                  ),
                  itemBuilder: (context, index, realIndex) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColor.primaryLightColor,
                        ),
                        child: const SizedBox(
                          height: 150,
                          width: double.infinity,
                        ),
                      ),
                    );
                  },
                ),
                20.vertical(),
                if (!(controller.vendorList.isEmpty &&
                    !controller.isBusinessLoad.value))
                  ViewAllBtn(
                    onTap: () {
                      if (!controller.isBusinessLoad.value) {
                        controller.filterVendorByCat("all");
                        controller.selectedCatList.clear();
                        controller.selectedCat.value = "";
                        Get.toNamed(AppRoutes.productListingScreen);
                      }
                    },
                    text: AppStrings.featuredSaloon,
                  ),
                if (!(controller.vendorList.isEmpty &&
                    !controller.isBusinessLoad.value))
                  SizedBox(
                    height: 320,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.isBusinessLoad.value
                          ? 3
                          : controller.vendorList.length,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      itemBuilder: (context, index) {
                        if (controller.isBusinessLoad.value) {
                          return const Padding(
                            padding: EdgeInsets.only(right: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LoadingWidget(
                                  rad: 10,
                                  height: 170,
                                  width: 170,
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
                            ),
                          );
                        } else {
                          UserModel userData = controller.vendorList[index];
                          return GestureDetector(
                            onTap: () {
                              controller.selectedIndex = index;
                              Get.toNamed(
                                AppRoutes.vendorScreen,
                                arguments: userData,
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: SizedBox(
                                width: 170,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: ImageNet(
                                            userData.businessData?.logo ?? "",
                                            height: 170,
                                            width: 170,
                                            boxFit: BoxFit.cover,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Obx(
                                            () {
                                              bool isFav = userData
                                                      .businessData?.favouriteList
                                                      .any((element) =>
                                                          element.id ==
                                                          controller.user?.id) ??
                                                  false;
                                              return GestureDetector(
                                                onTap: () {
                                                  if (!userData.isLoad.value) {
                                                    controller
                                                        .addRemoveFav(index);
                                                  }
                                                },
                                                child: CircleAvatar(
                                                  backgroundColor: AppColor.white,
                                                  radius: 15,
                                                  child: userData.isLoad.value
                                                      ? const Padding(
                                                          padding:
                                                              EdgeInsets.all(8),
                                                          child:
                                                              CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                            color:
                                                                AppColor.grey100,
                                                          ),
                                                        )
                                                      : Icon(
                                                          isFav
                                                              ? Icons.favorite
                                                              : Icons
                                                                  .favorite_border,
                                                          color: isFav
                                                              ? AppColor.redColor
                                                              : AppColor.grey100,
                                                          size: 20,
                                                        ),
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                    10.vertical(),
                                    S12Text(
                                      listToString(
                                        controller.getCatNameList(
                                          userData.businessData?.selectedCat ??
                                              [],
                                        ),
                                      ),
                                      color: AppColor.primaryColor,
                                    ),
                                    S16Text(
                                      userData.businessData?.businessName ?? "",
                                      maxLines: 1,
                                      color: AppColor.grey100,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    5.vertical(),
                                    S12Text(
                                      userData.businessData?.businessAddress ??
                                          "",
                                      maxLines: 2,
                                    ),
                                    10.vertical(),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star_rate_rounded,
                                          color: AppColor.orange,
                                          size: 15,
                                        ),
                                        const S12Text(
                                          " 0.0",
                                          color: AppColor.primaryColor,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        S12Text(
                                          " (${userData.businessData?.reviewList?.length ?? 0})",
                                          color: AppColor.primaryColor,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                if (!(controller.categoryList.isEmpty &&
                    !controller.isCatLoader.value))
                  const S16Text(
                    AppStrings.whatDoU,
                    fontWeight: FontWeight.w700,
                    color: AppColor.grey100,
                  ),
                if (!(controller.categoryList.isEmpty &&
                    !controller.isCatLoader.value))
                  GridView.builder(
                    shrinkWrap: true,
                    itemCount: controller.isCatLoader.value
                        ? 2
                        : controller.categoryList.length,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(top: 15, bottom: 5),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.8,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      CategoryModel? catData;
                      if (!controller.isCatLoader.value) {
                        catData = controller.categoryList[index];
                      }
                      return catData == null
                          ? Shimmer.fromColors(
                              baseColor: AppColor.shimmerBaseColor,
                              highlightColor: AppColor.shimmerHighlightColor,
                              child: const ColoredBox(color: AppColor.grey100),
                            )
                          : GestureDetector(
                              onTap: () {
                                controller.selectedCat.value = catData!.catName;
                                controller.selectedCatList.clear();
                                controller.filterVendorByCat(catData.catId);
                                Get.toNamed(AppRoutes.productListingScreen);
                              },
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColor.grey20,
                                ),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Stack(
                                    alignment: Alignment.bottomLeft,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 15),
                                          child: ClipRRect(
                                            borderRadius: const BorderRadius.only(
                                              bottomRight: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                            ),
                                            child: ImageNet(
                                              catData.catImg,
                                              height: 65,
                                              width: 65,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: S14Text(
                                          catData.catName,
                                          fontWeight: FontWeight.w700,
                                          color: AppColor.grey100,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
