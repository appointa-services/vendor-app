import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/data_models/vendor_data_models.dart';

class AddTimeScreen extends StatelessWidget {
  const AddTimeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController controller = Get.find<AuthController>();
    return controller.isSettingScreen
        ? Scaffold(
            backgroundColor: AppColor.white,
            bottomNavigationBar: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(p16),
                child: CommonBtn(
                  text: "Save",
                  borderRad: 10,
                  onTap: () => controller.addBusinessDetail(context),
                ),
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: p16, top: 8, right: p16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: const Icon(Icons.arrow_back_rounded),
                        ),
                        15.horizontal(),
                        const S24Text(AppStrings.yourBusinessHr),
                      ],
                    ),
                    15.vertical(),
                    widget(),
                  ],
                ),
              ),
            ),
          )
        : widget();
  }

  Widget widget() {
    AuthController controller = Get.find<AuthController>();
    return Expanded(
      child: ListView(
        primary: false,
        children: [
          if (!controller.isSettingScreen)
            const SText(
              AppStrings.yourBusinessHr,
              size: 26,
              fontWeight: FontWeight.w700,
            ),
          if (!controller.isSettingScreen) 8.vertical(),
          if (!controller.isSettingScreen) const S14Text(AppStrings.whenClient),
          if (!controller.isSettingScreen) 12.vertical(),
          GetBuilder<AuthController>(
            builder: (controller) {
              return Column(
                children: List.generate(
                  controller.intervalList.length,
                  (index) {
                    IntervalModel data = controller.intervalList[index];
                    return BusinessHrWidget(data: data, index: index);
                  },
                ).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
