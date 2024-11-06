import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/app/utils/loading.dart';
import 'package:salon_user/data_models/booking_model.dart';
import 'package:salon_user/data_models/user_model.dart';
import 'package:salon_user/data_models/vendor_data_models.dart';
import '../../../backend/get_home_data.dart';

class VendorNBookingController extends GetxController {
  VendorNBookingController({this.isBookingScreen = false});

  HomeController homeController = Get.find();
  bool isBookingScreen = false;
  int currentImg = 0;
  RxInt currentServiceImg = 0.obs;
  RxInt selectedSpecialist = (-1).obs;
  RxString selectedSpecialistId = ("").obs;
  List<String> selectedService = [];
  List<int> selectedServiceCat = [];
  int price = 0;
  int price2 = 0;
  int finalPrice = 0;
  DateTime? selectedDate;
  String selectedTime = "";
  TextEditingController coupon = TextEditingController();
  RxString couponCode = "".obs;

  RxList<ServiceModel> serviceList = <ServiceModel>[].obs;
  RxList<ServiceModel> filerServiceList = <ServiceModel>[].obs;
  RxBool isServiceLoad = false.obs;
  RxList<StaffModel> staffList = <StaffModel>[].obs;
  RxList<StaffModel> staffServiceList = <StaffModel>[].obs;
  RxBool isStaffLoad = false.obs;
  Rx<UserModel?> vendorData = Rx(null);
  Rx<int?> index = Rx(null);
  RxList<CategoryModel> categoryList = <CategoryModel>[].obs;

  void selectRemoveService(ServiceModel data) {
    String newPrice = getPriceFromEmployeePrice(data);
    int new1 = int.parse(newPrice.split(" - ").first.replaceAll("₹", ""));
    int new2 = int.parse(newPrice.split(" - ").last.replaceAll("₹", ""));
    if (selectedService.contains(data.id)) {
      price -= new1;
      price2 -= new2;
      selectedService.remove(data.id);
    } else {
      price += new1;
      price2 += new2;
      selectedService.add(data.id ?? "");
    }
    update();
  }

  getFinalPrice(String employeeId) {
    finalPrice = 0;
    if (employeeId.isNotEmpty) {
      for (var serviceId in selectedService) {
        ServiceModel serviceData =
            serviceList.firstWhere((element) => element.id == serviceId);
        if (serviceData.employeePriceData == null ||
            serviceData.employeePriceData!.isEmpty) {
          finalPrice += int.parse(serviceData.price);
        } else if (serviceData.employeePriceData!
            .any((element) => element.employeeId == employeeId)) {
          finalPrice += int.parse(serviceData.employeePriceData!
                  .firstWhere((element) => element.employeeId == employeeId)
                  .price ??
              serviceData.price);
        } else {
          finalPrice += int.parse(serviceData.price);
        }
      }
    }
  }

  String getEmployeeRate(ServiceModel data) {
    if (data.employeePriceData == null || data.employeePriceData!.isEmpty) {
      return data.price;
    } else {
      return data.employeePriceData
              ?.firstWhere(
                  (element) => element.employeeId == selectedSpecialistId.value)
              .price ??
          data.price;
    }
  }

  getCategory() {
    for (CategoryModel value in homeController.categoryList) {
      if (vendorData.value?.businessData?.selectedCat
              .any((element) => element == value.catId) ??
          false) {
        categoryList.add(value);
      }
    }
    update();
  }

  Future<void> getServiceList() async {
    serviceList.clear();
    isServiceLoad.value = true;
    update();
    await GetHomeData.getServiceList(vendorData.value?.id ?? "").then((value) {
      if (value != null) {
        serviceList.addAll(value);
        filerServiceList.addAll(value);
      } else {
        showSnackBar("Unable to get your services");
      }
    });
    isServiceLoad.value = false;
    update();
  }

  String getPriceFromEmployeePrice(ServiceModel serviceData) {
    if (serviceData.employeePriceData == null ||
        serviceData.employeePriceData!.isEmpty) {
      return "₹${serviceData.price}";
    } else {
      "-->>-- ${serviceData.employeePriceData!.length}".print;
      List<int> priceList = serviceData.employeePriceData!
          .map(
            (e) => int.parse(e.price ?? serviceData.price),
          )
          .toList();
      int maxPrice = priceList.reduce((a, b) => a > b ? a : b);
      int minPrice = priceList.reduce((a, b) => a > b ? b : a);
      if (maxPrice == minPrice) {
        return "₹$maxPrice";
      } else {
        return "₹$minPrice - ₹$maxPrice";
      }
    }
  }

