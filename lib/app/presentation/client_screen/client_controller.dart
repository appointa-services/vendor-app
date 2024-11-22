import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/app/utils/loading.dart';
import 'package:salon_user/backend/admin_backend/get_vendor_data.dart';
import 'package:salon_user/data_models/booking_model.dart';

import '../../../data_models/user_model.dart';

class ClientController extends GetxController {
  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController mobile = TextEditingController();
  String? imgUrl;

  RxBool isSearch = false.obs;
  RxBool isEdit = false.obs;
  RxList<UserModel> filterUserList = <UserModel>[].obs;
  RxList<BookingModel> bookingList = <BookingModel>[].obs;
  DashboardController controller = Get.find();
  late UserModel selectedUser;

  void filterUser(String search) {
    List<UserModel> userList = Get.find<DashboardController>().userList;
    filterUserList.clear();
    filterUserList.addAll(userList);
    if (search.isNotEmpty) {
      filterUserList.clear();
      for (var data in userList) {
        if ((data.name.toLowerCase().contains(search.toLowerCase()) ||
            data.mobile.contains(search.toLowerCase())) &&
            !filterUserList.any((element) => element.id == data.id)) {
          filterUserList.add(data);
        }
      }
    }
    update();
  }

  /// get booking list by user id
  int totalUserRevenue = 0;

  void getBookingByUser() {
    bookingList.clear();
    Get.find<HomeController>().bookingList.forEach(
      (element) {
        if (element.userId == selectedUser.id) {
          bookingList.add(element);
          if (element.status == AppStrings.completed) {
            totalUserRevenue += int.parse(element.finalPrice);
          }
        }
      },
    );
    update();
  }

  Future<void> addUpdateUser() async {
    if (name.text.isEmpty) {
      showSnackBar("Please enter client full name");
    } else if (mobile.text.isEmpty) {
      showSnackBar("Please enter client mobile number");
    } else if (!mobileValid(mobile.text)) {
      showSnackBar("Please enter valid mobile number");
    } else {
      Loader.show();
      UserModel user = UserModel(
        mobile: mobile.text,
        name: name.text,
        email: email.text,
        id: isEdit.value ? selectedUser.id : null,
        isUserByVendor: true,
      );
      await GetVendorData.addUpdateUser(
        user,
        controller.user?.id ?? "",
        isAdd: !isEdit.value,
      ).then((value) {
        if (value != null) {
          int index = controller.userList
              .indexWhere((element) => element.id == value.id);
          if (index == -1) {
            controller
              ..userList.insert(0, value)
              ..update();
          } else {
            controller
              ..userList.removeAt(index)
              ..userList.insert(index, value)
              ..update();
          }
          if (isEdit.value) selectedUser = user;
          update();
          Get.back();
          mobile.clear();
          name.clear();
          email.clear();
        } else {
          showSnackBar("Unable to ${isEdit.value ? "Update" : "add"} user");
        }
      });
      Loader.dismiss();
    }
  }
}
