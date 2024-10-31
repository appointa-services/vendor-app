import 'package:salon_user/app/presentation/setting_screens/edit_profile.dart';
import 'package:salon_user/app/utils/all_dependency.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SettingController controller = Get.put(SettingController());
    AuthController authController = Get.put(
      AuthController(isCatDataLoad: true),
    );
    return Padding(
      padding: EdgeInsets.fromLTRB(
        p16,
        MediaQuery.of(context).padding.top + p16,
        p16,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const S24Text(
            "Settings",
            textAlign: TextAlign.center,
          ),
          15.vertical(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                settingWidget(
                  icon: AppAssets.editProfileIc,
                  title: AppStrings.editProfile,
                  desc: AppStrings.addBusinessDetail,
                  onTap: () {
                    authController.isSettingScreen = true;
                    authController.isLoad = true;
                    authController
                      ..assignData()
                      ..update();
                    pushPage(const EditProfileScreen());
                  },
                ),
                settingWidget(
                  icon: AppAssets.businessIc,
                  title: AppStrings.businessDetail,
                  desc: AppStrings.addBusinessDetail,
                  onTap: () {
                    authController.isSettingScreen = true;
                    authController.isLoad = true;
                    authController
                      ..assignData()
                      ..update();
                    pushPage(const AddDetailScreen());
                  },
                ),
                settingWidget(
                  icon: AppAssets.serviceSettingIc,
                  title: AppStrings.serviceSetup,
                  desc: AppStrings.addServiceDetail,
                  onTap: () => pushPage(
                    const ServiceListingScreen(isSettingScreen: true),
                  ),
                ),
                settingWidget(
                  icon: AppAssets.scheduleManagementIc,
                  title: AppStrings.secheduleManagement,
                  desc: AppStrings.editUrHr,
                  onTap: () {
                    authController.isSettingScreen = true;
                    authController
                      ..assignData()
                      ..update();
                    pushPage(const AddTimeScreen());
                  },
                ),
                settingWidget(
                  icon: AppAssets.staffIc,
                  title: AppStrings.staffMember,
                  desc: AppStrings.manageMember,
                  onTap: () => pushPage(const StaffListScreen()),
                ),
                settingWidget(
                  icon: AppAssets.privacy,
                  title: AppStrings.privacyPolicy,
                  onTap: () {
                    controller.docScreen = AppStrings.privacy;
                    Get.toNamed(AppRoutes.commonDocScreen);
                  },
                ),
                settingWidget(
                  icon: AppAssets.terms,
                  title: AppStrings.terms,
                  onTap: () {
                    controller.docScreen = AppStrings.terms;
                    Get.toNamed(AppRoutes.commonDocScreen);
                  },
                ),
                settingWidget(
                  icon: AppAssets.logout,
                  title: AppStrings.logout,
                  isLastIc: false,
                  onTap: () => Get.bottomSheet(
                    CommonDialog(
                      title: AppStrings.logout,
                      desc: AppStrings.areUSureLogout,
                      yesbtnString: AppStrings.yesLogout,
                      onYesTap: () async {
                        await authController.logout().then(
                              (value) => Get.offAllNamed(
                                AppRoutes.loginScreen,
                              ),
                            );
                      },
                    ),
                  ),
                ),
                settingWidget(
                  icon: AppAssets.delete,
                  title: AppStrings.deleteAcc,
                  isLastIc: false,
                  txtColor: AppColor.redColor,
                  onTap: () => Get.bottomSheet(
                    CommonDialog(
                      title: AppStrings.deleteAcc,
                      desc: AppStrings.areUSureDelete,
                      yesbtnString: AppStrings.yesDelete,
                      onYesTap: () => Get.offAllNamed(AppRoutes.loginScreen),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 35, bottom: 20),
                  child: S12Text(
                    "Version 1.0.0",
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w700,
                    color: AppColor.grey100,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget settingWidget({
    required String icon,
    required String title,
    String? desc,
    Color? txtColor,
    bool isLastIc = true,
    required Function() onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: ColoredBox(
            color: Colors.transparent,
            child: Row(
              children: [
                SvgPicture.asset(icon, width: 25),
                15.horizontal(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      S16Text(
                        title,
                        fontWeight: FontWeight.w700,
                        color: txtColor ?? AppColor.grey100,
                      ),
                      if (desc != null) S12Text(desc),
                    ],
                  ),
                ),
                if (isLastIc) 10.horizontal(),
                if (isLastIc)
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppColor.primaryColor,
                    size: 18,
                  ),
              ],
            ),
          ),
        ),
        const Divider(
          height: 30,
          color: AppColor.grey40,
        )
      ],
    );
  }
}
