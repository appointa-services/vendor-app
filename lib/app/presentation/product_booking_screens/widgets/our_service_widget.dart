import 'package:salon_user/app/common_widgets/image_network.dart';
import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/data_models/vendor_data_models.dart';

class OurServiceWidget extends StatelessWidget {
  final bool isTitle;
  final EdgeInsets? padding;
  final bool isSelect;
  const OurServiceWidget({
    super.key,
    this.isTitle = true,
    this.padding,
    this.isSelect = true,
  });

  @override
  Widget build(BuildContext context) {
    VendorNBookingController controller = Get.find<VendorNBookingController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isTitle)
          const S16Text(
            AppStrings.ourService,
            fontWeight: FontWeight.w700,
            color: AppColor.grey100,
          ),
        Obx(
          () => SizedBox(
            height: 65,
            child: ListView.builder(
              shrinkWrap: true,
              padding: padding ?? const EdgeInsets.only(top: 15, bottom: 8),
              scrollDirection: Axis.horizontal,
              itemCount: controller.categoryList.length,
              itemBuilder: (context, index) {
                CategoryModel catData = controller.categoryList[index];
                return GetBuilder<VendorNBookingController>(
                  builder: (controller) {
                    bool isContain =
                        controller.selectedServiceCat.contains(index);
                    return GestureDetector(
                      onTap: () {
                        if (isSelect) {
                          if (isContain) {
                            controller.selectedServiceCat.remove(index);
                          } else {
                            controller.selectedServiceCat.add(index);
                          }
                          controller.filerServiceList.clear();
                          if (controller.selectedServiceCat.isEmpty) {
                            controller.filerServiceList.clear();
                            controller.filerServiceList
                                .addAll(controller.serviceList);
                          } else {
                            for (int index in controller.selectedServiceCat) {
                              controller.filerServiceList.addAll(
                                controller.serviceList.where((element) =>
                                    element.categoryId ==
                                    controller.categoryList[index].catId),
                              );
                            }
                          }
                          controller.update();
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isContain
                                  ? AppColor.primaryColor
                                  : AppColor.grey60,
                            ),
                            borderRadius: BorderRadius.circular(50),
                            color: isContain
                                ? AppColor.primaryLightColor
                                : Colors.transparent,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            child: Row(
                              children: [
                                ImageNet(
                                  catData.catImg,
                                  width: 20,
                                ),
                                8.horizontal(),
                                S14Text(
                                  catData.catName,
                                  fontWeight: FontWeight.w600,
                                  color: isContain
                                      ? AppColor.primaryColor
                                      : AppColor.grey100,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
