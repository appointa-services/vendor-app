import 'package:salon_user/app/helper/shared_pref.dart';
import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/app/utils/loading.dart';
import 'package:salon_user/backend/admin_backend/get_admin_data.dart';
import 'package:salon_user/backend/admin_backend/get_vendor_data.dart';
import 'package:salon_user/data_models/booking_model.dart';
import 'package:salon_user/data_models/user_model.dart';

import '../../../data_models/vendor_data_models.dart';

class AdminController extends GetxController {
  List<CategoryModel> categoryList = [];
  List<UserModel> userList = [];
  List<UserModel> vendorList = [];
  List<BookingModel> bookingList = [];

  Future<void> getCategoryData() async {
    Loader.show();
    categoryList = await GetVendorData.getCategoryData();
    update();
    Loader.dismiss();
  }

  Future<void> getVendorData() async {
    Loader.show();
    vendorList = await GetAdminData.getVendorNUser(false);
    update();
    Loader.dismiss();
  }

  Future<void> getUserData() async {
    Loader.show();
    userList = await GetAdminData.getVendorNUser(true);
    update();
    Loader.dismiss();
  }

  Future<void> getBookingData() async {
    Loader.show();
    bookingList = await GetAdminData.getBooking();
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

  Future<void> getAllData() async {
    getCategoryData();
    getUserData();
    getVendorData();
    getBookingData();
  }

  RxString selectedTime = AppStrings.today.obs;
  RxString selectedType = AppStrings.byVendor.obs;

  /// for filter we need start date and end date in millisecond approach
  int startDate = DateTime.now()
      .subtract(Duration(hours: DateTime.now().hour))
      .millisecondsSinceEpoch;
  int endDate = DateTime.now()
      .add(Duration(hours: 24 - DateTime.now().hour))
      .millisecondsSinceEpoch;

  RxInt totalRevenue = 0.obs;

  RxList<ByVendorModel> byEmpList = <ByVendorModel>[].obs;
  RxList<ByServiceModel> bySerList = <ByServiceModel>[].obs;

  /// get employee data and filter data
  void assignEmpData() {
    byEmpList.clear();
    for (var data in vendorList) {
      var newBookingList = getFilterBooking(data.id ?? "");
      if (newBookingList
          .where((element) => element.vendorId == data.id)
          .isNotEmpty) {
        /// get employee data based on completed booking
        ByVendorModel byEmployeeModel = ByVendorModel(
          vendorName: data.businessData?.businessName ?? "",
          employeeImg: data.businessData?.images.firstOrNull,
          totalAppointment: newBookingList
              .where((element) => element.vendorId == data.id)
              .length
              .toString(),
          totalPrice: newBookingList
              .where((element) => element.vendorId == data.id)
              .map((e) => int.parse(e.finalPrice))
              .reduce((value, element) => value + element),
        );
        byEmpList.add(byEmployeeModel);
      }
    }

    /// find total revenue
    if (byEmpList.isNotEmpty) {
      totalRevenue.value =
          byEmpList.map((element) => element.totalPrice).reduce(
                (previousValue, element) => previousValue + element,
              );
    } else {
      totalRevenue.value = 0;
    }
    update();
  }

  /// get booking according to date and service and employee id
  List<BookingModel> getFilterBooking(
    String? id, {
    bool isService = false,
  }) {
    List<BookingModel> filterBookingList = [];
    for (var element in bookingList) {
      if (

          /// first condition is needed for time filtrating and if
          /// time is upcoming then we doesn't need to apply
          /// time filter or condition
          ((element.orderDate >= startDate && element.orderDate <= endDate) ||
                  selectedTime.value == AppStrings.upcoming) &&

              /// second condition is for booking service list
              /// contain selected service id if it's service
              /// and if it is employee then just check employee id
              (id == null || element.vendorId == id) &&

              /// last is for check booking status
              element.status ==
                  (selectedTime.value == AppStrings.upcoming
                      ? AppStrings.upcoming
                      : AppStrings.completed)) {
        filterBookingList.add(element);
      }
    }
    return filterBookingList;
  }

  /// today start date in millisecond approach
  int todayStart = DateTime.now()
      .subtract(Duration(hours: DateTime.now().hour))
      .millisecondsSinceEpoch;

  /// change start and end date according to tab selected for apply filter
  void changeDate(String tab) {
    "-->> selected tab ${selectedTime.value}".print;
    selectedTime.value = tab;
    if (tab == AppStrings.today) {
      startDate = todayStart;
      endDate = startDate + 86400000;
    } else if (tab == AppStrings.weekly) {
      endDate = todayStart;
      startDate = endDate - (86400000 * 7);
    } else if (tab == AppStrings.monthly) {
      endDate = todayStart;
      startDate = endDate - (86400000 * 30);
    } else if (tab == AppStrings.yearly) {
      endDate = todayStart;
      startDate = endDate - (86400000 * 365);
    }
    "-->> start time end time $startDate -- $endDate".print;
    assignEmpData();
  }

  @override
  void onInit() async {
    await getAllData();
    super.onInit();
  }
}

class ByVendorModel {
  final String vendorName;
  final String employeeImg;
  final String totalAppointment;
  final int totalPrice;

  ByVendorModel({
    required this.vendorName,
    required this.employeeImg,
    required this.totalAppointment,
    required this.totalPrice,
  });
}

class ByServiceModel {
  final String serviceName;
  final String totalAppointment;
  final int totalPrice;

  ByServiceModel({
    required this.serviceName,
    required this.totalAppointment,
    required this.totalPrice,
  });
}
