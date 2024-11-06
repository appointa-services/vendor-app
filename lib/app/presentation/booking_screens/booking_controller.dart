import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/backend/database_key.dart';
import 'package:salon_user/backend/get_home_data.dart';

import '../../../data_models/booking_model.dart';
import '../../utils/loading.dart';

class BookingController extends GetxController {
  RxString selectedBooking = AppStrings.upcoming.obs;
  RxBool isLoad = false.obs;
  RxList<BookingModel> bookingList = <BookingModel>[].obs;
  RxList<BookingModel> filteredBookingList = <BookingModel>[].obs;
  HomeController controller = Get.find();

  void changeStatus(String status) {
    selectedBooking.value = status;
    filteredBookingList.value =
        bookingList.where((p0) => p0.status == selectedBooking.value).toList();
    update();
  }

  Future<void> getBooking() async {
    isLoad.value = true;
    Loader.show();
    bookingList.value = await GetHomeData.getBooking(
      controller.user?.id ?? "",
      key: DatabaseKey.userId,
    );
    filteredBookingList.value =
        bookingList.where((p0) => p0.status == selectedBooking.value).toList();
    Get.find<DashboardController>()
      ..isBookingLoad.value = false
      ..update();
    isLoad.value = false;
    update();
    Loader.dismiss();
  }

  Future<void> changeBookingStatus(
    String bookingId, {
    bool isBackTwice = false,
  }) async {
    Loader.show();
    await GetHomeData.updateStatus(bookingId, AppStrings.cancelled).then(
      (value) {
        if (value) {
          bookingList
              .firstWhere(
                (element) => element.bookingId == bookingId,
              )
              .status = AppStrings.cancelled;
          filteredBookingList.value = bookingList
              .where((p0) => p0.status == selectedBooking.value)
              .toList();
          if (isBackTwice) Get.back();
          Get.back();
          showSnackBar(
            "Booking cancelled successfully",
            color: AppColor.primaryColor,
          );
          update();
        }
      },
    );
    Loader.dismiss();
  }
}