  Future<void> getStaffList() async {
    staffList.clear();
    isStaffLoad.value = true;
    update();
    await GetHomeData.getStaffList(vendorData.value?.id ?? "").then((value) {
      if (value != null) {
        staffList.addAll(value);
      } else {
        showSnackBar("Unable to get your staff");
      }
    });
    isStaffLoad.value = false;
    update();
  }

  Future<void> addRemoveFav() async {
    vendorData.value?.isLoad.value = true;
    update();
    HomeController homeController = Get.find();
    if (index.value != null) {
      List<FavouriteModel> list =
          vendorData.value?.businessData?.favouriteList ?? [];
      int favIndex = list.indexWhere(
        (element) => element.id == homeController.user?.id,
      );
      await homeController.addRemoveFav(index.value!).then(
        (value) {
          if (value != null) {
            list.add(
              FavouriteModel(
                id: homeController.user?.id ?? "",
                key: value,
              ),
            );
          } else {
            list.removeAt(favIndex);
          }
        },
      );
    }
    vendorData.value?.isLoad.value = false;
    update();
  }

  RxList<BookingModel> employeeBooking = <BookingModel>[].obs;

  Future<void> getBooking({bool isRecheck = false}) async {
    Loader.show();
    employeeBooking.value =
        await GetHomeData.getBooking(selectedSpecialistId.value);
    getDate(isRecheck: isRecheck);
    update();
    Loader.dismiss();
  }

  Future<bool> finalSlotChecking() async {
    await getBooking(isRecheck: true).then(
      (value) => getTime(selectedDate!),
    );
    return timeList.contains(selectedTime);
  }

  Future<void> addBooking() async {
    if (await finalSlotChecking()) {
      StaffModel staffModel = staffList.firstWhere(
        (element) => element.id == selectedSpecialistId.value,
      );

      DateTime slot = DateFormat("hh:mm a").parse(selectedTime);

      BookingModel bookingModel = BookingModel(
        employeeId: selectedSpecialistId.value,
        employeeName: "${staffModel.firstName} ${staffModel.lastName}",
        employeeImg: staffModel.image,
        vendorId: vendorData.value?.id ?? "",
        discountData: couponCode.value.isNotEmpty ? DiscountModel(
          discountCode: couponCode.value,
          discount: "10",
          discountPrice: "${finalPrice ~/ 10}",
        ) : null,
        businessData: BookingVendorModel.fromJson(
          vendorData.value!.businessData!.toJson(),
        ),
        userId: homeController.user?.id ?? "",
        userName: homeController.user?.name ?? "",
        userImg: homeController.user?.image ?? "",
        duration: duration,
        finalPrice: "${finalPrice - (finalPrice ~/ 10)}",
        serviceList: selectedService.map(
          (e) {
            ServiceModel serviceModel =
                serviceList.firstWhere((element) => element.id == e);
            return BookingServiceModel.fromJson(
              serviceModel.toJson(),
              employeeId: selectedSpecialistId.value,
            );
          },
        ).toList(),
        orderDate: DateTime(
          selectedDate!.year,
          selectedDate!.month,
          selectedDate!.day,
          slot.hour,
          slot.minute,
        ).millisecondsSinceEpoch,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        status: AppStrings.upcoming,
      );
      Loader.show();
      if (await GetHomeData.addBooking(bookingModel)) {
        Get.put(DashboardController()).isBookingLoad.value = true;
        Get.offAll(const DashboardScreen());
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
    } else {
      Get.back();
      showSnackBar("Your slot hase been booked, Please select another slot");
    }
  }

  List<DateTime> dateList = [];

  void getDate({bool isRecheck = false}) {
    dateList.clear();
    for (int i = 0; i < 30; i++) {
      DateTime newDate = DateTime.now().add(Duration(days: i));
      for (IntervalModel data
          in vendorData.value?.businessData?.intervalList ?? []) {
        if (!data.isClosed &&
            (newDate.weekday - 1) == dayList.indexOf(data.day)) {
          if (isRecheck &&
              selectedDate!.day == newDate.day &&
              selectedDate!.month == newDate.month) {
            selectedDate = newDate;
          }
          dateList.add(newDate);
        }
      }
    }
    update();
  }

  int duration = 0;

  void getTime(DateTime date) {
    List<Map<String, DateTime>> breaks = [];

    /// calculate total service duration
    duration = 0;
    for (var element in selectedService) {
      ServiceModel data = serviceList.firstWhere((e) => e.id == element);
      duration += data.serviceTime;
    }

    /// add break list from intervals
    List<IntervalModel> list =
        vendorData.value?.businessData?.intervalList ?? [];
    DateTime startTime = DateFormat("hh:mm a").parse("10:00 AM");
    DateTime endTime = DateFormat("hh:mm a").parse("07:00 PM");
    if (list.isNotEmpty) {
      IntervalModel data = list[date.weekday - 1];
      startTime =
          DateFormat("hh:mm a").parse(data.data?.startTime ?? "10:00 AM");
      endTime = DateFormat("hh:mm a").parse(data.data?.endTime ?? "07:00 PM");
      if ((data.data?.breakList ?? []).isNotEmpty) {
        breaks = data.data!.breakList
            .map(
              (e) => {
                "start": DateFormat("hh:mm a").parse(e.startTime),
                "end": DateFormat("hh:mm a").parse(e.endTime),
              },
            )
            .toList();
      }
    }

    /// add break from bookings
    if (employeeBooking.isNotEmpty) {
      for (var element in employeeBooking) {
        DateTime bookingDate =
            DateTime.fromMillisecondsSinceEpoch(element.orderDate);
        if (isSameDate(bookingDate, date)) {
          DateTime book = DateFormat("hh:mm a")
              .parse(DateFormat("hh:mm a").format(bookingDate));
          breaks.add({
            "start": book,
            "end": book.add(Duration(minutes: element.duration)),
          });
        }
      }
    }

    "-->>> break $breaks".print;

    /// generate slot
    ServiceScheduler slotService = ServiceScheduler(
      startTime: startTime,
      date: date,
      endTime: endTime,
      breaks: breaks,
      serviceDuration: Duration(minutes: duration),
    );
    timeList = slotService.generateSlots();
  }

  void addDate(DateTime date, Function() elsePart) {
    if (!timeList.any((e) => e == DateFormat("hh:mm a").format(date))) {
      timeList.add(DateFormat("hh:mm a").format(date));
    } else {
      elsePart();
    }
  }

  List<String> dayList = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  List<String> timeList = [];
}

class ServiceScheduler {
  final DateTime date;
  final DateTime startTime; // 10:00 AM
  final DateTime endTime; // 7:00 PM
  final List<Map<String, DateTime>> breaks;
  final Duration serviceDuration; // duration of the service

