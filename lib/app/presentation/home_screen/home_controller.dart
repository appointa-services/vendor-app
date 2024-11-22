import 'dart:convert';

import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/data_models/vendor_data_models.dart';

import '../../../backend/admin_backend/get_vendor_data.dart';
import '../../../data_models/booking_model.dart';
import '../../../data_models/user_model.dart';
import '../../helper/shared_pref.dart';
import '../../utils/loading.dart';

class HomeController extends GetxController {
  UserModel? user;
  bool isCalenderOpen = false;
  String selectedCat = "";
  RxString selectedEmp = AppStrings.all.obs;
  RxString selectedEmpId = "".obs;
  DateTime focusedDay = DateTime.now();
  String headerText = "Today";
  bool isPaymentScreen = false;
  String paymentOption = "";

  /// get booking data
  RxList<BookingModel> bookingList = <BookingModel>[].obs;
  RxList<BookingModel> filterBookingList = <BookingModel>[].obs;
  RxBool isBookingLoad = false.obs;

  /// get booking data
  Future<void> getBooking() async {
    isBookingLoad.value = true;
    bookingList.value = await GetVendorData.getBooking(
      user?.id ?? "",
    );
    getFilterBooking();
    isBookingLoad.value = false;
    update();
  }

  /// get booking according to date
  void getFilterBooking() {
    int startDate = DateTime(
      focusedDay.year,
      focusedDay.month,
      focusedDay.day,
    ).millisecondsSinceEpoch;

    /// 1 day = 86400000 millisecond
    int endDate = startDate + 86400000;

    filterBookingList.clear();
    for (var element in bookingList) {
      if (element.orderDate >= startDate && element.orderDate <= endDate) {
        if (selectedEmp.value != AppStrings.all) {
          if (element.employeeId == selectedEmpId.value) {
            filterBookingList.add(element);
          }
        } else {
          filterBookingList.add(element);
        }
      }
    }
    update();
  }

  Future<void> changeBookingStatus(
    String bookingId,
    String status, {
    String? method,
  }) async {
    Loader.show();
    await GetVendorData.updateStatus(bookingId, status, method).then(
      (value) {
        if (value) {
          bookingList.firstWhere(
            (element) => element.bookingId == bookingId,
          )
            ..status = status
            ..isCancelledUser = status != AppStrings.cancelled
            ..paymentMethod = method;
          getFilterBooking();
          Get.back();
          Get.back();
          showSnackBar(
            "Booking cancelled successfully",
            color: AppColor.primaryColor,
          );
          update();
        } else {
          showSnackBar("Unable to $status booking, please try again latter");
        }
      },
    );
    Loader.dismiss();
  }

  Future<void> addBooking({
    required StaffModel staff,
    required ServiceModel service,
    required UserModel user,
    required DateTime date,
    required String time,
    required String price,
  }) async {
    DateTime slot = DateFormat("hh:mm a").parse(time);

    BookingModel bookingModel = BookingModel(
      employeeId: staff.id ?? "",
      employeeName: "${staff.firstName} ${staff.lastName}",
      employeeImg: staff.image,
      vendorId: this.user?.id ?? "",
      businessData: BookingVendorModel.fromJson(
        this.user!.businessData!.toJson(),
      ),
      userId: user.id ?? "",
      userName: user.name,
      userImg: user.image ?? "",
      duration: service.serviceTime,
      finalPrice: price,
      serviceList: [
        BookingServiceModel.fromJson(
          service.toJson(),
          employeeId: staff.id,
        )
      ].toList(),
      orderDate: DateTime(
        date.year,
        date.month,
        date.day,
        slot.hour,
        slot.minute,
      ).millisecondsSinceEpoch,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      status: AppStrings.upcoming,
      isBookUser: false,
    );
    Loader.show();
    if (await GetVendorData.addBooking(bookingModel)) {
      bookingList.add(bookingModel);
      getFilterBooking();
      Get.back();
      showSnackBar(
        "Service booked successfully",
        color: AppColor.primaryColor,
      );
    } else {
      showSnackBar(
        "Unable to book your service, please try again letter",
      );
    }
    Loader.dismiss();
  }

  @override
  void onInit() async {
    String userData = await Pref.getString(Pref.userData);
    user = UserModel.fromMap(jsonDecode(userData));
    super.onInit();
  }
}
