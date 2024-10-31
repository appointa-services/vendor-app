import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/data_models/vendor_data_models.dart';

import '../../common_widgets/img_loader.dart';

class AddUpdateServiceScreen extends StatelessWidget {
  const AddUpdateServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ServiceController controller = Get.find<ServiceController>();
    AuthController authController = Get.find<AuthController>();
    return CommonAppbar(
      title: controller.selectedService != null
          ? controller.selectedService!.serviceName
          : "Add Service",
      padd: const EdgeInsets.all(p16),
      bottomWidget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(p16),
            child: CommonBtn(
              text: controller.selectedService != null
                  ? AppStrings.update
                  : AppStrings.add,
              onTap: () => controller.addService(),
            ),
          ),
        ],
      ),
      children: [
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: [
              const S16Text(
                "Select category",
                fontWeight: FontWeight.w600,
                color: AppColor.grey100,
              ),
              GetBuilder<ServiceController>(
                builder: (controller) {
                  List<CategoryModel> categoryList = authController.categoryList
                      .where(
                        (element) =>
                            authController.user?.businessData?.selectedCat.any(
                              (e) => e == element.catId,
                            ) ??
                            false,
                      )
                      .toList();
                  return SizedBox(
                    height: 100,
                    child: ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      padding: const EdgeInsets.only(top: 8),
                      scrollDirection: Axis.horizontal,
                      itemCount: categoryList.length,
                      itemBuilder: (context, index) {
                        CategoryModel data = categoryList[index];
                        bool isSelect = controller.selectedCatId == data.catId;
                        return Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: GestureDetector(
                            onTap: () {
                              controller.selectedCatId = data.catId;
                              controller.update();
                            },
                            child: Column(
                              children: [
                                DecoratedBox(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: isSelect
                                          ? AppColor.grey100
                                          : AppColor.grey60,
                                      width: isSelect ? 1.5 : 1,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: ImgLoader(
                                      imageUrl: data.catImg,
                                      boxFit: BoxFit.cover,
                                      height: 30,
                                      width: 30,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: SizedBox(
                                    width: 50,
                                    child: S14Text(
                                      data.catName,
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      color: AppColor.grey100,
                                      fontWeight: isSelect
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              CommonTextfield(
                controller: controller.serviceName,
                title: AppStrings.serviceName,
                fontWeight: FontWeight.w600,
                textColor: AppColor.grey100,
              ),
              Row(
                children: [
                  Expanded(
                    child: CommonTextfield(
                      controller: controller.servicePrice,
                      title: AppStrings.price,
                      fontWeight: FontWeight.w600,
                      textColor: AppColor.grey100,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  15.horizontal(),
                  Expanded(
                    child: GetBuilder<ServiceController>(
                      builder: (controller) {
                        return CommonTextfield(
                          controller: TextEditingController(
                            text:
                                controller.timeToString(controller.serviceTime),
                          ),
                          title: AppStrings.serviceTime,
                          fontWeight: FontWeight.w600,
                          textColor: AppColor.grey100,
                          readOnly: true,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return CustomTimePickerDialog(
                                  time: controller.serviceTime,
                                  onTap: (int time) {
                                    controller.serviceTime = time;
                                    controller.update();
                                    Get.back();
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              CommonTextfield(
                controller: controller.serviceDesc,
                title: AppStrings.aboutService,
                fontWeight: FontWeight.w600,
                textColor: AppColor.grey100,
              ),
              const S16Text(
                AppStrings.businessImg,
                fontWeight: FontWeight.w600,
                color: AppColor.grey100,
              ),
              GetBuilder<ServiceController>(
                builder: (controller) {
                  return GridView.builder(
                    shrinkWrap: true,
                    itemCount: controller.serviceImgList.length + 1,
                    padding: const EdgeInsets.only(top: 8, bottom: 40),
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                    ),
                    itemBuilder: (context, index) {
                      return index == controller.serviceImgList.length
                          ? Padding(
                              padding: const EdgeInsets.all(2),
                              child: GestureDetector(
                                onTap: () async {
                                  controller.serviceImgList
                                      .addAll(await selectFiles());
                                  controller.update();
                                },
                                child: DottedBorder(
                                  color: AppColor.primaryColor,
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(10),
                                  dashPattern: const [7, 2],
                                  strokeWidth: 2,
                                  child: const Center(
                                    child: Icon(Icons.add, size: 20),
                                  ),
                                ),
                              ),
                            )
                          : Stack(
                              alignment: Alignment.topRight,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: controller.serviceImgList[index]
                                          .contains("https")
                                      ? ColoredBox(
                                          color: AppColor.grey20,
                                          child: ImgLoader(
                                            imageUrl: controller
                                                .serviceImgList[index],
                                            width: double.infinity,
                                            height: double.infinity,
                                          ),
                                        )
                                      : Image.file(
                                          File(
                                              controller.serviceImgList[index]),
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    controller
                                      ..serviceImgList.removeAt(index)
                                      ..update();
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(3),
                                    child: CircleAvatar(
                                      radius: 10,
                                      backgroundColor: AppColor.redColor,
                                      child: Icon(
                                        Icons.delete,
                                        color: AppColor.white,
                                        size: 12,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
