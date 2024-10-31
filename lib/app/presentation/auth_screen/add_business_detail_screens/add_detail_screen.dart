import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:salon_user/app/common_widgets/get_lat_lg.dart';
import 'package:salon_user/app/common_widgets/image_netwok.dart';
import 'package:salon_user/app/common_widgets/img_loader.dart';
import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/data_models/vendor_data_models.dart';
import 'package:shimmer/shimmer.dart';

class AddDetailScreen extends StatelessWidget {
  const AddDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController controller = Get.find<AuthController>();
    return controller.isSettingScreen
        ? Scaffold(
            backgroundColor: AppColor.white,
            bottomNavigationBar: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(p16),
                child: CommonBtn(
                  text: "Save",
                  borderRad: 10,
                  onTap: () => controller.addBusinessDetail(context),
                ),
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: p16, top: 8, right: p16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: const Icon(Icons.arrow_back_rounded),
                        ),
                        15.horizontal(),
                        const S24Text(AppStrings.businessDetail),
                      ],
                    ),
                    15.vertical(),
                    child(),
                  ],
                ),
              ),
            ),
          )
        : child();
  }

  Expanded child() {
    AuthController controller = Get.find<AuthController>();
    return Expanded(
      child: ListView(
        primary: false,
        children: [
          if (controller.isSettingScreen)
            GetBuilder<AuthController>(
              builder: (controller) {
                return GestureDetector(
                  onTap: () async {
                    await selectFile().then((value) {
                      if (value.isNotEmpty) {
                        controller.businessLogo = value;
                        controller.update();
                      }
                    });
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColor.grey20,
                    child: controller.businessLogo != null &&
                            controller.businessLogo!.isNotEmpty
                        ? ClipOval(
                            child: controller.businessLogo!.contains("https")
                                ? ImgLoader(
                                    imageUrl: controller.businessLogo!,
                                    height: 100,
                                    boxFit: BoxFit.cover,
                                    width: 100,
                                  )
                                : Image.file(
                                    File(controller.businessLogo!),
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                          )
                        : const Icon(
                            Icons.add_rounded,
                            color: AppColor.grey80,
                            size: 35,
                          ),
                  ),
                );
              },
            ),
          if (controller.isSettingScreen)
            const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 25),
              child: S18Text(
                "Business logo",
                color: AppColor.grey80,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.center,
              ),
            ),
          if (!controller.isSettingScreen)
            const SText(
              AppStrings.businessDetail,
              size: 26,
              fontWeight: FontWeight.w700,
            ),
          if (!controller.isSettingScreen) 8.vertical(),
          if (!controller.isSettingScreen)
            const S14Text(
              AppStrings.tellUsMoreBusiness,
              color: AppColor.grey80,
            ),
          if (!controller.isSettingScreen) 20.vertical(),
          CommonTextfield(
            controller: controller.businessName,
            title: AppStrings.businessName,
            fontWeight: FontWeight.w600,
            textColor: AppColor.grey100,
          ),
          CommonTextfield(
            controller: controller.businessDesc,
            title: AppStrings.businessDesc,
            fontWeight: FontWeight.w600,
            textColor: AppColor.grey100,
          ),
          GetBuilder<AuthController>(
            builder: (controller) {
              return CommonTextfield(
                controller: controller.businessAddress,
                title: AppStrings.businessLoc,
                fontWeight: FontWeight.w600,
                readOnly: controller.latLng == null,
                textColor: AppColor.grey100,
                onTap: () {
                  if (controller.latLng == null) {
                    Get.to(const PickLatLng())!.then(
                      (value) {
                        controller.latLng = value.$1;
                        controller.businessAddress.text = value.$2;
                        controller.update();
                      },
                    );
                  }
                },
                onPressed: () {
                  if (controller.latLng != null) {
                    Get.to(PickLatLng(latLng: controller.latLng))!.then(
                      (value) {
                        controller.latLng = value.$1;
                        controller.businessAddress.text = value.$2;
                        controller.update();
                      },
                    );
                  }
                },
                suffixIcon: Icons.my_location_rounded,
              );
            },
          ),
          const S16Text(
            AppStrings.whatTeam,
            fontWeight: FontWeight.w600,
            color: AppColor.grey100,
          ),
          8.vertical(),
          GetBuilder<AuthController>(
            builder: (controller) {
              return DropdownButtonFormField2(
                decoration: InputDecoration(
                  focusedBorder:
                      outlineInputBorder(color: AppColor.primaryColor),
                  fillColor: AppColor.grey20,
                  filled: true,
                  suffix: const SizedBox(width: 15),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  enabledBorder: outlineInputBorder(),
                ),
                isExpanded: true,
                dropdownStyleData: DropdownStyleData(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                value: controller.teamSize,
                items: [
                  AppStrings.itsMe,
                  "2-5 people",
                  "6-10 people",
                  "11+ people",
                ]
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColor.grey100,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) async {
                  if (value != null) {
                    controller.teamSize = value;
                    controller.update();
                  }
                },
              );
            },
          ),
          15.vertical(),
          const S16Text(
            AppStrings.businessImg,
            fontWeight: FontWeight.w600,
            color: AppColor.grey100,
          ),
          8.vertical(),
          GetBuilder<AuthController>(
            builder: (controller) {
              return GridView.builder(
                shrinkWrap: true,
                itemCount: controller.businessImgList.length + 1,
                padding: const EdgeInsets.only(top: 8, bottom: 10),
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemBuilder: (context, index) {
                  String? img;
                  if (index != controller.businessImgList.length) {
                    img = controller.businessImgList[index];
                  }
                  if (index == controller.businessImgList.length) {
                    return Padding(
                      padding: const EdgeInsets.all(2),
                      child: GestureDetector(
                        onTap: () async {
                          controller.businessImgList
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
                    );
                  } else {
                    img.print();
                    return Stack(
                      alignment: Alignment.topRight,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: ColoredBox(
                            color: AppColor.grey20,
                            child: img!.contains("https")
                                ? ColoredBox(
                                    color: AppColor.grey20,
                                    child: ImgLoader(
                                      imageUrl: img,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  )
                                : Image.file(
                                    File(controller.businessImgList[index]),
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller
                              ..businessImgList.removeAt(index)
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
                  }
                },
              );
            },
          ),
          if (controller.isSettingScreen)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: S16Text(
                "Selected category",
                fontWeight: FontWeight.w600,
                color: AppColor.grey100,
              ),
            ),
          if (controller.isSettingScreen)
            GetBuilder<AuthController>(
              builder: (controller) {
                return GridView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount:
                      controller.isCatLoad ? 2 : controller.categoryList.length,
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.1,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemBuilder: controller.isCatLoad
                      ? (context, index) {
                          return Shimmer.fromColors(
                            highlightColor: Colors.black12,
                            baseColor: Colors.black26,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const SizedBox(
                                      height: 45,
                                      width: 45,
                                    ),
                                  ),
                                  15.vertical(),
                                  DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const SizedBox(
                                      height: 10,
                                      width: 80,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      : (context, index) {
                          CategoryModel catData =
                              controller.categoryList[index];
                          bool isSelected =
                              controller.selectedCat.contains(catData.catId);
                          return GestureDetector(
                            onTap: () {
                              if (isSelected) {
                                controller.selectedCatName
                                    .remove(catData.catName);
                                controller.selectedCat.remove(catData.catId);
                              } else {
                                controller.selectedCatName.add(catData.catName);
                                controller.selectedCat.add(catData.catId);
                              }
                              controller.update();
                            },
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isSelected
                                      ? AppColor.grey100
                                      : AppColor.grey40,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(25),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ImageNet(
                                      catData.catImg,
                                      height: 50,
                                      width: 50,
                                    ),
                                    10.vertical(),
                                    S18Text(
                                      catData.catName,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                );
              },
            ),
        ],
      ),
    );
  }

  OutlineInputBorder outlineInputBorder({Color? color}) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: color ?? AppColor.grey20,
        ),
      );
}
