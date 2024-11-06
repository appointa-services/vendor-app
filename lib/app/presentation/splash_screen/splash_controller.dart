import 'dart:convert';

import 'package:salon_user/app/helper/shared_pref.dart';
import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/backend/authentication.dart';
import 'package:salon_user/backend/database_key.dart';
import 'package:salon_user/backend/database_ref.dart';
import 'package:salon_user/data_models/user_model.dart';

class SplashController extends GetxController {
  @override
  void onInit() async {
    String email = await Pref.getString(Pref.emailKey);
    String userData = await Pref.getString(Pref.userData);
    bool isAdmin = await Pref.getBool(Pref.isAdminKey);
    Future.delayed(const Duration(seconds: 3), () async {
      if (email.isEmpty) {
        Get.offAllNamed(AppRoutes.loginScreen);
      } else if (isAdmin) {
        Get.offAllNamed(AppRoutes.adminHome);
      } else {
        if (userData.isNotEmpty) {
          UserModel user = UserModel.fromMap(jsonDecode(userData));
          await AuthenticationApiClass.getData(
            DatabaseRef.vendor,
            user.id,
            comKey: DatabaseKey.id,
          ).then((value) {
            if (value != null) {
              (value as Map).forEach(
                (key, value) async {
                  UserModel user = UserModel.fromMap(value as Map);
                  user.toString().print;
                  Pref.setString(Pref.userData, user.toString());
                  if (user.businessData == null) {
                    Get.offAllNamed(AppRoutes.addBusinessScreen);
                  } else {
                    Get.offAllNamed(AppRoutes.dashboardScreen);
                  }
                },
              );
            } else {
              Get.offAllNamed(AppRoutes.loginScreen);
            }
          });
        } else {
          Get.offAllNamed(AppRoutes.loginScreen);
        }
      }
    });
    super.onInit();
  }
}

class DetailScreenController extends GetxController {
  RxInt screenIndex = 0.obs;
  PageController pageController = PageController();

  List<(String, String)> screenContent = [
    (AppAssets.detailFind1, AppStrings.findBarber),
    (AppAssets.detailBook, AppStrings.bookYrFav),
    (AppAssets.detail3, AppStrings.comeBeHandsome),
  ];
}
