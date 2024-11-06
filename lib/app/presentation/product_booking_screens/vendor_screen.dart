import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/data_models/vendor_data_models.dart';
import '../../common_widgets/image_network.dart';

class VendorScreen extends StatefulWidget {
  const VendorScreen({super.key});

  @override
  State<VendorScreen> createState() => _VendorScreenState();
}

class _VendorScreenState extends State<VendorScreen> {
  VendorNBookingController controller = Get.put(VendorNBookingController());
  HomeController homeController = Get.find();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (Get.arguments != null) {
        if (Get.arguments is bool) {
          Future.delayed(const Duration(milliseconds: 500), () {
            serviceDetailSheet(0);
          });
        } else {
          controller.vendorData.value = Get.arguments;
          controller.index.value = homeController.selectedIndex;
          controller.getCategory();
          controller.getServiceList();
          controller.getStaffList();
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomBookNowWidget(),
      body: Obx(
        () {
          List imageList =
              controller.vendorData.value?.businessData?.images ?? [];
          BusinessModel? data = controller.vendorData.value?.businessData;
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              Stack(
                children: [
                  if (imageList.isNotEmpty)
                    CarouselSlider.builder(
                      itemCount: imageList.length,
                      options: CarouselOptions(
                        viewportFraction: 1,
                        aspectRatio: 1.3,
                        onPageChanged: (index, reason) {
                          controller.currentImg = index;
                          controller.update();
                        },
                      ),
                      itemBuilder: (context, index, realIndex) {
                        return ColoredBox(
                          color: AppColor.grey20,
                          child: ImageNet(
                            imageList[index],
                            width: double.infinity,
                            shimmerWidth: double.infinity,
                          ),
                        );
                      },
                    ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(p16),
                      child: Row(
                        children: [
                          CircularIcon(
                            icon: Icons.arrow_back_rounded,
                            onTap: () => Get.back(),
                          ),
                          const Spacer(),
                          Obx(
                            () {
                              bool isFav = controller.vendorData.value
                                      ?.businessData?.favouriteList
                                      .any((element) =>
                                          element.id ==
                                          homeController.user?.id) ??
                                  false;
                              return controller
                                          .vendorData.value?.isLoad.value ??
                                      false
                                  ? const CircleAvatar(
                                      radius: 24,
                                      backgroundColor: AppColor.white,
                                      child: Padding(
                                        padding: EdgeInsets.all(8),
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColor.grey100,
                                        ),
                                      ),
                                    )
                                  : CircularIcon(
                                      icon: isFav
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: isFav
                                          ? AppColor.redColor
                                          : AppColor.grey100,
                                      onTap: () => controller.addRemoveFav(),
                                    );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColor.grey100,
                      ),
                      child: GetBuilder<VendorNBookingController>(
                        builder: (controller) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 5,
                            ),
                            child: S14Text(
                              "${controller.currentImg + 1} / ${imageList.length}",
                              color: AppColor.white,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(p16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    S24Text(data?.businessName ?? ""),
                    S14Text(data?.businessAddress ?? ""),
                    2.vertical(),
                    S14Text(
                      getCurrentStatus(data: data?.intervalList ?? []),
                      fontWeight: FontWeight.w600,
                    ),
                    8.vertical(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Icon(
                          Icons.star_rate_rounded,
                          color: AppColor.orange,
                          size: 25,
                        ),
                        5.horizontal(),
                        const S16Text(
                          "0",
                          color: AppColor.grey100,
                          fontWeight: FontWeight.w700,
                        ),
                        const S16Text(
                          " (0)",
                          color: AppColor.grey100,
                        ),
                      ],
                    ),
                    const Divider(height: 40),
                    if (!(controller.serviceList.isEmpty &&
                        !controller.isServiceLoad.value))
                      const OurServiceWidget(isSelect: false),
                    if (!(controller.serviceList.isEmpty &&
                        !controller.isServiceLoad.value))
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        itemCount: controller.isServiceLoad.value
                            ? 3
                            : controller.serviceList.length,
                        itemBuilder: (context, index) {
                          return ServiceContainer(
                            index: index,
                            data: controller.isServiceLoad.value
                                ? null
                                : controller.serviceList[index],
                          );
                        },
                      ),
                    if (controller.serviceList.isNotEmpty &&
                        !controller.isServiceLoad.value)
                      CommonBtn(
                        vertPad: 10,
                        text: AppStrings.viewAllServices,
                        borderColor: AppColor.primaryColor,
                        btnColor: AppColor.white,
                        textColor: AppColor.primaryColor,
                        onTap: () => Get.toNamed(AppRoutes.serviceList),
                      )
                    else
                      const Align(
                        alignment: Alignment.center,
                        child: S16Text(
                          "No service found",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    if (!(controller.staffList.isEmpty &&
                        !controller.isStaffLoad.value))
                      30.vertical(),
                    if (!(controller.staffList.isEmpty &&
                        !controller.isStaffLoad.value))
                      const ViewAllBtn(text: AppStrings.ourSpecialist),
                    if (!(controller.staffList.isEmpty &&
                        !controller.isStaffLoad.value))
                      const SpecialistWidget(),
                    const Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 8),
                      child: S16Text(
                        AppStrings.about,
                        fontWeight: FontWeight.w700,
                        color: AppColor.grey100,
                      ),
                    ),
                    ReadMoreText(
                      data?.businessDesc ?? "",
                      isExpandable: true,
                      trimLength: 200,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColor.grey80,
                        fontWeight: FontWeight.w500,
                      ),
                      moreStyle: const TextStyle(
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                      lessStyle: const TextStyle(
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 8),
                      child: S16Text(
                        AppStrings.openingTime,
                        fontWeight: FontWeight.w700,
                        color: AppColor.grey100,
                      ),
                    ),
                    ...List.generate(
                      data?.intervalList.length ?? 0,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 4,
                              backgroundColor: isOnline(startToEnd(
                                      data?.intervalList[index].data))
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                            8.horizontal(),
                            S14Text(
                              controller.dayList[index],
                              color: index == DateTime.now().weekday - 1
                                  ? AppColor.grey100
                                  : null,
                              fontWeight: index == DateTime.now().weekday - 1
                                  ? FontWeight.w700
                                  : null,
                            ),
                            const Spacer(),
                            S14Text(
                              startToEnd(data?.intervalList[index].data),
                              color: index == DateTime.now().weekday - 1
                                  ? AppColor.grey100
                                  : null,
                              fontWeight: index == DateTime.now().weekday - 1
                                  ? FontWeight.w700
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          height: 200,
                          child: CompanyMap(
                            latLng: LatLng(
                              data?.latitude ?? 22.75481,
                              data?.longitude ?? 73.511554,
                            ),
                          ),
                        ),
                      ),
                    ),
                    S14Text(
                      data?.businessAddress ?? "",
                      fontWeight: FontWeight.w600,
                    ),
                    3.vertical(),
                    GestureDetector(
                      onTap: () {
                        MapsLauncher.launchCoordinates(
                          data?.latitude ?? 22.75481,
                          data?.longitude ?? 73.511554,
                          data?.businessName,
                        );
                      },
                      child: const S16Text(
                        AppStrings.getDirection,
                        fontWeight: FontWeight.w700,
                        color: AppColor.primaryColor,
                      ),
                    ),
                    20.vertical(),
                    ViewAllBtn(onTap: () {}, text: AppStrings.review),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: 4,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      itemBuilder: (context, index) {
                        return const ReviewContainer();
                      },
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
