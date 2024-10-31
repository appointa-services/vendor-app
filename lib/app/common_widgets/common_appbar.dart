import 'package:salon_user/app/utils/all_dependency.dart';

class CommonAppbar extends StatelessWidget {
  final String title;
  final Function()? onBackTap;
  final List<Widget> children;
  final EdgeInsets? padd;
  final Widget? bottomWidget;
  final bool isDivider;
  final Widget? appbarSuffix;
  final Widget? floatingAction;
  final ScrollPhysics? scrollPhysics;

  const CommonAppbar({
    super.key,
    required this.title,
    this.padd,
    this.onBackTap,
    this.bottomWidget,
    required this.children,
    this.appbarSuffix,
    this.isDivider = true,
    this.scrollPhysics,
    this.floatingAction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomWidget,
      backgroundColor: AppColor.white,
      floatingActionButton: floatingAction,
      body: PopScope(
        onPopInvoked: (didPop) {
          if (onBackTap != null) {
            onBackTap!();
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: p16, top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: const Icon(Icons.arrow_back_rounded),
                    ),
                    15.horizontal(),
                    S24Text(title),
                    const Spacer(),
                    if (appbarSuffix != null)
                      appbarSuffix!
                    else
                      const CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.transparent,
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: padd ?? EdgeInsets.zero,
                  child: Column(
                    children: children,
                  ),
                ),
              ),
              // ListView(
              //   primary: false,
              //   padding: padd,
              //   shrinkWrap: true,
              //   physics: scrollPhysics,
              //   children: children,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
