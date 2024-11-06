import 'dart:convert';

import 'package:salon_user/app/common_widgets/upload_img_dialog.dart';
import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/app/utils/loading.dart';
import 'package:salon_user/backend/database_key.dart';
import 'package:salon_user/data_models/vendor_data_models.dart';

import '../../../backend/admin_backend/add_get_vendor_data.dart';
import '../../../data_models/user_model.dart';
import '../../helper/shared_pref.dart';

class StaffController extends GetxController {
  DashboardController controller = Get.find();
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
  List<(String, String)> selectedService = [];
  String? image;
  String selectedTab = AppStrings.personalDetail;
  StaffModel? selectedStaff;
  int? index;

  String? id;

  String getPrice(ServiceModel? data) {
    EmployeePriceModel? priceData = data?.employeePriceData?.firstWhere(
      (element) => element.employeeId == id,
      orElse: () => EmployeePriceModel(
        employeeId: null,
        price: null,
      ),
    );
    String price = selectedService
        .firstWhere((element) => element.$1 == data?.id,
            orElse: () => ("", priceData?.price ?? ""))
        .$2;
    return price.isEmpty ? priceData?.price ?? "" : price;
  }

  void selectService(
      DashboardController serviceController, ServiceModel? data) {
    if (data == null) {
      if (selectedService.length < serviceController.serviceList.length) {
        selectedService = List.generate(
          serviceController.serviceList.length,
          (ind) => (
            serviceController.serviceList[ind].id ?? "",
            serviceController.serviceList[ind].price,
          ),
        );
      } else {
        selectedService.clear();
      }
    } else {
      if (selectedService.any((element) => element.$1 == data.id)) {
        selectedService.removeWhere((element) => element.$1 == data.id);
      } else {
        addPrice((data.id ?? "", data.price));
      }
    }
    update();
  }

  void addPrice((String, String) data) {
    selectedService.removeWhere((element) {
      return element.$1 == data.$1;
    });
    selectedService.add(data);
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
          path: "${DatabaseKey.vendor}/${user!.id}/${DatabaseKey.staff}"
              "/${index ?? controller.staffList.length}",
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
      serviceList: selectedService.map((e) => e.$1).toList(),
    );
    await AddGetVendorData.addStaffMember(staffModel).then((value) async {
      if (value.$1) {
        for (var data in selectedService) {
          await AddGetVendorData.updateServicePrice(
            serviceId: data.$1,
            employeeId: value.$2?.id ?? id ?? "",
            price: getPrice(
              Get.find<DashboardController>()
                  .serviceList
                  .firstWhere((element) => element.id == data.$1),
            ),
          );
        }
        if (value.$2 != null) {
          controller.staffList.add(value.$2!);
        } else {
          controller.staffList.removeAt(index!);
          controller.staffList.insert(index!, staffModel);
        }
        controller.update();
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
    selectedService = (data?.serviceList ?? [])
        .map(
          (e) => (e.toString(), ""),
        )
        .toList();
    selectedTab = AppStrings.personalDetail;
  }

  RxBool isSearch = false.obs;
  RxList<StaffModel> filterStaffList = <StaffModel>[].obs;

  void filterUser(String search) {
    List<StaffModel> staffList = Get.find<DashboardController>().staffList;
    filterStaffList.clear();
    filterStaffList.addAll(staffList);
    if (search.isNotEmpty) {
      filterStaffList.clear();
      for (var data in staffList) {
        if ((data.firstName.toLowerCase().contains(search.toLowerCase()) ||
                data.lastName.toLowerCase().contains(search.toLowerCase())) &&
            !filterStaffList.any((element) => element.id == data.id)) {
          filterStaffList.add(data);
        }
      }
    }
    update();
  }

  @override
  void onInit() async {
    String userData = await Pref.getString(Pref.userData);
    user = UserModel.fromMap(jsonDecode(userData));
    super.onInit();
  }
}
