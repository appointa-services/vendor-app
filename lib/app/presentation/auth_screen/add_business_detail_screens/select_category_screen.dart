import 'package:salon_user/app/common_widgets/image_network.dart';
import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/data_models/vendor_data_models.dart';
import 'package:shimmer/shimmer.dart';

class SelectCategoryScreen extends StatelessWidget {
  const SelectCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (controller) {
        return Column(
          children: [
            const SText(
              AppStrings.whatServiceDoU,
              size: 26,
              fontWeight: FontWeight.w700,
            ),
            8.vertical(),
            const S14Text(
              AppStrings.chooseService,
              color: AppColor.grey80,
            ),
            GridView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount:
                  controller.isCatLoad ? 2 : controller.categoryList.length,
              padding: const EdgeInsets.symmetric(vertical: 20),
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
                      CategoryModel catData = controller.categoryList[index];
                      bool isSelected =
                          controller.selectedCat.contains(catData.catId);
                      return GestureDetector(
                        onTap: () {
                          if (isSelected) {
                            controller.selectedCat.remove(catData.catId);
                            controller.selectedCatName.remove(catData.catName);
                          } else {
                            controller.selectedCat.add(catData.catId);
                            controller.selectedCatName.add(catData.catName);
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ImageNet(catData.catImg, height: 50, width: 50),
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
            ),
          ],
        );
      },
    );
  }
}
