import 'dart:convert';

import 'package:salon_user/app/presentation/dashboard/dashboard_controller.dart';
import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/app/utils/loading.dart';
import 'package:salon_user/backend/admin_backend/add_get_vendor_data.dart';
import 'package:salon_user/backend/database_key.dart';
import 'package:salon_user/data_models/user_model.dart';
import 'package:salon_user/data_models/vendor_data_models.dart';

import '../../common_widgets/upload_img_dialog.dart';
import '../../helper/shared_pref.dart';

class ServiceController extends GetxController {
  DashboardController controller = Get.find();
  UserModel? user;
  TextEditingController serviceName = TextEditingController();
  TextEditingController servicePrice = TextEditingController();
  int? serviceTime;
  TextEditingController serviceDesc = TextEditingController();
  List<String> serviceImgList = [];
  ServiceModel? selectedService;
  int? index;
  String? selectedCatId;

  Future<void> addService() async {
    if (selectedCatId == null) {
      showSnackBar("Please select service category");
    } else if (serviceName.text.isEmpty) {
      showSnackBar("Please enter service name");
    } else if (servicePrice.text.isEmpty) {
      showSnackBar("Please enter service price");
    } else if (serviceTime == null) {
      showSnackBar("Please enter estimated service completion time");
    } else if (serviceDesc.text.isEmpty) {
      showSnackBar("Please enter about your service");
    } else if (serviceImgList.isEmpty) {
      showSnackBar("Please select service images");
    } else {
      /// add all image
      List totalImgList = [];
      for (var element in serviceImgList) {
        totalImgList.add(element);
      }

      /// add filter to all images which are url and which are new one
      List uploadImgList = totalImgList
          .where((element) => !(element as String).contains("https"))
          .toList();

      /// add service
      if (uploadImgList.isNotEmpty) {
        showUploadImgDialog(
          img: totalImgList,
          context: Get.context!,
          path: "${DatabaseKey.vendor}/${user!.id}/${DatabaseKey.service}/",
          onBack: (_) async {
            addUpdateServiceFunc(imgList: _);
          },
        );
      } else {
        addUpdateServiceFunc(
          imgList: totalImgList,
          isBack: false,
        );
      }
    }
  }

  Future<void> addUpdateServiceFunc({
    required List imgList,
    bool isBack = true,
  }) async {
    if (isBack) {
      Get.back();
    }
    Loader.show();
    ServiceModel serviceData = ServiceModel(
      vendorId: user?.id ?? "",
      serviceName: serviceName.text,
      categoryId: selectedCatId ?? "",
      price: servicePrice.text,
      serviceTime: serviceTime ?? 0,
      aboutService: serviceDesc.text,
      images: imgList,
      id: selectedService?.id,
    );
    await AddGetVendorData.addService(serviceData).then((value) async {
      if (value.$1) {
        if (value.$2 != null) {
          controller.serviceList.add(value.$2!);
        } else {
          controller.serviceList.removeAt(index!);
          controller.serviceList.insert(index!, serviceData);
        }
        await AddGetVendorData.updateServiceName(
          controller.serviceList.map((e) => e.serviceName).toList(),
          user?.id ?? "",
        );
        update();
        Get.back();
      } else {
        showSnackBar(
          "Unable to ${value.$2 != null ? "add" : "update"}"
          " service, Please try again later",
        );
      }
    });
    Loader.dismiss();
  }

  clearData() {
    serviceImgList.clear();
    serviceDesc.clear();
    serviceName.clear();
    servicePrice.clear();
    serviceTime = null;
    selectedService = null;
    selectedCatId = null;
  }

  assignData(int index) {
    selectedService = controller.serviceList[index];
    this.index = index;
    serviceImgList.clear();
    for (var element in selectedService!.images) {
      serviceImgList.add(element);
    }
    serviceDesc.text = selectedService!.aboutService;
    serviceName.text = selectedService!.serviceName;
    servicePrice.text = selectedService!.price;
    serviceTime = selectedService!.serviceTime;
    AuthController authController = Get.find<AuthController>();
    "-->> ${authController.user?.businessData?.selectedCat} - ${selectedService!.categoryId} -- $selectedCatId"
        .print;
    if (authController.user?.businessData?.selectedCat
            .contains(selectedService!.categoryId) ??
        false) {
      selectedCatId = selectedService!.categoryId;
    }
  }

  RxList<ServiceModel> filterServiceList = <ServiceModel>[].obs;
  RxBool isSearch = false.obs;

  void filterUser(String search) {
    List<ServiceModel> staffList = Get.find<DashboardController>().serviceList;
    filterServiceList.clear();
    filterServiceList.addAll(staffList);
    if (search.isNotEmpty) {
      filterServiceList.clear();
      for (var data in staffList) {
        if ((data.serviceName.toLowerCase().contains(search.toLowerCase()) ||
                data.price.contains(search.toLowerCase()) ||
                data.serviceTime.toString().contains(search.toLowerCase())) &&
            !filterServiceList.any((element) => element.id == data.id)) {
          filterServiceList.add(data);
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
