import 'package:salon_user/data_models/booking_model.dart';
import 'package:salon_user/data_models/vendor_data_models.dart';
import '../../utils/all_dependency.dart';

class SellsController extends GetxController {
  RxString selectedTime = AppStrings.today.obs;
  RxString selectedType = AppStrings.byEmployee.obs;

  /// for filter we need start date and end date in millisecond approach
  int startDate = DateTime.now()
      .subtract(Duration(hours: DateTime.now().hour))
      .millisecondsSinceEpoch;
  int endDate = DateTime.now()
      .add(Duration(hours: 24 - DateTime.now().hour))
      .millisecondsSinceEpoch;

  RxInt totalRevenue = 0.obs;
  HomeController controller = Get.find();

  RxList<ByEmployeeModel> byEmpList = <ByEmployeeModel>[].obs;
  RxList<ByServiceModel> bySerList = <ByServiceModel>[].obs;

  /// get employee data and filter data
  void assignEmpData(List<StaffModel> list) {
    byEmpList.clear();
    "-->>> staff list length == ${list.length}".print;
    for (var data in list) {
      List<BookingModel> bookingList = getFilterBooking(
        controller.bookingList,
        data.id ?? "",
      );
      if (bookingList.isNotEmpty) {
        /// get employee data based on completed booking
        ByEmployeeModel byEmployeeModel = ByEmployeeModel(
          employeeName: "${data.firstName} ${data.lastName}",
          employeeImg: data.image,
          assignService: data.serviceList.length.toString(),
          totalAppointment: bookingList.length.toString(),
          totalPrice: bookingList
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
    }
    update();
  }

  /// get service data and filter data
  void assignSerData(List<ServiceModel> list) {
    bySerList.clear();
    for (var data in list) {
      List<BookingModel> bookingList = getFilterBooking(
        controller.bookingList,
        data.id ?? "",
        isService: true,
      );
      if (bookingList.isNotEmpty) {
        /// get employee data based on completed booking
        ByServiceModel byServiceModel = ByServiceModel(
          serviceName: data.serviceName,
          totalAppointment: bookingList.length.toString(),
          totalPrice: bookingList.map((e) {
            /// get index from service list for current service
            int index = e.serviceList.indexWhere(
              (element) => element.id == data.id,
            );

            /// check if service have some discount or not
            /// if yes we need to subtract (discount / services.length)
            /// from price
            int subtractVal = 0;
            if (e.discountData != null) {
              subtractVal = getDividedValue(
                int.parse(e.discountData!.discountPrice),
                e.serviceList.length,
                isLast: index == e.serviceList.length - 1,
              );
            }
            return int.parse(
                  e.serviceList
                      .firstWhere((element) => element.id == data.id)
                      .price,
                ) -
                subtractVal;
          })

              /// after getting all service price let's have sum
              .reduce((value, element) => value + element),
        );
        bySerList.add(byServiceModel);
      }
    }

    /// find total revenue
    if (bySerList.isNotEmpty) {
      totalRevenue.value =
          bySerList.map((element) => element.totalPrice).reduce(
                (previousValue, element) => previousValue + element,
              );
    }
    update();
  }

  /// get booking according to date and service and employee id
  List<BookingModel> getFilterBooking(
    List<BookingModel> bookingList,
    String id, {
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
              (isService
                  ? element.serviceList.any((element) => element.id == id)
                  : element.employeeId == id) &&

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
    assignEmpData(Get.find<DashboardController>().staffList);
    assignSerData(Get.find<DashboardController>().serviceList);
  }
}

class ByEmployeeModel {
  final String employeeName;
  final String employeeImg;
  final String assignService;
  final String totalAppointment;
  final int totalPrice;

  ByEmployeeModel({
    required this.employeeName,
    required this.employeeImg,
    required this.assignService,
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
