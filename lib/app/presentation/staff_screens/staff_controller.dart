import 'dart:convert';

import 'package:salon_user/app/common_widgets/upload_img_dialog.dart';
import 'package:salon_user/app/helper/shared_pref.dart';
import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/app/utils/loading.dart';
import 'package:salon_user/backend/database_key.dart';
import 'package:salon_user/data_models/vendor_data_models.dart';

import '../../../backend/admin_backend/add_get_vendor_data.dart';
import '../../../data_models/user_model.dart';

class StaffController extends GetxController {
  UserModel? user;
  TextEditingController fName = TextEditingController();
  TextEditingController lName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController addPhone = TextEditingController();
  TextEditingController address = TextEditingController();
  DateTime? dob;
  DateTime? joinDate;
  bool isOnLeave = false;
  List selectedService = [];
  String? image;
  String selectedTab = AppStrings.personalDetail;
  List<StaffModel> staffList = [];
  StaffModel? selectedStaff;
  int? index;
  String? id;
  bool isStaffLoad = false;

  Future<void> getStaffList() async {
    staffList.clear();
    isStaffLoad = true;
    update();
    await AddGetVendorData.getStafList(user?.id ?? "").then((value) {
      if (value != null) {
        staffList.addAll(value);
      } else {
        showSnackBar("Unable to get your staff member");
      }
    });
    isStaffLoad = false;
    update();
  }

  Future<void> addStaffMember() async {
    if (image == null || image!.isEmpty) {
      showSnackBar("Please select employee image");
    } else if (fName.text.isEmpty) {
      showSnackBar("Please enter employee first name");
    } else if (lName.text.isEmpty) {
      showSnackBar("Please enter employee last name");
    } else if (email.text.isEmpty) {
      showSnackBar("Please enter employee email address");
    } else if (!emailValid(email.text)) {
      showSnackBar("Please enter valid email address");
    } else if (phone.text.isEmpty) {
      showSnackBar("Please enter employee phone number");
    } else if (!mobileValid(phone.text)) {
      showSnackBar("Please enter valid phone number");
    } else if (address.text.isEmpty) {
      showSnackBar("Please enter employee address");
    } else if (dob == null) {
      showSnackBar("Please enter employee date of birth");
    } else if (selectedTab == AppStrings.personalDetail &&
        selectedService.isEmpty) {
      selectedTab = AppStrings.services;
      update();
    } else if (selectedTab == AppStrings.services && selectedService.isEmpty) {
      showSnackBar("Please select at least one service");
    } else {
      Loader.show();

      /// add service
      if (image != null && !image!.contains("https")) {
        showUploadImgDialog(
          img: [image],
          context: Get.context!,
          path:
              "${DatabaseKey.vendor}/${user!.id}/${DatabaseKey.staff}/${index ?? staffList.length}",
          onBack: (_) async {
            addUpdateStaffMemberFunc(img: _.first);
          },
        );
      } else {
        addUpdateStaffMemberFunc(
          img: image!,
          isBack: false,
        );
      }
      Loader.dismiss();
    }
  }

  Future<void> addUpdateStaffMemberFunc({
    required String img,
    bool isBack = true,
  }) async {
    if (isBack) {
      Get.back();
    }
    Loader.show();
    StaffModel staffModel = StaffModel(
      id: id,
      vendorId: user?.id ?? "",
      firstName: fName.text,
      lastName: lName.text,
      email: email.text,
      mobile: phone.text,
      additionalMobile: addPhone.text,
      address: address.text,
      dob: dob?.toString() ?? "",
      image: img,
      serviceList: selectedService,
    );
    await AddGetVendorData.addStaffMember(staffModel).then((value) {
      if (value.$1) {
        if (value.$2 != null) {
          "-->> staff model response ${value.$2?.toJson()}".print();
          staffList.add(value.$2!);
        } else {
          staffList.removeAt(index!);
          staffList.insert(index!, staffModel);
        }
        update();
        Get.back();
      } else {
        showSnackBar(
          "Unable to ${value.$2 != null ? "add" : "update"}"
          " staff member, Please try again later",
        );
      }
    });
    Loader.dismiss();
  }

  void fillData({StaffModel? data, int? index}) {
    id = data?.id;
    this.index = index;
    image = data?.image;
    fName.text = data?.firstName ?? "";
    lName.text = data?.lastName ?? "";
    phone.text = data?.mobile ?? "";
    addPhone.text = data?.additionalMobile ?? "";
    email.text = data?.email ?? "";
    address.text = data?.address ?? "";
    dob = data?.dob == null ? null : DateTime.parse(data!.dob);
    selectedService = data?.serviceList ?? [];
    selectedTab = AppStrings.personalDetail;
  }

  @override
  void onInit() async {
    String userData = await Pref.getString(Pref.userData);
    user = UserModel.fromMap(jsonDecode(userData));
    getStaffList();
    super.onInit();
  }
}
