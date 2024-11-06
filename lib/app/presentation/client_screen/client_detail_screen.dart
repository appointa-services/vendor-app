import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/data_models/booking_model.dart';
import 'package:salon_user/data_models/user_model.dart';

import '../../common_widgets/image_network.dart';

class ClientDetailScreen extends StatelessWidget {
  const ClientDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClientController>(
      builder: (controller) {
        UserModel data = controller.selectedUser;
        return CommonAppbar(
          title: "",
          isDivider: false,
          appbarSuffix: data.isUserByVendor
              ? TextButton(
                  onPressed: () {
                    controller
                      ..email.text = data.email
                      ..name.text = data.name
                      ..mobile.text = data.mobile
                      ..isEdit.value = true;
                    Get.toNamed(AppRoutes.addClientScreen);
                  },
                  style: const ButtonStyle(
                    overlayColor: WidgetStatePropertyAll(Colors.transparent),
                  ),
                  child: const S14Text("Edit"),
                )
              : null,
          padd: const EdgeInsets.symmetric(horizontal: p16),
          children: [
            Expanded(
              child: ListView(
                primary: false,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: ClipOval(
                      child: data.image == null ||
                              data.image != null ||
                              data.image!.isEmpty
                          ? const CircleAvatar(
                              radius: 45,
                              backgroundColor: AppColor.grey40,
                            )
                          : ImageNet(
                              data.image ?? "",
                              height: 90,
                              width: 90,
                            ),
                    ),
                  ),
                  10.vertical(),
                  S24Text(
                    data.name,
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
                      if (data.email.isNotEmpty) 25.horizontal(),
                      if (data.email.isNotEmpty)
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
                  if (controller.bookingList.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IntrinsicHeight(
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const S12Text("Total Appointment"),
                                  SText(
                                    controller.bookingList.length.toString(),
                                    size: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ],
                              ),
                            ),
                            const VerticalDivider(
                              thickness: 1,
                              color: AppColor.grey100,
                              width: 30,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const S12Text("Total Revenue"),
                                  SText(
                                    "${AppStrings.rupee} ${controller.totalUserRevenue}",
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
                  if (controller.bookingList.isNotEmpty)
                    20.vertical()
                  else
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.1,
                      width: double.infinity,
                      child: const Center(
                        child: S16Text(
                          "No appointment yet",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  if (controller.bookingList.isNotEmpty)
                    const S18Text(
                      "Appointment",
                      fontWeight: FontWeight.w700,
                      color: AppColor.grey100,
                    ),
                  if (controller.bookingList.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      itemCount: controller.bookingList.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        BookingModel data = controller.bookingList[index];
                        DateTime orderDate =
                            DateTime.fromMillisecondsSinceEpoch(data.orderDate);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: IntrinsicHeight(
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    S12Text(
                                      DateFormat("MMM").format(orderDate),
                                      color: AppColor.grey100,
                                    ),
                                    S18Text(
                                      DateFormat("dd").format(orderDate),
                                      fontWeight: FontWeight.w700,
                                    ),
                                    S14Text(
                                      DateFormat("hh:mm a").format(orderDate),
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
                                                color: statusColor(data.status)
                                                    .withOpacity(0.1),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 3,
                                                ),
                                                child: SText(
                                                  data.status ==
                                                          AppStrings.upcoming
                                                      ? "Pending"
                                                      : data.status,
                                                  size: 8,
                                                  fontWeight: FontWeight.w700,
                                                  color:
                                                      statusColor(data.status),
                                                ),
                                              ),
                                            ),
                                            S16Text(
                                              listToString(
                                                  data.serviceList
                                                      .map((e) => e.serviceName)
                                                      .toList(),
                                                  comaReplacer: " +"),
                                              fontWeight: FontWeight.w600,
                                              color: AppColor.grey100,
                                            ),
                                            S12Text(
                                              "${data.employeeName}  •  ${data.duration} min",
                                            )
                                          ],
                                        ),
                                      ),
                                      S18Text(
                                        "${AppStrings.rupee} ${data.finalPrice}",
                                      )
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
      },
    );
  }
}
