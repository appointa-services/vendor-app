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
      name: AppRoutes.vendorScreen,
      page: () => const VendorScreen(),
      binding: VendorBinding(),
    ),
    getPage(
      name: AppRoutes.serviceList,
      page: () => const ServiceListingPage(),
    ),
    getPage(
      name: AppRoutes.bookService,
      page: () => const BookServiceScreen(),
    ),
    getPage(
      name: AppRoutes.bookingCheckout,
      page: () => const CheckoutScreen(),
    ),
    getPage(
      name: AppRoutes.profileScreen,
      binding: ProfileBinding(),
      page: () => const ProfileScreen(),
    ),
    getPage(
      name: AppRoutes.editProfileScreen,
      page: () => const EditProfile(),
    ),
    getPage(
      name: AppRoutes.favouriteScreen,
      page: () => const FavouriteScreen(),
    ),
    getPage(
      name: AppRoutes.commonDocScreen,
      page: () => const CommonDocScreen(),
    ),
    getPage(
      name: AppRoutes.productListingScreen,
      page: () => const ProductListingScreen(),
    ),
    getPage(
      name: AppRoutes.searchScreen,
      page: () => const SearchScreen(),
    ),
    getPage(
      name: AppRoutes.bookingSearchScreen,
      page: () => const BookServiceScreen(),
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
