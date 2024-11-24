import 'dart:developer';
import 'dart:io';
import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/data_models/vendor_data_models.dart';

class Helper {
  static void lightTheme() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  static void darkTheme() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: AppColor.primaryColor,
        statusBarColor: AppColor.primaryColor,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  static DateTime? currentBackPressTime;

  static void onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      // Fluttertoast.showToast(msg: "Double tap to exit");
    } else {
      exit(0);
    }
  }
}

/// common padd
const double p16 = 16;

extension Sizedbox on dynamic {
  SizedBox horizontal() {
    return SizedBox(width: this.toDouble());
  }

  SizedBox vertical() {
    return SizedBox(height: this.toDouble());
  }
}

extension Print on dynamic {
  // void print() {
  //   log(this, name: AppStrings.appName);
  // }

  void get print => log(this, name: AppStrings.appName);
}

void showSnackBar(String message, {Color? color}) {
  Get.showSnackbar(
    GetSnackBar(
      message: message,
      duration: const Duration(seconds: 3),
      snackStyle: SnackStyle.FLOATING,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: color ?? AppColor.redColor,
      margin: const EdgeInsets.all(p16),
      borderRadius: 10,
      isDismissible: true,
    ),
  );
}

bool emailValid(email) => RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
    .hasMatch(email);

bool mobileValid(String mobile) =>
    RegExp(r'^(?:[+0][1-9])?[0-9]{10}$').hasMatch(mobile) &&
    RegExp(r'^[6-9]$').hasMatch(mobile[0]);
bool passValid(String pass) => pass.length >= 6;

String listToString(List? list,{String? comaReplacer}) =>
    list?.toString().replaceAll("[", "").replaceAll("]", "").replaceAll(",", comaReplacer ?? ",") ?? "";

/// get vendor current status
String getCurrentStatus({List<IntervalModel>? data, IntervalModel? modelData}) {
  String status = "Closed";

  if (data?.isNotEmpty ?? false) {
    IntervalModel model = data?[DateTime.now().weekday - 1] ?? modelData!;

    if (model.data?.endTime != null) {
      DateTime now = DateTime.now();
      DateTime end = convertTo24HourFormat(model.data!.endTime, now);

      if (end.difference(now).inHours > 0) {
        status = "Open until ${model.data?.endTime}";
      } else if (end.difference(now).inHours >= 0 &&
          end.difference(now).inMinutes > 0) {
        status = "Closes soon at ${model.data?.endTime}";
      }
    }
  }
  return status;
}

bool isOnline(String status) {
  return !status.contains("Closed");
}

String startToEnd(DayDatModel? data) {
  return data == null ? "Closed" : "${data.startTime} - ${data.endTime}";
}

DateTime convertTo24HourFormat(String time12Hour, DateTime date) {
  DateFormat time12HourFormat = DateFormat("hh:mm a");
  DateTime time = time12HourFormat.parse(time12Hour);

  DateTime combinedDateTime = DateTime(
    date.year,
    date.month,
    date.day,
    time.hour,
    time.minute,
  );

  return combinedDateTime;
}

bool isSameDate(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

double lat = 21.199150;
double lng = 72.846411;

DateTime timeToDate(String time) {
  DateFormat timeFormat = DateFormat("hh:mm a");
  DateTime timeDate = timeFormat.parse(time);

  // To combine this time with today's date:
  DateTime now = DateTime.now();
  return DateTime(
    now.year,
    now.month,
    now.day,
    timeDate.hour,
    timeDate.minute,
  );
}
