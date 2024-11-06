import 'dart:convert';

import 'package:crypt/crypt.dart';
import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/app/utils/loading.dart';

import '../../../backend/authentication.dart';
import '../../../data_models/user_model.dart';
import '../../helper/shared_pref.dart';

class AuthController extends GetxController {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController rePass = TextEditingController();
  TextEditingController confPass = TextEditingController();
  TextEditingController otp = TextEditingController();

  bool obscureText = true;
  bool isRegister = false;
  bool reObscureText = true;
  Timer? timer;
  int otpTime = 60;
  bool isLoad = false;
  UserModel? user;

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
            Pref.setString(Pref.emailKey, response.data!.email);
            Get.offAllNamed(AppRoutes.dashboardScreen);
          } else {
            showSnackBar(AppStrings.enteredEmailGoogle);
          }
        } else {
          showSnackBar(AppStrings.userNot);
        }
      }
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
        name: name.text,
        mobile: mobile.text,
        isLoad: RxBool(false),
        password: Crypt.sha256(pass.text).toString(),
      );
      await AuthenticationApiClass.verifyOtp(
        data,
        otp.text,
        isPass: !isRegister,
      ).then(
        (value) {
          if (value.$1) {
            if (isRegister) {
              Pref.setString(Pref.userData, data.toString());
              Pref.setString(Pref.emailKey, data.email);
            }
            if (timer != null) {
              timer!.cancel();
            }
            otpTime = 0;
            isRegister
                ? Get.offAllNamed(AppRoutes.dashboardScreen)
                : Get.toNamed(AppRoutes.resetPassScreen);
            update();
          } else {
            showSnackBar("Invalid OTP");
          }
        },
      );
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

  Future<void> signInWithGoogle() async {
    Loader.show();
    UserModel? data = await AuthenticationApiClass.signInWithGoogle();
    if (data != null) {
      "--->>> encrypted user ${data.toString()}".print;
      Pref.setString(Pref.userData, data.toString());
      Pref.setString(Pref.emailKey, data.email);
      Get.offAllNamed(AppRoutes.dashboardScreen);
    }
    Loader.dismiss();
  }

  Future<void> sendOtpForRegister() async {
    if (name.text.isEmpty) {
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

  Future<void> logout() async {
    Loader.show();
    String userData = await Pref.getString(Pref.userData);
    if (UserModel.fromMap(jsonDecode(userData)).isGoogle) {
      await AuthenticationApiClass.signOutFromGoogle();
    }
    await Pref.clearAlData();
    Loader.dismiss();
    Get.offAllNamed(AppRoutes.loginScreen);
  }
}
