import 'package:salon_user/app/utils/all_dependency.dart';

class PaymentOptionWidget extends StatelessWidget {
  const PaymentOptionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(p16),
      child: GetBuilder<HomeController>(
        builder: (controller) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      controller.isPymentScreen = false;
                      controller.update();
                    },
                    child: const Icon(Icons.arrow_back_rounded),
                  ),
                  12.horizontal(),
                  const SText(
                    "Payment method",
                    size: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
              GridView.builder(
                shrinkWrap: true,
                itemCount: 2,
                padding: const EdgeInsets.only(top: 30, left: p16, right: p16),
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  String option = index == 0 ? "Online" : "Cash";
                  bool isSelected = controller.paymentOption == option;
                  return GestureDetector(
                    onTap: () {
                      controller.paymentOption = option;
                      controller.update();
                    },
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColor.grey100,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.transparent,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            index == 0 ? Icons.payment : Icons.money_rounded,
                          ),
                          5.vertical(),
                          S14Text(
                            index == 0 ? "Online" : "Cash",
                            fontWeight: FontWeight.w700,
                            color: AppColor.grey100,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              50.vertical(),
              CommonBtn(
                text: "${AppStrings.rupee} 150  •  Continue",
                borderRad: 10,
                onTap: () => Get.back(),
              ),
            ],
          );
        },
      ),
    );
  }
}
