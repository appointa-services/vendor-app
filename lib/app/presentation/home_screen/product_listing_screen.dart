import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/data_models/user_model.dart';
import 'package:salon_user/data_models/vendor_data_models.dart';

class ProductListingScreen extends StatelessWidget {
  const ProductListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.find<HomeController>();
    return Obx(
      () => CommonAppbar(
        title: controller.selectedCat.value,
        appbarSuffix: Padding(
          padding: const EdgeInsets.only(right: p16),
          child: GestureDetector(
            onTap: () {
              controller
                ..searchController.clear()
                ..searchVendorList.clear()
                ..update();
              Get.toNamed(AppRoutes.searchScreen);
            },
            child: SvgPicture.asset(AppAssets.search2Ic),
          ),
        ),
        children: [
          if (!(controller.categoryList.isEmpty &&
              !controller.isCatLoader.value))
            SizedBox(
              height: 50,
              child: ListView.builder(
                itemCount: controller.categoryList.length + 1,
                padding: const EdgeInsets.fromLTRB(p16, p16, p16, 2),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  CategoryModel? catModel;
                  if (index != 0) {
                    catModel = controller.categoryList[index - 1];
                  }
                  bool isSelected = controller.selectedCatList
                      .contains(catModel?.catId ?? "all");

                  return CategoryWidget(
                    onTap: () =>
                        controller.filterVendorByCat(catModel?.catId ?? "all"),
                    cat: catModel?.catName ?? "All",
                    isSelected: isSelected,
                  );
                },
              ),
            ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: controller.filterVendorList.length,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(p16),
            itemBuilder: (context, index) {
              UserModel? data = controller.filterVendorList[index];
              return VendorDetailWidget(
                data: data,
                currentPage: controller.currentServiceImg.value,
                onPageChange: (indexes) {
                  controller.currentServiceImg.value = indexes;
                  controller.update();
                },
              );
            },
          )
        ],
      ),
    );
  }
}
