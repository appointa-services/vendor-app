import 'package:flutter/widgets.dart';
import 'package:salon_user/app/utils/all_dependency.dart';

class ClientDetailScreen extends StatelessWidget {
  const ClientDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonAppbar(
      title: "",
      isDivider: false,
      appbarSuffix: TextButton(
        onPressed: () => Get.toNamed(AppRoutes.addClientScreen),
        style: const ButtonStyle(
          overlayColor: MaterialStatePropertyAll(Colors.transparent),
        ),
        child: const S14Text("Edit"),
      ),
      padd: const EdgeInsets.symmetric(horizontal: p16),
      children: [
        Expanded(
          child: ListView(
            primary: false,
            children: [
              const Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 45,
                  backgroundImage: AssetImage(AppAssets.dummyPerson1),
                  backgroundColor: AppColor.grey20,
                ),
              ),
              10.vertical(),
              const S24Text(
                "Client Name",
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w600,
              ),
              20.vertical(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    backgroundColor: AppColor.primaryColor,
                    child: Icon(
                      Icons.call,
                      size: 20,
                      color: AppColor.white,
                    ),
                  ),
                  25.horizontal(),
                  const CircleAvatar(
                    backgroundColor: AppColor.primaryColor,
                    child: Icon(
                      Icons.email_rounded,
                      size: 20,
                      color: AppColor.white,
                    ),
                  ),
                ],
              ),
              15.vertical(),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            S12Text("Total Appointment"),
                            SText(
                              "5",
                              size: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ],
                        ),
                      ),
                      VerticalDivider(
                        thickness: 1,
                        color: AppColor.grey100,
                        width: 30,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            S12Text("Total Revenue"),
                            SText(
                              "${AppStrings.rupee} 500",
                              size: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              20.vertical(),
              const S18Text(
                "Appointment",
                fontWeight: FontWeight.w700,
                color: AppColor.grey100,
              ),
              ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 15),
                itemCount: 5,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          const Column(
                            children: [
                              S12Text(
                                "Jul",
                                color: AppColor.grey100,
                              ),
                              S18Text(
                                "14",
                                fontWeight: FontWeight.w700,
                              ),
                              S14Text(
                                "10:30 AM",
                                color: AppColor.grey100,
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.all(5),
                            child: VerticalDivider(
                              thickness: 2,
                              color: AppColor.grey40,
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      DecoratedBox(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: index == 0
                                              ? Colors.orange.withOpacity(0.1)
                                              : index % 2 == 0
                                                  ? Colors.red.withOpacity(0.1)
                                                  : Colors.green
                                                      .withOpacity(0.1),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 3,
                                          ),
                                          child: SText(
                                            index == 0
                                                ? "Upcoming"
                                                : index % 2 == 0
                                                    ? "Cancelled"
                                                    : "Finished",
                                            size: 8,
                                            fontWeight: FontWeight.w700,
                                            color: index == 0
                                                ? Colors.orange
                                                : index % 2 == 0
                                                    ? Colors.red
                                                    : Colors.green,
                                          ),
                                        ),
                                      ),
                                      const S16Text(
                                        "Beard Shave",
                                        fontWeight: FontWeight.w600,
                                        color: AppColor.grey100,
                                      ),
                                      const S12Text("Employee name  •  30 min")
                                    ],
                                  ),
                                ),
                                const S18Text("${AppStrings.rupee} 100")
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
