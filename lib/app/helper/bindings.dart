import '../utils/all_dependency.dart';

class SplashBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<SplashController>(SplashController());
  }
}

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController());
  }
}

class DashboardBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<DashboardController>(DashboardController());
  }
}

class ProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<ClientController>(ClientController());
  }
}

class AdminBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<AdminController>(AdminController());
  }
}
