import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/data_models/vendor_data_models.dart';

class AdminHomeScreen extends GetView<AdminController> {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const S18Text("Admin"),
        actions: [
          IconBtn(
            onPressed: () => controller.logout(),
            icon: const Icon(Icons.logout),
          ),
        ],
        centerTitle: true,
      ),
      body: GetBuilder<AdminController>(
        builder: (controller) {
          return ListView(
            padding: const EdgeInsets.all(p16),
            children: [
              const S16Text("Category"),
              SizedBox(
                height: 95,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  primary: false,
                  padding: const EdgeInsets.only(top: 10),
                  itemCount: controller.categoryList.length + 1,
                  itemBuilder: (context, index) {
                    CategoryModel? data;
                    if (index != controller.categoryList.length) {
                      data = controller.categoryList[index];
                    }
                    return Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: SizedBox(
                        width: 60,
                        child: GestureDetector(
                          onTap: () {},
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: AppColor.primaryLightColor,
                                radius: 30,
                                child: data == null
                                    ? const Icon(
                                        Icons.add,
                                        color: AppColor.primaryColor,
                                      )
                                    : Image.network(
                                        data.catImg,
                                        width: 28,
                                      ),
                              ),
                              8.vertical(),
                              S14Text(
                                data != null ? data.catName : "Add",
                                maxLines: 1,
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class IconBtn extends IconButton {
  const IconBtn({
    super.key,
    required super.onPressed,
    required super.icon,
  });
}
