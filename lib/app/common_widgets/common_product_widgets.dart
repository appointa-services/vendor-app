import 'package:salon_user/app/common_widgets/image_network.dart';
import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/data_models/user_model.dart';
import 'package:salon_user/data_models/vendor_data_models.dart';
import 'package:substring_highlight/substring_highlight.dart';

class CategoryWidget extends StatelessWidget {
  final Function() onTap;
  final String cat;
  final bool isSelected;
  final bool isShadow;
  final bool isBookingScreen;

  const CategoryWidget({
    super.key,
    required this.onTap,
    required this.cat,
    required this.isSelected,
    this.isShadow = false,
    this.isBookingScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: isBookingScreen ? null : const EdgeInsets.only(right: 4),
        padding: isBookingScreen
            ? const EdgeInsets.symmetric(vertical: 5)
            : const EdgeInsets.symmetric(horizontal: 32),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColor.primaryColor : AppColor.grey60,
            width: 1.5,
          ),
          color: isSelected ? AppColor.primaryLightColor : AppColor.white,
          borderRadius: BorderRadius.circular(100),
          boxShadow: isShadow
              ? [
                  const BoxShadow(
                    color: Colors.black12,
                    offset: Offset(2, 2),
                    blurRadius: 5,
                    spreadRadius: 2,
                  )
                ]
              : null,
        ),
        child: S14Text(
          cat,
          color: isSelected ? AppColor.primaryColor : AppColor.grey100,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class VendorDetailWidget extends StatefulWidget {
  final int currentPage;
  final Function(int index) onPageChange;
  final UserModel? data;

  const VendorDetailWidget({
    super.key,
    required this.currentPage,
    required this.onPageChange,
    this.data,
  });

  @override
  State<VendorDetailWidget> createState() => _VendorDetailWidgetState();
}

class _VendorDetailWidgetState extends State<VendorDetailWidget> {
  int currentImg = 0;

  @override
  Widget build(BuildContext context) {
    BusinessModel? data = widget.data?.businessData;
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.vendorScreen, arguments: widget.data),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CarouselSlider.builder(
                  itemCount: data?.images.length ?? 0,
                  options: CarouselOptions(
                    viewportFraction: 1,
                    aspectRatio: 1.6,
                    onPageChanged: (indexes, reason) {
                      setState(() => currentImg = indexes);
                    },
                  ),
                  itemBuilder: (context, index, realIndex) {
                    String img = data?.images[index];
                    return ColoredBox(
                      color: AppColor.grey20,
                      child: ImageNet(
                        img,
                        width: double.infinity,
                        shimmerWidth: double.infinity,
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  data?.images.length ?? 0,
                  (indexes) => Padding(
                    padding: const EdgeInsets.only(
                      bottom: 15,
                      right: 5,
                      left: 5,
                    ),
                    child: CircleAvatar(
                      radius: 4,
                      backgroundColor: currentImg == indexes
                          ? AppColor.white
                          : Colors.white54,
                    ),
                  ),
                ),
              ),
            ],
          ),
          5.vertical(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5, right: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: ImageNet(
                    data?.logo ?? '',
                    width: 40,
                    height: 40,
                    boxFit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    S18Text(data?.businessName ?? ""),
                    S14Text(data?.businessAddress ?? "", maxLines: 2),
                    2.vertical(),
                    Row(
                      children: [
                        S14Text(
                          getCurrentStatus(data: data?.intervalList ?? []),
                          fontWeight: FontWeight.w600,
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.star_rate_rounded,
                          color: AppColor.orange,
                          size: 20,
                        ),
                        5.horizontal(),
                        const S14Text(
                          "0",
                          color: AppColor.grey100,
                          fontWeight: FontWeight.w700,
                        ),
                        const S14Text(
                          " (0)",
                          color: AppColor.grey100,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          10.vertical(),
          // ListView.builder(
          //   shrinkWrap: true,
          //   physics: const NeverScrollableScrollPhysics(),
          //   itemCount: 2,
          //   padding: EdgeInsets.zero,
          //   itemBuilder: (context, index) {
          //     return const Padding(
          //       padding: EdgeInsets.only(bottom: 10),
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               S16Text(
          //                 "Men Haircut",
          //                 fontWeight: FontWeight.w600,
          //                 color: AppColor.grey100,
          //               ),
          //               S14Text("₹450"),
          //             ],
          //           ),
          //           S14Text("30 mains"),
          //         ],
          //       ),
          //     );
          //   },
          // ),
          // GestureDetector(
          //   onTap: () => Get.toNamed(AppRoutes.vendorScreen),
          //   child: const S14Text(
          //     "Show more",
          //     color: AppColor.primaryColor,
          //     fontWeight: FontWeight.w700,
          //   ),
          // ),
        ],
      ),
    );
  }
}

class SearchWidget extends StatelessWidget {
  final int index;
  final UserModel? userData;

  const SearchWidget({super.key, required this.index, this.userData});

  @override
  Widget build(BuildContext context) {
    BusinessModel? data = userData?.businessData;
    HomeController controller = Get.find();
    List service = data?.serviceNameList.where((e) {
          return (e as String)
              .toLowerCase()
              .contains(controller.searchController.text);
        }).toList() ??
        [];
    return GestureDetector(
      onTap: () {
        controller.selectedIndex = index;
        Get.toNamed(
          AppRoutes.vendorScreen,
          arguments: userData,
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: Row(
          crossAxisAlignment: service.isEmpty
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ImageNet(
                data?.logo ?? "",
                height: 50,
                width: 50,
                boxFit: BoxFit.cover,
              ),
            ),
            10.horizontal(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchText(
                    text: data?.businessName ?? "",
                    search: controller.searchController.text,
                    size: 16,
                  ),
                  SearchText(
                    text: data?.businessAddress ?? "",
                    search: controller.searchController.text,
                    size: 14,
                  ),
                  if (service.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 5, bottom: 2),
                      child: S12Text("Services"),
                    ),
                  ...List.generate(
                    service.length,
                    (index) => Padding(
                      padding: const EdgeInsets.all(1),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.subdirectory_arrow_right_rounded,
                            size: 12,
                          ),
                          5.horizontal(),
                          SearchText(
                            text: service[index],
                            search: controller.searchController.text,
                            size: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SearchText extends StatelessWidget {
  final String text;
  final String search;
  final double size;

  const SearchText({
    super.key,
    required this.text,
    required this.search,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SubstringHighlight(
      text: text,
      term: search,
      maxLines: 2,
      textStyleHighlight: TextStyle(
        fontSize: size,
        color: AppColor.grey100,
        fontWeight: FontWeight.w500,
      ),
      textStyle: TextStyle(
        fontSize: size,
        color: AppColor.grey60,
      ),
    );
  }
}
