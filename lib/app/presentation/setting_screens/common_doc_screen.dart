import 'package:salon_user/app/utils/all_dependency.dart';

class CommonDocScreen extends StatelessWidget {
  const CommonDocScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(
      builder: (controller) {
        return CommonAppbar(
          title: controller.docScreen,
          padd: const EdgeInsets.all(p16),
          children: [
            S16Text(AppStrings.loremText * 10, maxLines: 10000),
          ],
        );
      },
    );
  }
}
