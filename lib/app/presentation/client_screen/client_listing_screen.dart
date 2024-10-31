import 'package:salon_user/app/utils/all_dependency.dart';

class ClientListingScreen extends StatelessWidget {
  final bool isBack;
  const ClientListingScreen({super.key, this.isBack = false});

  @override
  Widget build(BuildContext context) {
    Get.put(ClientController());
    return Scaffold(
      floatingActionButton: isBack
          ? null
          : GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.addClientScreen);
              },
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.primaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 2,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Icon(
                    Icons.add_rounded,
                    color: AppColor.white,
                  ),
                ),
              ),
            ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          p16,
          MediaQuery.of(context).padding.top + p16,
          p16,
          0,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment:
                  isBack ? MainAxisAlignment.start : MainAxisAlignment.center,
              children: [
                if (isBack)
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Icon(Icons.arrow_back_rounded),
                  ),
                if (isBack) 15.horizontal(),
                S24Text(isBack ? "Select Clients" : "Clients"),
              ],
            ),
            15.vertical(),
            CommonSearchFiled(
              hintText: "Search Client",
              onSearch: (search) {},
            ),
            10.vertical(),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                padding: const EdgeInsets.only(top: 10),
                itemBuilder: (context, index) {
                  return ClientWidget(
                    onTap: () {
                      if (isBack) {
                        Get.back(result: true);
                      } else {
                        Get.toNamed(AppRoutes.clientDetailScreen);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
