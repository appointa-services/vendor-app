import 'all_dependency.dart';

class AppPages {
  static const initial = AppRoutes.splashScreen;

  static final routes = [
    getPage(
      name: initial,
      binding: SplashBinding(),
      page: () => const SplashScreen(),
    ),
    getPage(
      name: AppRoutes.adminHome,
      binding: AdminBinding(),
      page: () => const AdminHomeScreen(),
    ),
    getPage(
      name: AppRoutes.detailScreen,
      page: () => const DetailScreen(),
    ),
    getPage(
      name: AppRoutes.loginScreen,
      binding: AuthBinding(),
      page: () => const LoginScreen(),
    ),
    getPage(
      name: AppRoutes.registerScreen,
      page: () => const RegisterScreen(),
    ),
    getPage(
      name: AppRoutes.forgotPassScreen,
      page: () => const ForgotPassScreen(),
    ),
    getPage(
      name: AppRoutes.resetPassScreen,
      page: () => const ResetPassScreen(),
    ),
    getPage(
      name: AppRoutes.otpScreen,
      page: () => const OtpScreen(),
    ),
    getPage(
      name: AppRoutes.dashboardScreen,
      page: () => const DashboardScreen(),
      binding: DashboardBinding(),
    ),
    getPage(
      name: AppRoutes.clientScreen,
      binding: ProfileBinding(),
      page: () => const ClientListingScreen(),
    ),
    getPage(
      name: AppRoutes.addClientScreen,
      page: () => const AddClientScreen(),
    ),
    getPage(
      name: AppRoutes.commonDocScreen,
      page: () => const CommonDocScreen(),
    ),
    getPage(
      name: AppRoutes.searchScreen,
      page: () => const SearchScreen(),
    ),
    getPage(
      name: AppRoutes.addBusinessScreen,
      page: () => const AddBusinessDetail(),
    ),
    getPage(
      name: AppRoutes.clientDetailScreen,
      page: () => const ClientDetailScreen(),
    ),
    getPage(
      name: AppRoutes.addStaffMember,
      page: () => const AddStaffScreen(),
    ),
  ];

  static GetPage getPage(
          {required String name,
          required Widget Function() page,
          Bindings? binding}) =>
      GetPage(
        name: name,
        page: page,
        binding: binding,
        curve: Curves.linear,
        transition: Transition.rightToLeftWithFade,
      );
}

Future<void> pushPage(Widget page) async => Get.to(
      page,
      curve: Curves.linear,
      transition: Transition.rightToLeftWithFade,
    );
