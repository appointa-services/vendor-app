import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:salon_user/app/utils/all_dependency.dart';

class Loader {
  static init() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.circle
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 40
      ..radius = 10.0
      ..backgroundColor = AppColor.primaryColor
      ..userInteractions = true
      ..dismissOnTap = false;
  }

  static show() {
    init();
    EasyLoading.show();
  }

  static dismiss() {
    EasyLoading.dismiss();
  }
}
