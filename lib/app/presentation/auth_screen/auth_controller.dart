import 'dart:convert';
import 'package:crypt/crypt.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:salon_user/app/helper/shared_pref.dart';
import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/app/utils/loading.dart';
import 'package:salon_user/backend/admin_backend/add_get_vendor_data.dart';
import 'package:salon_user/backend/admin_backend/get_home_data.dart';
import 'package:salon_user/backend/authentication.dart';
import 'package:salon_user/backend/database_key.dart';
import 'package:salon_user/data_models/vendor_data_models.dart';
import 'package:salon_user/data_models/user_model.dart';
import '../../common_widgets/upload_img_dialog.dart';

class AuthController extends GetxController {
  AuthController({this.isCatDataLoad = false});
  bool isCatDataLoad = false;
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController rePass = TextEditingController();
  TextEditingController confPass = TextEditingController();
  TextEditingController otp = TextEditingController();
  bool isSettingScreen = false;
  bool isLoad = false;
  UserModel? user;

  /// add business detail screen variable
  TextEditingController businessName = TextEditingController();
  TextEditingController businessDesc = TextEditingController();
  TextEditingController businessAddress = TextEditingController();
  var latLng;
  String? teamSize;
  List businessImgList = [];
  String? businessLogo;
  bool isClose = false;
  List<String> toTimeList = [];
  String selectedStartTime = "10:00 AM";
  String selectedEndTime = "07:00 PM";
  List<BreakModel> breaksList = [];
  List<CategoryModel> categoryList = [];
  List selectedCat = [];
  List selectedCatName = [];
  List<IntervalModel> intervalList = [];

  void addTime() {
    toTimeList.clear();
    for (int i = 0; i < 288; i++) {
      Duration duration = Duration(
        hours: i ~/ 12,
        minutes: (i.remainder(12) + 1) * 5,
      );
      DateTime dateTime = DateTime(0, 1, 1).add(duration);
      String formattedTime = DateFormat('hh:mm a').format(dateTime);
      toTimeList.add(formattedTime);
    }
  }

  bool obscureText = true;
  bool isRegister = false;
  bool reObscureText = true;
  Timer? timer;
  int otpTime = 60;
  double indicatorValue = (1 / 3);

  void clearTap({bool isBack = false, bool isOtpClear = false, String? page}) {
    if (isBack) {
      Get.back();
    } else {
      if (page != null) {
        Get.toNamed(page);
      }
    }
    if (isOtpClear) {
      if (timer != null) {
        timer!.cancel();
      }
    } else {
      email.clear();
      pass.clear();
      obscureText = true;
    }
    update();
  }

