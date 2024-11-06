import 'package:email_otp/email_otp.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_storage/get_storage.dart';
import 'package:salon_user/firebase_options.dart';
import 'app/utils/all_dependency.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Helper.darkTheme();
  GetStorage.init();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  EmailOTP.config(
    appName: 'Appointa Service',
    otpType: OTPType.numeric,
    emailTheme: EmailTheme.v3,
    appEmail: "appointaservices@gmail.com",
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Appointa Vendor',
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.initial,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColor.white,
        fontFamily: "Nunito",
      ),
      getPages: AppPages.routes,
      builder: EasyLoading.init(),
    );
  }
}
