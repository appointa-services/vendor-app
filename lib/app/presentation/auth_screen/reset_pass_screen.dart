import 'package:salon_user/app/utils/all_dependency.dart';

class ResetPassScreen extends GetWidget<AuthController> {
  const ResetPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AuthCommonScreen(
      title: "${AppStrings.newPass},",
      desc: AppStrings.nowUCanCreate,
      isBack: true,
      isClear: false,
      onTap: () => Get.back(),
      bottomNavBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              p16,
              10,
              p16,
              MediaQuery.of(context).viewInsets.bottom + p16,
            ),
            child: CommonBtn(
              text: AppStrings.confirmNewPassCap,
              onTap: () => controller.resetPass(),
            ),
          ),
        ],
      ),
      children: [
        (size.height * 0.1).vertical(),
        GetBuilder<AuthController>(
          builder: (controller) {
            return CommonTextField(
              controller: controller.pass,
              hintText: AppStrings.newPass,
              prefixIcon: AppAssets.passIc,
              suffixIcon: controller.obscureText
                  ? Icons.remove_red_eye
                  : Icons.remove_red_eye_outlined,
              obscureText: controller.obscureText,
              keyboardType: TextInputType.visiblePassword,
              onPressed: () {
                controller.obscureText = !controller.obscureText;
                controller.update();
              },
            );
          },
        ),
        GetBuilder<AuthController>(
          builder: (controller) {
            return CommonTextField(
              controller: controller.rePass,
              textInputAction: TextInputAction.done,
              hintText: AppStrings.confirmNewPass,
              prefixIcon: AppAssets.passIc,
              suffixIcon: controller.reObscureText
                  ? Icons.remove_red_eye
                  : Icons.remove_red_eye_outlined,
              obscureText: controller.reObscureText,
              keyboardType: TextInputType.visiblePassword,
              onPressed: () {
                controller.reObscureText = !controller.reObscureText;
                controller.update();
              },
            );
          },
        ),
      ],
    );
  }
}
