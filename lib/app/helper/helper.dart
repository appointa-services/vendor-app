import 'dart:developer';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:salon_user/app/utils/all_dependency.dart';

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

bool emailValid(email) => RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
    .hasMatch(email);

bool mobileValid(String mobile) =>
    RegExp(r'^(?:[+0][1-9])?[0-9]{10}$').hasMatch(mobile) &&
    RegExp(r'^[6-9]$').hasMatch(mobile[0]);

bool passValid(String pass) => pass.length >= 6;

/// common padding
const double p16 = 16;

extension Sizedbox on dynamic {
  SizedBox horizontal() {
    return SizedBox(width: this.toDouble());
  }

  SizedBox vertical() {
    return SizedBox(height: this.toDouble());
  }
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

Future<List<String>> selectFiles() async {
  final ImagePicker picker = ImagePicker();

  List<XFile> list = await picker.pickMultiImage(
    maxHeight: 1920,
    maxWidth: 1920,
  );

  List<String> paths = [];

  for (XFile image in list) {
    if (getImageSize(File(image.path)) != null) {
      paths.add(image.path);
    }
  }
  if (list.length != paths.length) {
    showSnackBar(
      "Please select up to 2mb images only",
      color: Colors.red,
    );
  }
  return paths;
}

Future<String> selectFile() async {
  final ImagePicker picker = ImagePicker();

  XFile? img = await picker.pickImage(
    source: ImageSource.gallery,
    maxHeight: 1920,
    maxWidth: 1920,
  );

  String paths = "";

  if (img != null) {
    if (getImageSize(File(img.path)) != null) {
      paths = img.path;
    } else {
      showSnackBar(
        "Please select up to 2mb images only",
        color: Colors.red,
      );
    }
  }

  return paths;
}

String? getImageSize(File selectedImage) {
  final bytes = selectedImage.readAsBytesSync().lengthInBytes;
  final kb = bytes / 1024;
  if (kb < 2048) {
    return selectedImage.path;
  } else {
    return null;
  }
}

bool isCurrentMonth(DateTime date1, DateTime date2) {
  return date1.month == date2.month && date1.year == date2.year;
}

bool compareTimes(String time1, String time2) {
  bool isOk = false;
  TimeOfDay parsedTime1 = parseTime(time1);
  TimeOfDay parsedTime2 = parseTime(time2);

  int minutes1 = toMinutes(parsedTime1);
  int minutes2 = toMinutes(parsedTime2);

  if (minutes1 < minutes2) {
    isOk = true;
  }
  return isOk;
}

int toMinutes(TimeOfDay timeOfDay) {
  return timeOfDay.hour * 60 + timeOfDay.minute;
}

TimeOfDay parseTime(String time) {
  final parts = time.split(' ');
  final timeParts = parts[0].split(':');
  final period = parts[1].toUpperCase();

  int hour = int.parse(timeParts[0]);
  int minute = int.parse(timeParts[1]);

  // Convert to 24-hour format if it's PM
  if (period == 'PM' && hour != 12) {
    hour += 12;
  } else if (period == 'AM' && hour == 12) {
    hour = 0; // Midnight case
  }

  return TimeOfDay(hour: hour, minute: minute);
}

String listToString(List? list, {String? comaReplacer}) =>
    list
        ?.toString()
        .replaceAll("[", "")
        .replaceAll("]", "")
        .replaceAll(",", comaReplacer ?? ",") ??
    "";

String timeToString(int? value) {
  String time = "";
  if (value != null) {
    time = value ~/ 60 == 0 ? "" : "${value ~/ 60}hr ";
    time += value.remainder(60) == 0 ? "" : "${value.remainder(60)}min";
  }
  return time;
}

Color statusColor(String status) {
  return switch (status) {
    AppStrings.upcoming => AppColor.orange,
    AppStrings.cancelled => AppColor.red,
    _ => AppColor.green
  };
}

int getDividedValue(
  int discount,
  int length, {
  bool isLast = false,
}) {
  int finalVal = discount ~/ length;
  return isLast ? (discount - (finalVal * (length - 1))) : finalVal;
}

EdgeInsets bottomPad = const EdgeInsets.only(bottom: 10);

extension Print on dynamic {
  get print => log(this, name: AppStrings.appName);
}
