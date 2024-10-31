import 'package:salon_user/app/utils/all_dependency.dart';

class DashboardController extends GetxController {
  int screenIndex = 0;
  List<Widget> screenList = [
    const HomeScreen(),
    const ClientListingScreen(),
    const SellsScreen(),
    const SettingScreen(),
  ];
}
