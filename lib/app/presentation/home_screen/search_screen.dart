import 'package:salon_user/app/utils/all_dependency.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Row(
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
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: p16,
                vertical: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const S24Text("Venue or Service"),
                  Padding(
                    padding: const EdgeInsets.only(top: p16, bottom: 5),
                    child: CommonTextfield(
                      controller: TextEditingController(),
                      prefixIcon: AppAssets.search2Ic,
                      hintText: "Search any Venue or Service",
                      isProfileScreen: true,
                    ),
                  ),
                  const S18Text(
                    "Near your location",
                    fontWeight: FontWeight.w700,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 5,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemBuilder: (context, index) {
                      return SearchWidget(index: index);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
