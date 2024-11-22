import 'dart:convert';

import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/backend/admin_backend/get_vendor_data.dart';
import '../../../data_models/user_model.dart';
import '../../../data_models/vendor_data_models.dart';
import '../../helper/shared_pref.dart';

class DashboardController extends GetxController {
  UserModel? user;
  int screenIndex = 0;
  HomeController homeController = Get.put(HomeController());
  SellsController sellsController = Get.put(SellsController());

  List<Widget> screenList = [
    const HomeScreen(),
    const ClientListingScreen(),
    const SellsScreen(),
    const SettingScreen(),
  ];

  /// get staff list
  RxBool isStaffLoad = false.obs;
  RxList<StaffModel> staffList = <StaffModel>[].obs;

  Future<void> getStaffList() async {
    staffList.clear();
    isStaffLoad.value = true;
    update();
    await GetVendorData.getStaffList(user?.id ?? "").then((value) {
      if (value != null) {
        staffList.addAll(value);
        sellsController.assignEmpData(value);
      } else {
        showSnackBar("Unable to get your staff member");
      }
    });
    isStaffLoad.value = false;
    update();
  }

  /// get service list
  RxList<ServiceModel> serviceList = <ServiceModel>[].obs;
  RxBool isServiceLoad = false.obs;

  Future<void> getServiceList() async {
    serviceList.clear();
    isServiceLoad.value = true;
    update();
    await GetVendorData.getServiceList(user?.id ?? "").then((value) {
      if (value != null) {
        serviceList.addAll(value);
        sellsController.assignSerData(value);
      } else {
        showSnackBar("Unable to get your services");
      }
    });
    isServiceLoad.value = false;
    update();
  }

  /// get user data
  RxList<UserModel> userList = <UserModel>[].obs;
  RxBool isUserLoad = false.obs;

  Future<void> getUserList() async {
    isUserLoad.value = true;
    userList.value = await GetVendorData.getUserId(user?.id ?? "");
    isUserLoad.value = false;
    update();
  }

  getAllData() async {
      getStaffList();
    await homeController.getBooking().then((value) {
      getServiceList();
      getUserList();
    });
  }

  @override
  void onInit() async {
    String userData = await Pref.getString(Pref.userData);
    user = UserModel.fromMap(jsonDecode(userData));
    await getAllData();
    super.onInit();
  }
}
