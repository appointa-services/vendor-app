import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:salon_user/firebase_options.dart';
import 'app/utils/all_dependency.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Helper.darkTheme();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Salon User',
      debugShowCheckedModeBanner: false,
      // showPerformanceOverlay: true,
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
