import 'package:salon_user/app/utils/all_dependency.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Helper.lightTheme();
    return PopScope(
      onPopInvoked: (_) {
        if (controller.screenIndex != 0) {
          controller.screenIndex = 0;
          controller.update();
        } else {
          Helper.onWillPop();
        }
      },
      canPop: false,
      child: GetBuilder<DashboardController>(
        builder: (controller) {
          return Scaffold(
            bottomNavigationBar: ColoredBox(
              color: AppColor.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(color: AppColor.grey20, height: 0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      icon(
                        AppAssets.scheduleIc,
                        controller.screenIndex == 0,
                        0,
                      ),
                      icon(
                        AppAssets.personIc,
                        controller.screenIndex == 1,
                        1,
                      ),
                      icon(
                        AppAssets.sellsIc,
                        controller.screenIndex == 2,
                        2,
                      ),
                      icon(
                        AppAssets.settingIc,
                        controller.screenIndex == 3,
                        3,
                      ),
                    ],
                  ),
                  (MediaQuery.of(context).padding.bottom / 2).vertical(),
                ],
              ),
            ),
            body: controller.screenList[controller.screenIndex],
          );
        },
      ),
    );
  }

  Widget icon(
    String icon,
    bool isSelect,
    int index,
  ) {
    return GestureDetector(
      onTap: () {
        controller.screenIndex = index;
        controller.update();
      },
      child: ColoredBox(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SvgPicture.asset(
                icon,
                color: isSelect ? AppColor.primaryColor : null,
              ),
              5.vertical(),
              CircleAvatar(
                radius: 2.5,
                backgroundColor:
                    isSelect ? AppColor.primaryColor : Colors.transparent,
              )
            ],
          ),
        ),
      ),
    );
  }
}
