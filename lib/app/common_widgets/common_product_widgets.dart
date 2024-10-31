import 'package:salon_user/app/utils/all_dependency.dart';

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

class VendorDetailWidget extends StatelessWidget {
  final int currentPage;
  final Function(int index) onPageChange;
  const VendorDetailWidget({
    super.key,
    required this.currentPage,
    required this.onPageChange,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.vendorScreen),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CarouselSlider.builder(
                  itemCount: 5,
                  options: CarouselOptions(
                    viewportFraction: 1,
                    aspectRatio: 1.6,
                    onPageChanged: (indexes, reason) {
                      onPageChange(indexes);
                    },
                  ),
                  itemBuilder: (context, index, realIndex) {
                    return Image.asset(
                      index % 2 == 0
                          ? AppAssets.dummySalon2
                          : AppAssets.dummySalon,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (indexes) => Padding(
                    padding: const EdgeInsets.only(
                      bottom: 15,
                      right: 5,
                      left: 5,
                    ),
                    child: CircleAvatar(
                      radius: 4,
                      backgroundColor: currentPage == indexes
                          ? AppColor.white
                          : Colors.white54,
                    ),
                  ),
                ),
              ),
            ],
          ),
          5.vertical(),
          const S18Text("Plush Beauty Salon"),
          const S14Text("salon address is here"),
          2.vertical(),
          const S14Text(
            "Open until 9:00 PM",
            fontWeight: FontWeight.w600,
          ),
          8.vertical(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(
                Icons.star_rate_rounded,
                color: AppColor.orange,
                size: 20,
              ),
              5.horizontal(),
              const S14Text(
                "5.0",
                color: AppColor.grey100,
                fontWeight: FontWeight.w700,
              ),
              const S14Text(
                " (100)",
                color: AppColor.grey100,
              ),
            ],
          ),
          const Divider(height: 20),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 2,
            itemBuilder: (context, index) {
              return const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        S16Text(
                          "Men Haicut",
                          fontWeight: FontWeight.w600,
                          color: AppColor.grey100,
                        ),
                        S14Text("${AppStrings.rupee}450"),
                      ],
                    ),
                    S14Text("30 mins"),
                  ],
                ),
              );
            },
          ),
          GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.vendorScreen),
            child: const S14Text(
              "Show more",
              color: AppColor.primaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          25.vertical(),
        ],
      ),
    );
  }
}

class SearchWidget extends StatelessWidget {
  final int index;
  const SearchWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.vendorScreen,
          arguments: index % 2 != 0,
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: const DecorationImage(
                  image: AssetImage(AppAssets.dummySalon2),
                ),
              ),
              child: const SizedBox(height: 45, width: 45),
            ),
            10.horizontal(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  S16Text(
                    index % 2 == 0 ? "Venue name" : "Service name",
                    fontWeight: FontWeight.w600,
                    color: AppColor.grey100,
                    maxLines: 1,
                  ),
                  S14Text(
                    index % 2 == 0
                        ? "Venue • Xyz Mall, Surat, Gujarat"
                        : "Service • Vanue name • Xyz Mall, Surat, Gujarat",
                    fontWeight: FontWeight.w600,
                    color: AppColor.grey60,
                    maxLines: 1,
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
