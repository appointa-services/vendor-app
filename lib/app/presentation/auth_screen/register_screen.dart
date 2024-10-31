import '../../utils/all_dependency.dart';

class RegisterScreen extends GetWidget<AuthController> {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColor.white,
      body: PopScope(
        onPopInvoked: (didPop) => controller.isRegister = false,
        child: SafeArea(
          child: ListView(
            primary: false,
            padding: const EdgeInsets.symmetric(horizontal: p16),
            children: [
              (size.height * 0.05).vertical(),
              const S24Text(AppStrings.createAnAccount),
              5.vertical(),
              const S14Text(AppStrings.pleaseTypeYrFullInfo),
              (size.height * 0.05).vertical(),
              CommonTextfield(
                controller: controller.businessName,
                hintText: AppStrings.name,
                prefixIcon: AppAssets.personIc,
              ),
              CommonTextfield(
                controller: controller.email,
                hintText: AppStrings.emailAddress,
                prefixIcon: AppAssets.emailIc,
                keyboardType: TextInputType.emailAddress,
              ),
              CommonTextfield(
                controller: controller.mobile,
                hintText: AppStrings.mobileNumber,
                prefixIcon: AppAssets.phoneIc,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 10,
              ),
              GetBuilder<AuthController>(
                builder: (controller) {
                  return CommonTextfield(
                    controller: controller.pass,
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
              GetBuilder<AuthController>(
                builder: (controller) {
                  return CommonTextfield(
                    controller: controller.rePass,
                    textInputAction: TextInputAction.done,
                    hintText: AppStrings.rePassword,
                    prefixIcon: AppAssets.passIc,
                    suffixIcon: controller.reObscureText
                        ? Icons.remove_red_eye_outlined
                        : Icons.remove_red_eye,
                    obscureText: controller.reObscureText,
                    keyboardType: TextInputType.visiblePassword,
                    onPressed: () {
                      controller.reObscureText = !controller.reObscureText;
                      controller.update();
                    },
                  );
                },
              ),
              RichText(
                text: TextSpan(
                  text: AppStrings.bySigning,
                  style: const TextStyle(
                    color: AppColor.grey80,
                    fontSize: 14,
                    height: 1.4,
                  ),
                  children: [
                    TextSpan(
                      text: AppStrings.privacy,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.put(SettingController()).docScreen =
                              AppStrings.privacy;
                          Get.toNamed(AppRoutes.commonDocScreen);
                        },
                      style: const TextStyle(
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(text: AppStrings.and),
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.put(SettingController()).docScreen =
                              AppStrings.terms;
                          Get.toNamed(AppRoutes.commonDocScreen);
                        },
                      text: AppStrings.termsNPrivacy,
                      style: const TextStyle(
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              25.vertical(),
              CommonBtn(
                text: AppStrings.joinNow,
                onTap: () => controller.sendOtpForRegister(),
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
                text: AppStrings.joinWithGoogle,
                onTap: () => Get.offAllNamed(AppRoutes.dashboardScreen),
                btnColor: AppColor.white,
                icon: AppAssets.googleIc,
                textColor: AppColor.primaryColor,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const S14Text(
                      AppStrings.alreadyHave,
                      color: AppColor.grey80,
                    ),
                    GestureDetector(
                      onTap: () => controller.clearTap(isBack: true),
                      child: const S14Text(
                        AppStrings.signIn,
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
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
