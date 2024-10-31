import 'package:salon_user/app/utils/all_dependency.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Helper.lightTheme();

    DetailScreenController controller = Get.put(DetailScreenController());
    return Scaffold(
      body: Obx(() {
        int pageIndex = controller.screenIndex.value;
        return SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: controller.pageController,
                  itemCount: controller.screenContent.length,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (value) =>
                      controller.screenIndex.value = value,
                  itemBuilder: (context, index) {
                    (String, String) data = controller.screenContent[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image.asset(data.$1),
                        ),
                        SText(
                          data.$2,
                          size: 28,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(),
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  controller.screenContent.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: index == pageIndex
                            ? AppColor.primaryColor
                            : AppColor.grey60,
                      ),
                      child: SizedBox(
                        width: index == pageIndex ? 30 : 8,
                        height: 8,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ),
                child: CommonBtn(
                  text:
                      pageIndex != 2 ? AppStrings.next : AppStrings.getStarted,
                  onTap: () {
                    if (pageIndex != 2) {
                      controller.screenIndex.value++;
                      controller.pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.linear,
                      );
                    } else {
                      Get.offAllNamed(AppRoutes.loginScreen);
                    }
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
