import 'package:salon_user/app/common_widgets/image_network.dart';
import 'package:salon_user/data_models/user_model.dart';
import 'package:salon_user/data_models/vendor_data_models.dart';

import '../../utils/all_dependency.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  HomeController controller = Get.find();

  @override
  void initState() {
    controller.searchController.clear();
    controller.searchVendorList.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return ListView(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height -
                  (MediaQuery.paddingOf(context).bottom) -
                  50,
              child: Stack(
                children: [
                  GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(lat, lng),
                      zoom: 12,
                    ),
                    markers: controller.markers.value.toSet(),
                    mapToolbarEnabled: false,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    onMapCreated: (GoogleMapController controller) {
                      this.controller.controller.value = controller;
                      this.controller.update();
                    },
                    onLongPress: (argument) => Get.bottomSheet(
                      DecoratedBox(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          color: AppColor.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const S18Text(
                                "Are you sure want to change your location?",
                                fontWeight: FontWeight.w600,
                                textAlign: TextAlign.center,
                              ),
                              15.vertical(),
                              Row(
                                children: [
                                  Expanded(
                                    child: CommonBtn(
                                      text: "Cancel",
                                      borderColor: AppColor.grey20,
                                      btnColor: AppColor.grey20,
                                      textColor: AppColor.grey100,
                                      onTap: () => Get.back(),
                                    ),
                                  ),
                                  10.horizontal(),
                                  Expanded(
                                    child: CommonBtn(
                                      text: "Change",
                                      onTap: () {
                                        Get.back();
                                        controller.getVendorList(
                                          newLat: argument,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          p16,
                          AppBar().preferredSize.height,
                          p16,
                          0,
                        ),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.white,
                            boxShadow: boxShadow(),
                          ),
                          child: TextField(
                            controller: controller.searchController,
                            focusNode: controller.focusNode,
                            onTap: () => controller.update(),
                            onTapOutside: (event) {
                              controller
                                ..focusNode.unfocus()
                                ..update();
                            },
                            onChanged: (value) =>
                                controller.searchVendor(value),
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColor.grey100,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              disabledBorder: InputBorder.none,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintText: "Search bussineses here...",
                              prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: SvgPicture.asset(
                                  AppAssets.location,
                                  height: 24,
                                  width: 24,
                                ),
                              ),
                              suffixIcon: controller.focusNode.hasFocus ||
                                      controller
                                          .searchController.text.isNotEmpty
                                  ? GestureDetector(
                                      onTap: () {
                                        controller.searchVendorList.clear();
                                        controller.search.value = "";
                                        controller
                                          ..focusNode.unfocus()
                                          ..searchController.clear()
                                          ..update();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        child:
                                            SvgPicture.asset(AppAssets.close),
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      if (controller.searchVendorList.isEmpty &&
                          controller.searchController.text.length <= 2)
                        SizedBox(
                          height: 64,
                          child: ListView.builder(
                            itemCount: controller.categoryList.length + 1,
                            padding: const EdgeInsets.all(p16),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              CategoryModel? cat;
                              if (index != 0) {
                                cat = controller.categoryList[index - 1];
                              }
                              bool isSelected = controller.selectedCatList
                                  .contains(cat?.catId ?? "all");

                              return CategoryWidget(
                                onTap: () => controller
                                    .filterVendorByCat(cat?.catId ?? "all"),
                                cat: cat?.catName ?? "All",
                                isSelected: isSelected,
                              );
                            },
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: p16,
                            vertical: 10,
                          ),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColor.white,
                              boxShadow: boxShadow(),
                            ),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.4,
                                minHeight: 0,
                                maxWidth: double.infinity,
                                minWidth: double.infinity,
                              ),
                              child: controller.searchVendorList.isEmpty
                                  ? const Padding(
                                      padding: EdgeInsets.all(40),
                                      child: S16Text(
                                        "No data found",
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  : SingleChildScrollView(
                                      padding: EdgeInsets.zero,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(p16),
                                            child: S16Text(
                                              "Vanue or Service",
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: p16,
                                            ),
                                            itemCount: controller
                                                .searchVendorList.length,
                                            itemBuilder: (context, index) {
                                              UserModel data = controller
                                                  .searchVendorList[index];
                                              return SearchWidget(
                                                index: index,
                                                userData: data,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      if (controller.isBusinessLoad.value)
                        const CircularProgressIndicator(
                          color: AppColor.grey100,
                        ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                controller.filterVendorByCat("all");
                                controller.selectedCatList.clear();
                                Get.toNamed(
                                  AppRoutes.productListingScreen,
                                );
                              },
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: AppColor.white,
                                  boxShadow: boxShadow(),
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: SvgPicture.asset(AppAssets.menu),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => controller.getCurrentLoc(),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: AppColor.white,
                                  boxShadow: boxShadow(),
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: SvgPicture.asset(
                                    AppAssets.currentLocation,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (controller.filterVendorList.isNotEmpty)
                        CarouselSlider.builder(
                          itemCount: controller.filterVendorList.length,
                          carouselController: controller.carouselController,
                          options: CarouselOptions(
                            height: 141,
                            enlargeFactor: 2,
                            viewportFraction: 1,
                            reverse: false,
                            onPageChanged: (index, reason) {
                              BusinessModel data = controller
                                  .filterVendorList[index].businessData!;
                              controller.moveCamera(
                                LatLng(
                                  data.latitude ?? lat,
                                  data.longitude ?? lng,
                                ),
                                index,
                              );
                            },
                          ),
                          itemBuilder: (context, index, realIndex) {
                            UserModel userData =
                                controller.filterVendorList[index];
                            return GestureDetector(
                              onTap: () {
                                controller.selectedIndex = index;
                                Get.toNamed(
                                  AppRoutes.vendorScreen,
                                  arguments: userData,
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 5,
                                ),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                    boxShadow: boxShadow(),
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          bottomLeft: Radius.circular(8),
                                        ),
                                        child: ImageNet(
                                          userData.businessData?.logo ?? "",
                                          width: 120,
                                          boxFit: BoxFit.cover,
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 15,
                                            vertical: 10,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              S16Text(
                                                userData.businessData
                                                        ?.businessName ??
                                                    "",
                                                color: AppColor.grey100,
                                                maxLines: 1,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              S12Text(
                                                userData.businessData
                                                        ?.businessDesc ??
                                                    "",
                                                fontWeight: FontWeight.w400,
                                                color: const Color(0xFF156778),
                                                maxLines: 2,
                                              ),
                                              5.vertical(),
                                              S12Text(
                                                userData.businessData
                                                        ?.businessAddress ??
                                                    "",
                                                color: AppColor.grey80,
                                                maxLines: 2,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              const Spacer(),
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                      AppAssets.star),
                                                  const SizedBox(width: 8),
                                                  const S12Text(
                                                    "0",
                                                    color: AppColor.grey100,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  const S12Text(
                                                    "(0)",
                                                    color: AppColor.grey100,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ],
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
                          },
                        ),
                      20.vertical(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  List<BoxShadow> boxShadow() => [
        const BoxShadow(
          color: Colors.black12,
          offset: Offset(2, 2),
          blurRadius: 5,
          spreadRadius: 2,
        )
      ];
}
// GoogleMap(
// mapType: MapType.hybrid,
// initialCameraPosition: controller.kGooglePlex,
// onMapCreated: (GoogleMapController controller) {
// // _controller.complete(controller);
// },
// ),
