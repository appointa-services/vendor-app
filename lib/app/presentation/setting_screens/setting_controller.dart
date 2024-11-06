import 'dart:convert';

import 'package:crypt/crypt.dart';
import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/app/utils/loading.dart';
import 'package:salon_user/backend/admin_backend/add_get_vendor_data.dart';
import 'package:salon_user/backend/database_key.dart';

import '../../../data_models/user_model.dart';
import '../../helper/shared_pref.dart';

class SettingController extends GetxController {
  UserModel? user;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController currentPass = TextEditingController();
  TextEditingController newPass = TextEditingController();
  TextEditingController cuPass = TextEditingController();
  bool obscureText = true;
  bool newObscureText = true;
  bool newRePassObscureText = true;
  String selectedType = AppStrings.profile;
  String docScreen = AppStrings.aboutUs;

  Future<void> updateProfile({bool isUpdatePass = false}) async {
    Map? userModel = user?.toJson();
    if (!(isUpdatePass && !isPassCondition())) {
      Loader.show();
      await AddGetVendorData.updateProfile(
        name.text,
        mobile.text,
        newPass.text.isEmpty
            ? user?.password ?? ""
            : Crypt.sha256(newPass.text).toString(),
        user?.id ?? "",
      ).then((value) {
        if (value) {
          userModel!
            ..update(DatabaseKey.name, (value) => name.text)
            ..update(DatabaseKey.mobile, (value) => mobile.text)
            ..update(
              DatabaseKey.password,
              (value) => Crypt.sha256(newPass.text).toString(),
            );
          Pref.setString(Pref.userData, jsonEncode(userModel));
          user = UserModel.fromMap(userModel);
          currentPass.clear();
          newPass.clear();
          cuPass.clear();
          Get.back();
        } else {
          showSnackBar("Unable to update your profile");
        }
      });
      Loader.dismiss();
    }
  }

  bool isPassCondition() {
    bool isDone = false;
    if (Crypt(user?.password ?? "").match(currentPass.text)) {
      if (newPass.text.isEmpty) {
        showSnackBar("Please enter new password");
      } else if (!passValid(newPass.text)) {
        showSnackBar(AppStrings.enterValidPass);
      } else if (newPass.text != cuPass.text) {
        showSnackBar("New password and confirm password doesn't match");
      } else {
        isDone = true;
      }
    } else {
      if (currentPass.text.isEmpty) {
        showSnackBar("Please enter current password");
      } else {
        showSnackBar("Please enter valid current password");
      }
    }
    return isDone;
  }

  @override
  void onInit() async {
    String userData = await Pref.getString(Pref.userData);
    user = UserModel.fromMap(jsonDecode(userData));
    name.text = user?.name ?? "";
    email.text = user?.email ?? "";
    mobile.text = user?.mobile ?? "";
    super.onInit();
  }
}