  void startTimer() {
    otpTime = 60;
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (otpTime != 0) {
        otpTime--;
        update();
      } else {
        "-->>> $otpTime".print;
        timer!.cancel();
        update();
      }
    });
  }

  String getDuration() {
    Duration time = Duration(seconds: otpTime);
    return "${time.inMinutes > 9 ? time.inMinutes : "0${time.inMinutes}"}"
        ":${time.inSeconds.remainder(60) > 9 ? time.inSeconds.remainder(60) : ""
            "0${time.inSeconds.remainder(60)}"}";
  }

  /// api section
  /// login api
  Future<void> login() async {
    if (email.text.isEmpty) {
      showSnackBar(AppStrings.enterEmail);
    } else if (!emailValid(email.text)) {
      showSnackBar(AppStrings.enterValidEmail);
    } else if (pass.text.isEmpty) {
      showSnackBar(AppStrings.enterPass);
    } else if (pass.text.length < 6) {
      showSnackBar(AppStrings.enterValidPass);
    } else {
      LoginResponse response = await AuthenticationApiClass.login(
        email.text,
        pass.text,
      );

      if (response.isError) {
        showSnackBar(AppStrings.serverErr);
      } else {
        if (response.isPassWrong) {
          showSnackBar(AppStrings.passErr);
        } else if (response.data != null) {
          if (response.data!.password != null) {
            Pref.setString(Pref.userData, response.data!.toString());
            Pref.setString(Pref.emailKey, response.data?.email ?? "");
            if (response.data!.businessData != null) {
              Get.offAllNamed(AppRoutes.dashboardScreen);
            } else {
              Get.offAllNamed(AppRoutes.addBusinessScreen);
            }
          } else {
            showSnackBar(AppStrings.enteredEmailGoogle);
          }
        } else if (response.isAdmin) {
          Pref.setString(Pref.emailKey, email.text);
          Pref.setBool(Pref.isAdminKey, true);
          Get.offAllNamed(AppRoutes.adminHome);
        } else {
          showSnackBar(AppStrings.userNot);
        }
      }
    }
  }

  Future<void> signInWithGoogle() async {
    Loader.show();
    UserModel? data = await AuthenticationApiClass.signInWithGoogle();
    if (data != null) {
      "--->>> encrypted user ${data.toString()}".print;
      Pref.setString(Pref.userData, data.toString());
      Pref.setString(Pref.emailKey, data.email ?? "");
      if (data.businessData == null) {
        Get.offAllNamed(AppRoutes.addBusinessScreen);
      } else {
        Get.offAllNamed(AppRoutes.dashboardScreen);
      }
    }
    Loader.dismiss();
  }

  Future<void> sendOtpForRegister() async {
    if (businessName.text.isEmpty) {
      showSnackBar(AppStrings.enterBusinessName);
    } else if (email.text.isEmpty) {
      showSnackBar(AppStrings.enterEmail);
    } else if (!emailValid(email.text)) {
      showSnackBar(AppStrings.enterValidEmail);
    } else if (mobile.text.isEmpty) {
      showSnackBar(AppStrings.enterMobile);
    } else if (!mobileValid(mobile.text)) {
      showSnackBar(AppStrings.enterValidMobile);
    } else if (pass.text.isEmpty) {
      showSnackBar(AppStrings.enterPass);
    } else if (!passValid(pass.text)) {
      showSnackBar(AppStrings.enterValidPass);
    } else if (rePass.text.isEmpty) {
      showSnackBar(AppStrings.enterConPass);
    } else if (pass.text != rePass.text) {
      showSnackBar(AppStrings.passNotMatch);
    } else {
      await sendOtp();
    }
  }

  Future<void> sendOtp({bool isPass = false, bool isResend = false}) async {
    if (email.text.isEmpty) {
      showSnackBar(AppStrings.enterEmail);
    } else if (!emailValid(email.text)) {
      showSnackBar(AppStrings.enterValidEmail);
    } else {
      await AuthenticationApiClass.sendOtp(email.text, isPass: isPass).then(
        (value) {
          if (value.$2 && !isPass) {
            showSnackBar("Entered email id is already exist");
          } else {
            if (!value.$2 && isPass) {
              showSnackBar("Entered email id is not found");
            } else if (value.$1) {
              isRegister = !isPass;
              startTimer();
              update();
              if (!isResend) {
                Get.toNamed(AppRoutes.otpScreen);
              }
              user = value.$3;
              showSnackBar(
                "OTP sent successfully",
                color: AppColor.primaryColor,
              );
            } else {
              showSnackBar("Unable to send otp");
            }
          }
        },
      );
    }
  }

  Future<void> verifyOtp() async {
    if (otp.text.isEmpty) {
      showSnackBar("Please enter OTP");
    } else if (otp.text.length < 6) {
      showSnackBar("Please enter valid OTP");
    } else {
      UserModel data = UserModel(
        email: email.text,
        name: businessName.text,
        mobile: mobile.text,
        password: Crypt.sha256(pass.text).toString(),
      );
      await AuthenticationApiClass.verifyOtp(
        data,
        otp.text,
        isPass: !isRegister,
      ).then((value) {
        if (value.$1) {
          if (isRegister) {
            Pref.setString(Pref.userData, data.toString());
            Pref.setString(Pref.emailKey, data.email ?? "");
          }
          if (timer != null) {
            timer!.cancel();
          }
          otpTime = 0;
          isRegister
              ? Get.offAllNamed(AppRoutes.addBusinessScreen)
              : Get.toNamed(AppRoutes.resetPassScreen);
          update();
        } else {
          showSnackBar("Invalid OTP");
        }
      });
    }
  }

  Future<void> resetPass({String? currentPass}) async {
    if (pass.text.isEmpty) {
      showSnackBar(AppStrings.enterPass);
    } else if (pass.text.isNotEmpty &&
        currentPass != null &&
        !Crypt(currentPass).match(pass.text)) {
      showSnackBar("Current password is wrong");
    } else if (!passValid(pass.text)) {
      showSnackBar(AppStrings.enterValidPass);
    } else if (rePass.text.isEmpty) {
      if (currentPass != null) {
        showSnackBar("Please enter new password");
      } else {
        showSnackBar(AppStrings.enterConPass);
      }
    } else if (!passValid(pass.text) && currentPass != null) {
      showSnackBar("Please enter at least 6 digit New password");
    } else if (rePass.text != pass.text && currentPass == null) {
      showSnackBar(AppStrings.passNotMatch);
    } else if (confPass.text.isEmpty && currentPass != null) {
      showSnackBar("Please enter confirm password");
    } else if (confPass.text != rePass.text && currentPass != null) {
      showSnackBar("New pasword and confirm password are not match");
    } else {
      await AuthenticationApiClass.resetPass(user?.id! ?? "", rePass.text).then(
        (value) {
          if (value) {
            clearTap();
            if (timer != null) {
              timer!.cancel();
            }
            Get.back();
            Get.back();
            if (currentPass == null) {
              Get.back();
            }
            showSnackBar(
              "Password change successfuly",
              color: AppColor.primaryColor,
            );
          } else {
            showSnackBar("Unable to reset your password");
          }
        },
      );
    }
  }

  /// get category api
  bool isCatLoad = false;
  Future<void> getCategory() async {
    isCatLoad = true;
    update();
    categoryList = await AdminHomeData.getCategoryData();
    isCatLoad = false;
    update();
  }

  Future<void> logout() async {
    Loader.show();
    String userData = await Pref.getString(Pref.userData);
    if (UserModel.fromMap(jsonDecode(userData)).isGoogle) {
      await AuthenticationApiClass.signOutFromGoogle();
    }
    await Pref.clearAlData();
    AuthenticationApiClass.signOutFromGoogle();
    Loader.dismiss();
    Get.offAllNamed(AppRoutes.loginScreen);
  }

  isDetailedFilled() {
    if (businessName.text.isEmpty) {
      showSnackBar("Please enter your business name");
    } else if (businessDesc.text.isEmpty) {
      showSnackBar("Please enter your business description");
    } else if (businessAddress.text.isEmpty) {
      showSnackBar("Please enter your business address");
    } else if (businessImgList.isEmpty) {
      showSnackBar("Please select at least one business image");
    } else {
      indicatorValue = 1;
      update();
    }
  }

  Future<void> addBusinessDetail(
    BuildContext context, {
    bool isEdit = true,
  }) async {
    /// get user data
    UserModel? userData;
    (await Pref.getString(Pref.userData)).print;
    Map<String, dynamic> user = jsonDecode(await Pref.getString(Pref.userData));
    userData = UserModel.fromMap(user);

    /// add all image
    List totalImgList = [];
    for (var element in businessImgList) {
      totalImgList.add(element);
    }
    if (businessLogo != null) {
      totalImgList.add(businessLogo);
    }

    /// add filter to all images which are url and which are new one
    List uploadImgList = totalImgList
        .where((element) => !(element as String).contains("https"))
        .toList();

    if (uploadImgList.isNotEmpty) {
      showUploadImgDialog(
        img: totalImgList,
        // ignore: use_build_context_synchronously
        context: context,
        path: "${DatabaseKey.vendor}/${userData.id}/",
        onBack: (_) async {
          await updateBusinessDetail(
            imgList: _,
            isEdit: isEdit,
            userData: userData,
          );
        },
      );
    } else {
      await updateBusinessDetail(
        imgList: totalImgList,
        isEdit: isEdit,
        userData: userData,
        isBack: false,
      );
    }
  }

  Future<void> updateBusinessDetail({
    UserModel? userData,
    required List imgList,
    bool isBack = true,
    required bool isEdit,
  }) async {
    Map<String, dynamic>? userModel = userData?.toJson();
    if (isBack) {
      Get.back();
    }
    Loader.show();
    String logo = imgList.last;

    List imgUrl = imgList;
    imgUrl.removeLast();

    BusinessModel businessModel = BusinessModel(
      businessName: businessName.text,
      businessDesc: businessDesc.text,
      businessAddress: businessAddress.text,
      teamSize: teamSize,
      logo: logo,
      latitude: latLng?.latitude,
      longitude: latLng?.longitude,
      images: imgUrl,
      selectedCat: selectedCat,
      intervalList: intervalList,
      selectedCatName: selectedCatName,
      serviceNameList: [],
    );
    if (isEdit) {
      userModel?.update(
        DatabaseKey.businessData,
        (value) => businessModel.toJson(),
      );
    } else {
      userModel?.addAll({
        DatabaseKey.businessData: businessModel.toJson(),
      });
    }
    Pref.setString(Pref.userData, jsonEncode(userModel));
    userModel.toString().print;

    await AddGetVendorData.updateBusinessDetail(
      businessModel,
      userData?.id ?? "",
    ).then((value) {
      Loader.dismiss();
      if (value) {
        user = UserModel.fromMap(userModel!);
        if (isEdit) {
          Get.back();
        } else {
          Get.offAllNamed(AppRoutes.dashboardScreen);
        }
      } else {
        showSnackBar(
          "Unable to ${isEdit ? "update" : "add"} your business details",
        );
      }
    });
  }

  Future<void> assignData() async {
    String userData = await Pref.getString(Pref.userData);
    user = UserModel.fromMap(jsonDecode(userData));
    final businessData = user?.businessData;
    businessName.text = businessData?.businessName ?? "";
    businessDesc.text = businessData?.businessDesc ?? "";
    businessAddress.text = businessData?.businessAddress ?? "";
    // latLng = LatLng(
    //   businessData?.latitude ?? 21.1702,
    //   businessData?.longitude ?? 72.8311,
    // );
    teamSize = businessData?.teamSize;
    businessLogo = businessData?.logo;
    businessImgList = businessData?.images ?? [];
    if (businessData?.intervalList != null) {
      intervalList = businessData!.intervalList;
    } else {
      for (var element in dummyInterval) {
        intervalList.add(element);
      }
    }
    update();
  }

  @override
  void onInit() async {
    for (var element in dummyInterval) {
      intervalList.add(element);
    }
    addTime();
    String userData = await Pref.getString(Pref.userData);
    user = UserModel.fromMap(jsonDecode(userData));
    // assignData();
    if (isCatDataLoad) {
      getCategory();
      selectedCat = user?.businessData?.selectedCat ?? [];
    }
    super.onInit();
  }
}

List<IntervalModel> dummyInterval = [
  IntervalModel(
    day: "Monday",
    data: DayDatModel(
      startTime: "10:00 AM",
      endTime: "07:00 PM",
      breakList: [],
    ),
  ),
  IntervalModel(
    day: "Tuesday",
    data: DayDatModel(
      startTime: "10:00 AM",
      endTime: "07:00 PM",
      breakList: [],
    ),
  ),
  IntervalModel(
    day: "Wednesday",
    data: DayDatModel(
      startTime: "10:00 AM",
      endTime: "07:00 PM",
      breakList: [],
    ),
  ),
  IntervalModel(
    day: "Thursday",
    data: DayDatModel(
      startTime: "10:00 AM",
      endTime: "07:00 PM",
      breakList: [],
    ),
  ),
  IntervalModel(
    day: "Friday",
    data: DayDatModel(
      startTime: "10:00 AM",
      endTime: "07:00 PM",
      breakList: [],
    ),
  ),
  IntervalModel(day: "Saturday", isClosed: true),
  IntervalModel(day: "Sunday", isClosed: true),
];
