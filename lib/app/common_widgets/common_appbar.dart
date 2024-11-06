import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:salon_user/app/utils/all_dependency.dart';

class CommonAppbar extends StatelessWidget {
  final String title;
  final Function()? onBackTap;
  final List<Widget> children;
  final EdgeInsets? padding;
  final Widget? bottomWidget;
  final Widget? appbarSuffix;
  final bool isRefresher;
  final void Function()? onRefresh;

  const CommonAppbar({
    super.key,
    required this.title,
    this.padding,
    this.isRefresher = false,
    this.onBackTap,
    this.bottomWidget,
    required this.children,
    this.appbarSuffix,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    RefreshController refreshController = RefreshController();
    return Scaffold(
      bottomNavigationBar: bottomWidget,
      backgroundColor: AppColor.white,
      body: PopScope(
        onPopInvoked: (didPop) {
          if (onBackTap != null) {
            onBackTap!();
          }
        },
        child: Column(
          children: [
            (MediaQuery.of(context).padding.top).vertical(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: const CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.transparent,
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 20,
                      color: AppColor.grey100,
                    ),
                  ),
                ),
                S18Text(
                  title,
                  color: AppColor.grey100,
                  fontWeight: FontWeight.w700,
                ),
                if (appbarSuffix != null)
                  appbarSuffix!
                else
                  const CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.transparent,
                  ),
              ],
            ),
            const Divider(height: 5),
            Expanded(
              child: isRefresher
                  ? SmartRefresher(
                      controller: refreshController,
                      onRefresh: () {
                        if (onRefresh != null) onRefresh!();
                        refreshController.refreshCompleted();
                      },
                      child: ListView(
                        primary: false,
                        padding: padding ?? EdgeInsets.zero,
                        children: children,
                      ),
                    )
                  : ListView(
                      primary: false,
                      padding: padding ?? EdgeInsets.zero,
                      children: children,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
