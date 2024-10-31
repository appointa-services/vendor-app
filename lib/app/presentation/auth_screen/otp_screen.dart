import 'package:pinput/pinput.dart';
import 'package:salon_user/app/utils/all_dependency.dart';

class OtpScreen extends GetWidget<AuthController> {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AuthCommonScreen(
      title: AppStrings.emailVerification,
      desc: AppStrings.pleaeTypeOtp,
      isClear: true,
      isBack: true,
      onTap: () => Get.back(),
      isOtpClear: true,
      bottomNavBar: IntrinsicHeight(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            p16,
            10,
            p16,
            MediaQuery.of(context).viewInsets.bottom + p16,
          ),
          child: CommonBtn(
            text: AppStrings.verifyEmail,
            onTap: () => controller.verifyOtp(),
          ),
        ),
      ),
      children: [
        (size.height * 0.1).vertical(),
        Pinput(
          keyboardType: TextInputType.phone,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          length: 6,
          onCompleted: (value) {
            controller.otp.text = value;
            controller.update();
          },
          defaultPinTheme: PinTheme(
            decoration: BoxDecoration(
              color: AppColor.grey20,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 55,
          ),
          focusedPinTheme: PinTheme(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColor.primaryColor),
              color: AppColor.grey20,
            ),
            height: 55,
          ),
          submittedPinTheme: PinTheme(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColor.grey20,
            ),
            height: 55,
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColor.grey100,
            ),
          ),
        ),
        GetBuilder<AuthController>(
          builder: (controller) {
            return GestureDetector(
              onTap: () => controller.sendOtp(isResend: true),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 0, 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    S16Text(
                      controller.otpTime == 0
                          ? AppStrings.resendOtp
                          : AppStrings.resendOn,
                      color: AppColor.primaryColor,
                    ),
                    if (controller.otpTime != 0)
                      S16Text(
                        controller.getDuration(),
                        color: AppColor.primaryColor,
                      ),
                  ],
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
