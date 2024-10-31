import 'package:salon_user/app/helper/shared_pref.dart';
import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/app/utils/loading.dart';
import 'package:salon_user/backend/admin_backend/get_home_data.dart';

import '../../../data_models/vendor_data_models.dart';

class AdminController extends GetxController {
  List<CategoryModel> categoryList = [];

  Future<void> getCatrgoryData() async {
    Loader.show();
    categoryList = await AdminHomeData.getCategoryData();
    update();
    Loader.dismiss();
  }

  Future<void> logout() async {
    Loader.show();
    await Pref.clearAlData().then(
      (value) {
        Loader.dismiss();
        Get.offAllNamed(AppRoutes.loginScreen);
      },
    );
  }

  @override
  void onInit() async {
    await getCatrgoryData();
    super.onInit();
  }
}
