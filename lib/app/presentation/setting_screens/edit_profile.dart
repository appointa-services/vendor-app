import 'package:salon_user/app/presentation/setting_screens/change_pass.dart';

import '../../utils/all_dependency.dart';

class EditProfileScreen extends GetWidget<SettingController> {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: p16, vertical: 8),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Icon(Icons.arrow_back_rounded),
                  ),
                  15.horizontal(),
                  const S24Text(AppStrings.editProfile),
                ],
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: S18Text("Personal data"),
                    ),
                    CommonTextfield(
                      controller: controller.name,
                      hintText: AppStrings.name,
                      prefixIcon: AppAssets.personIc,
                    ),
                    CommonTextfield(
                      controller: TextEditingController(),
                      hintText: controller.email.text,
                      prefixIcon: AppAssets.emailIc,
                      keyboardType: TextInputType.emailAddress,
                      readOnly: true,
                    ),
                    CommonTextfield(
                      controller: controller.mobile,
                      hintText: AppStrings.mobileNumber,
                      prefixIcon: AppAssets.phoneIc,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    if (!(controller.user?.isGoogle ?? true))
                      Padding(
                        padding: const EdgeInsets.only(top: 25, bottom: 15),
                        child: CommonBtn(
                          text: "Change password",
                          borderColor: AppColor.grey100,
                          btnColor: AppColor.white,
                          textColor: AppColor.grey100,
                          onTap: () => pushPage(const ChangePassScreen()),
                        ),
                      ),
                    CommonBtn(
                      text: "Save",
                      onTap: () => controller.updateProfile(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget pageViewBtn({
    required String title,
    required bool isSelected,
    required Function() onTap,
    bool isType = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        alignment: Alignment.center,
        padding:
            EdgeInsets.symmetric(horizontal: 20, vertical: isType ? 10 : 0),
        child: S14Text(
          title,
          textAlign: TextAlign.center,
          color: isSelected ? AppColor.white : AppColor.primaryColor,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
    );
  }
}