  ServiceScheduler({
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.breaks,
    required this.serviceDuration,
  });

  List<String> generateSlots() {
    List<String> slots = [];
    DateTime currentSlotStart = startTime;

    while (currentSlotStart.isBefore(endTime)) {
      DateTime currentSlotEnd = currentSlotStart.add(serviceDuration);

      // Check if current slot conflicts with any breaks
      bool inBreak = false;
      for (var brk in breaks) {
        DateTime breakStart = brk['start']!;
        DateTime breakEnd = brk['end']!;

        if (currentSlotEnd.isAfter(breakStart) &&
            currentSlotStart.isBefore(breakEnd)) {
          // Apply the rule to skip over the break
          currentSlotStart = breakEnd;
          currentSlotEnd = currentSlotStart.add(serviceDuration);
          inBreak = true;
          break;
        }
      }

      if (!inBreak) {
        // Condition: Check if the slot ends just before a break and if it can be adjusted
        for (var brk in breaks) {
          DateTime breakStart = brk['start']!;
          if (currentSlotEnd.isAfter(breakStart) &&
              currentSlotEnd.difference(breakStart).inMinutes <= 15) {
            // Neglected time must be less than serviceDuration / 3
            int neglectedTime =
                breakStart.difference(currentSlotEnd).inMinutes.abs();
            "-->> slot gen here $currentSlotEnd - > $breakStart == $neglectedTime"
                .print;
            if (neglectedTime <= serviceDuration.inMinutes / 3) {
              currentSlotEnd = breakStart;
            } else {
              // Skip this slot as it violates the rule
              currentSlotStart = breakStart.add(serviceDuration);
              break;
            }
          }
        }

        // Add the valid slot to the list
        if (currentSlotEnd.isBefore(endTime) ||
            currentSlotEnd.isAtSameMomentAs(endTime)) {
          String slot = DateFormat("hh:mm a").format(currentSlotStart);

          DateTime now = DateTime.now();
          if (date.day == now.day && date.month == now.month) {
            DateTime slotDate =
                DateFormat("hh:mm a").parse(DateFormat("hh:mm a").format(now));
            if (slotDate.isBefore(currentSlotStart)) {
              slots.add(slot);
            }
          } else {
            slots.add(slot);
          }
        }

        // Move to the next slot
        currentSlotStart = currentSlotEnd;
      }
    }
    return slots;
  }
}

// getDynamicTime({
//   required String startTime,
//   required String endTime,
//   int serviceTime = 60,
//   List<(String, String)>? breakList,
// }) {
//   timeList.clear();
//   DateTime startDate = timeToDate(startTime);
//   DateTime endDate = timeToDate(endTime);
//
//   DateTime date = startDate;
//   Duration d = Duration(minutes: serviceTime);
//
//   DateTime? dummyDate;
//   int index = 0;
//   for (int x = 0; x < 10; x++) {
//     if (date.add(d).difference(endDate).inMinutes < 15) {
//       ///
//       ///
//       /// check if break list available or not
//       if (breakList != null) {
//         ///
//         /// remove break slots
//         DateTime breakS = timeToDate((breakList[index].$1));
//
//         if (breakS.difference(date).inMinutes > 0) {
//           if (date.add(d).difference(breakS).inMinutes < 15) {
//             addDate(date, () => null);
//           } else {
//             "-->>> esle ".print;
//             if (breakList.length == index) index++;
//           }
//         } else {
//           "-->>>".print;
//           if (breakList.length == index) index++;
//         }
//         /*
//           for (int i = 0; i < breakList.length; i++) {
//             (String, String) breaks = breakList[i];
//             DateTime breakStart = timeToDate(breaks.$1);
//             DateTime breakEnd = timeToDate(breaks.$2);
//
//             ///
//             /// check if break list single or multiple
//             ///
//             /// For single break list
//             ///
//             /// dummyEndDate parameter is use to differentiate whether break
//             /// list has single or multiple data
//             DateTime dummyEndDate = i + 1 == breakList.length
//                 ? endDate
//                 : timeToDate(breakList[i + 1].$1);
//             if (date.add(d).difference(breakStart).inMinutes < 15 &&
//                 endDate.difference(breakStart).inMinutes > 15) {
//               addDate(date, () => null);
//             } else {
//               ///
//
//               /// after break calculation
//               /// Check differance between end break and end date if the
//               /// dirrerance is more then service time and modulo of
//               /// differance and service time is edjustable
//               int minDuration = dummyEndDate.difference(breakEnd).inMinutes;
//               if (minDuration < serviceTime) {
//                 "-->>>> Here date $date _--- $dummyEndDate   $breakEnd-- $i"
//                     .print;
//                 int diff = serviceTime - minDuration;
//
//                 if (diff <= 10 && (serviceTime ~/ 3) >= diff) {
//                   ///
//                   /// if adjustable differance is less then 5 then we start
//                   /// slot calculation start from last break end date other wise
//                   /// we start from diff/2.
//                   if (diff < 5) {
//                     dummyDate = breakEnd;
//                   } else {
//                     dummyDate = breakEnd.subtract(Duration(minutes: diff ~/ 2));
//                   }
//                   addDate(dummyDate!, () {
//                     addDate(date, () => null);
//                     return dummyDate = null;
//                   });
//                 }
//               } else {
//                 int diff = minDuration % serviceTime;
//                 // "-->> diff $diff -  -- $breakEnd -- $i -- -- $date".print;
//                 if (diff >= (serviceTime - (serviceTime ~/ 3))) {
//                   if (diff < 5) {
//                     dummyDate = breakEnd;
//                   } else {
//                     dummyDate = breakEnd
//                         .subtract(Duration(minutes: (serviceTime - diff) ~/ 2));
//                   }
//                   addDate(dummyDate!, () {
//                     addDate(date, () => null);
//                     return dummyDate = null;
//                   });
//
//                   // if (!timeList.any(
//                   //     (e) => e == DateFormat("hh:mm a").format(breakEnd))) {
//                   //   dummyDate = dummy;
//                   //   timeList.add(DateFormat("hh:mm a").format(dummy));
//                   // } else {
//                   //   dummyDate = null;
//                   // }
//                 } else {
//                   "-->>".print;
//                   addDate(breakEnd, () {
//                     addDate(date, () => null);
//                     dummyDate = null;
//                   });
//                 }
//               }
//             }
//             dummyDate = null;
//           }*/
//         date = dummyDate ?? date.add(d);
//       } else {
//         timeList.add(DateFormat("hh:mm a").format(date));
//         date = date.add(d);
//       }
//     }
//     // } else {
//     //   break;
//   }
//   "-->>> $timeList".print;
// }
