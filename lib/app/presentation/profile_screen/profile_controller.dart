import 'dart:convert';

import 'package:salon_user/app/common_widgets/upload_img_dialog.dart';
import 'package:salon_user/app/helper/shared_pref.dart';
import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/app/utils/loading.dart';
import 'package:salon_user/backend/database_key.dart';
import 'package:salon_user/backend/get_home_data.dart';
import 'package:salon_user/data_models/user_model.dart';

import '../../../data_models/vendor_data_models.dart';

class ProfileController extends GetxController {
  UserModel? user;
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController mobile = TextEditingController();
  DateTime? dob;
  String? gender;
  String? imgFile;
  String? imgUrl;
  String docScreen = AppStrings.aboutUs;
  RxList<UserModel> favouriteList = <UserModel>[].obs;
  RxBool isLoad = false.obs;

  Future<void> getFavList() async {
    isLoad.value = true;
    update();
    favouriteList.value = await GetHomeData.getFavList(user?.id ?? "");
    isLoad.value = false;
    update();
  }

  Future<void> removeFav(int index) async {
    favouriteList[index].isLoad.value = true;
    update();
    HomeController homeController = Get.find();
    List<FavouriteModel> list =
        favouriteList[index].businessData?.favouriteList ?? [];
    int favIndex = list.indexWhere((element) => element.id == user?.id);
    await GetHomeData.addFavouriteStore(
      userId: user?.id ?? "",
      vendorId: favouriteList[index].id ?? "",
      key: list[favIndex].key,
    ).then(
      (value) {
        favouriteList[index].isLoad.value = false;
        if (value.$1) {
          if (homeController.vendorList
              .any((element) => element.id == favouriteList[index].id)) {
            homeController.vendorList
                .firstWhere((element) => element.id == favouriteList[index].id)
                .businessData
                ?.favouriteList
                .removeWhere((element) => element.id == user?.id);
            homeController.update();
          }
          favouriteList.removeAt(index);
        } else {
          showSnackBar(
            "Unable to ${favIndex == -1 ? "add" : "remove"} store in favourite",
          );
        }
      },
    );
  }

  void assignData() {
    gender = user?.gender;
    dob = user?.dob != null ? DateTime.parse(user!.dob!) : null;
    name.text = user?.name ?? "";
    email.text = user?.email ?? "";
    mobile.text = user?.mobile ?? "";
    imgUrl = user?.image;
    imgFile = null;
    update();
  }

  Future<void> updateProfile(BuildContext context) async {
    if (imgFile != null) {
      showUploadImgDialog(
        img: [imgFile],
        context: context,
        path: "${DatabaseKey.user}/${user?.id}",
        onBack: (data) async {
          Get.back();
          imgFile = null;
          Loader.show();
          await updateP(img: data.first);
        },
      );
    } else {
      Loader.show();
      await updateP();
    }
  }

  Future<void> updateP({String? img}) async {
    await GetHomeData.updateProfile(
      name.text,
      mobile.text,
      dob?.toString(),
      gender ?? "",
      img ?? imgUrl ?? "",
      user?.id ?? "",
    ).then((value) async {
      Loader.dismiss();
      if (value) {
        user = UserModel(
          email: email.text,
          name: name.text,
          isLoad: isLoad,
          dob: dob.toString(),
          gender: gender,
          mobile: mobile.text,
          id: user?.id,
          image: img ?? imgUrl ?? user?.image,
          isGoogle: user?.isGoogle ?? false,
          password: user?.password ?? "",
        );
        Get.find<HomeController>().user = user;
        Get.find<HomeController>().update();
        update();
        Pref.setString(Pref.userData, user?.toString() ?? "");
        Get.back();
      } else {
        showSnackBar("Unable to update profile");
      }
    });
  }

  @override
  void onInit() async {
    String userData = await Pref.getString(Pref.userData);
    user = UserModel.fromMap(jsonDecode(userData));
    await getFavList();
    super.onInit();
  }
}
