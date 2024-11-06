import 'package:salon_user/app/utils/all_dependency.dart';

class CommonDialog extends StatelessWidget {
  final String title;
  final String desc;
  final String yesBtnString;
  final Function() onYesTap;

  const CommonDialog({
    super.key,
    required this.title,
    required this.desc,
    required this.yesBtnString,
    required this.onYesTap,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        color: AppColor.white,
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Padding(
            padding: const EdgeInsets.all(p16) +
                EdgeInsets.only(
                  bottom: MediaQuery.paddingOf(context).bottom / 2,
                ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                12.vertical(),
                SText(
                  title,
                  size: 22,
                  fontWeight: FontWeight.w700,
                ),
                const Divider(height: 35),
                S16Text(
                  desc,
                  fontWeight: FontWeight.w700,
                ),
                30.vertical(),
                Row(
                  children: [
                    Expanded(
                      child: CommonBtn(
                        text: "Cancel",
                        vertPad: 12,
                        onTap: () => Get.back(),
                      ),
                    ),
                    15.horizontal(),
                    Expanded(
                      child: CommonBtn(
                        text: yesBtnString,
                        btnColor: AppColor.primaryLightColor,
                        textColor: AppColor.primaryColor,
                        vertPad: 12,
                        onTap: onYesTap,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColor.grey40,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
