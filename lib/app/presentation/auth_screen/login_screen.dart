import 'package:salon_user/app/utils/all_dependency.dart';

class LoginScreen extends GetWidget<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Helper.lightTheme();
    Size size = MediaQuery.of(context).size;
    return AuthCommonScreen(
      title: AppStrings.welcomback,
      desc: AppStrings.gladToMeet,
      children: [
        (size.height * 0.1).vertical(),
        CommonTextfield(
          controller: controller.email,
          hintText: AppStrings.emailAddress,
          prefixIcon: AppAssets.emailIc,
          keyboardType: TextInputType.emailAddress,
        ),
        GetBuilder<AuthController>(
          builder: (controller) {
            return CommonTextfield(
              controller: controller.pass,
              textInputAction: TextInputAction.done,
              hintText: AppStrings.password,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.forgotPassScreen),
              child: const S14Text(
                AppStrings.forgotPass,
                color: AppColor.primaryColor,
              ),
            ),
          ],
        ),
        (size.height * 0.1).vertical(),
        CommonBtn(
          text: AppStrings.signIn,
          onTap: () => controller.login(),
        ),
        const Row(
          children: [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 35, vertical: 15),
              child: S16Text(
                "or",
                color: AppColor.grey80,
              ),
            ),
            Expanded(child: Divider()),
          ],
        ),
        CommonBtn(
          text: AppStrings.signInWithGoogle,
          onTap: () => controller.signInWithGoogle(),
          btnColor: AppColor.white,
          icon: AppAssets.googleIc,
          textColor: AppColor.primaryColor,
        ),
        (size.height * 0.05).vertical(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const S14Text(
              AppStrings.dontHaveAcc,
              color: AppColor.grey80,
            ),
            GestureDetector(
              onTap: () => controller.clearTap(page: AppRoutes.registerScreen),
              child: const S14Text(
                AppStrings.joinNow,
                color: AppColor.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
