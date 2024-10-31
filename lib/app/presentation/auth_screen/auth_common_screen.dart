import '../../utils/all_dependency.dart';

class AuthCommonScreen extends GetView<AuthController> {
  final String title;
  final String desc;
  final List<Widget> children;
  final Widget? bottomNavBar;
  final bool isBack;
  final bool isClear;
  final bool isOtpClear;
  final Function? onTap;
  const AuthCommonScreen({
    super.key,
    required this.title,
    required this.desc,
    required this.children,
    this.bottomNavBar,
    this.isBack = false,
    this.isClear = true,
    this.isOtpClear = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return PopScope(
      onPopInvoked: (didPop) {
        if (isClear) {
          controller.clearTap(isOtpClear: isOtpClear);
        }
      },
      child: Scaffold(
        backgroundColor: AppColor.white,
        bottomNavigationBar: bottomNavBar,
        body: SafeArea(
          child: ListView(
            primary: false,
            padding: const EdgeInsets.symmetric(horizontal: p16),
            children: [
              if (isBack)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => onTap!(),
                        child: const CircleAvatar(
                          backgroundColor: AppColor.grey20,
                          child: Icon(Icons.arrow_back_rounded),
                        ),
                      ),
                    ],
                  ),
                ),
              (size.height * 0.05).vertical(),
              S24Text(title),
              5.vertical(),
              S14Text(desc),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}
