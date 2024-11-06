import 'dart:convert';

import 'package:salon_user/app/helper/shared_pref.dart';
import 'package:salon_user/app/utils/all_dependency.dart';

import '../../../data_models/user_model.dart';

class DashboardController extends GetxController {
  UserModel? user;
  int screenIndex = 0;
  RxBool isBookingLoad = true.obs;
  List<Widget> screenList = [
    const HomeScreen(),
    const LocationScreen(),
    const BookingScreen(),
  ];

  @override
  void onInit() async {
    String userData = await Pref.getString(Pref.userData);
    user = UserModel.fromMap(jsonDecode(userData));
    super.onInit();
  }
}
