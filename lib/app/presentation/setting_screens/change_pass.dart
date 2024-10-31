import 'package:salon_user/app/utils/all_dependency.dart';

class ChangePassScreen extends GetView<SettingController> {
  const ChangePassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: p16, vertical: 8),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      controller.currentPass.clear();
                      controller.newPass.clear();
                      controller.cuPass.clear();
                      Get.back();
                    },
                    child: const Icon(Icons.arrow_back_rounded),
                  ),
                  15.horizontal(),
                  const S24Text("Change password"),
                ],
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  children: [
                    GetBuilder<SettingController>(
                      builder: (controller) {
                        return CommonTextfield(
                          controller: controller.currentPass,
                          hintText: "Current password",
                          prefixIcon: AppAssets.passIc,
                          suffixIcon: controller.obscureText
                              ? Icons.remove_red_eye_outlined
                              : Icons.remove_red_eye,
                          obscureText: controller.obscureText,
                          keyboardType: TextInputType.visiblePassword,
                          onPressed: () {
                            controller.obscureText = !controller.obscureText;
                            controller.update();
                          },
                        );
                      },
                    ),
                    GetBuilder<SettingController>(
                      builder: (controller) {
                        return CommonTextfield(
                          controller: controller.newPass,
                          hintText: "New password",
                          prefixIcon: AppAssets.passIc,
                          suffixIcon: controller.newObscureText
                              ? Icons.remove_red_eye_outlined
                              : Icons.remove_red_eye,
                          obscureText: controller.newObscureText,
                          keyboardType: TextInputType.visiblePassword,
                          onPressed: () {
                            controller.newObscureText =
                                !controller.newObscureText;
                            controller.update();
                          },
                        );
                      },
                    ),
                    GetBuilder<SettingController>(
                      builder: (controller) {
                        return CommonTextfield(
                          controller: controller.cuPass,
                          hintText: "Confirm new password",
                          prefixIcon: AppAssets.passIc,
                          suffixIcon: controller.newrePassObscureText
                              ? Icons.remove_red_eye_outlined
                              : Icons.remove_red_eye,
                          obscureText: controller.newrePassObscureText,
                          keyboardType: TextInputType.visiblePassword,
                          onPressed: () {
                            controller.newrePassObscureText =
                                !controller.newrePassObscureText;
                            controller.update();
                          },
                        );
                      },
                    ),
                    25.vertical(),
                    CommonBtn(
                      text: "Update",
                      onTap: () => controller.updateProfile(isUpdatePass: true),
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
}
