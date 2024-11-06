import 'package:salon_user/app/utils/all_dependency.dart';

class ServiceListingPage extends StatelessWidget {
  const ServiceListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    VendorNBookingController controller = Get.find();
    return Obx(
      () => CommonAppbar(
        title: AppStrings.serviceMenu,
        onBackTap: () {
          controller
            ..selectedServiceCat.clear()
            ..update();
        },
        bottomWidget: const BottomBookNowWidget(isServiceList: true),
        padding: EdgeInsets.zero,
        children: [
          const OurServiceWidget(
            isTitle: false,
            padding: EdgeInsets.fromLTRB(p16, 15, p16, 8),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: p16,
            ),
            itemCount: controller.filerServiceList.length,
            itemBuilder: (context, index) {
              return ServiceContainer(
                index: index,
                data: controller.filerServiceList[index],
              );
            },
          ),
        ],
      ),
    );
  }
}
