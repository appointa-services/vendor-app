import 'package:salon_user/app/utils/all_dependency.dart';

class HomeController extends GetxController {
  int currentServiceImg = 0;
  bool isCalenderOpen = false;
  String selectedCat = "";
  String selectedEmp = "All";
  List<String> catList = ["All", "Haircut", "Facial"];

  List<(String, String)> categoryList = [
    (AppAssets.hairIc, "Haircut"),
    (AppAssets.facialIc, "Facial"),
  ];
  DateTime focusedDay = DateTime.now();
  String headerText = "Today";
  List<int> selectedCatList = [];
  bool isPymentScreen = false;
  String paymentOption = "";
}
