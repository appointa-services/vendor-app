import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../data_models/booking_model.dart';

class AppointmentDetailSheet extends StatelessWidget {
  final BookingModel data;

  const AppointmentDetailSheet({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    DateTime bookDate = DateTime.fromMillisecondsSinceEpoch(
      data.orderDate,
    );
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          color: AppColor.white,
        ),
        child: GetBuilder<HomeController>(
          builder: (controller) {
            return controller.isPaymentScreen
                ? PaymentOptionWidget(
                    price: data.finalPrice,
                    bookingId: data.bookingId ?? "",
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 32),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: statusColor(data.status),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  p16,
                                  p16,
                                  p16,
                                  42,
                                ),
                                child: Stack(
                                  alignment: Alignment.centerRight,
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Column(
                                        children: [
                                          S18Text(
                                            data.status == AppStrings.upcoming
                                                ? "Pending"
                                                : data.status,
                                            fontWeight: FontWeight.w600,
                                            color: AppColor.white,
                                          ),
                                          SText(
                                            data.status == AppStrings.cancelled
                                                ? data.isCancelledUser
                                                    ? "Cancelled by user"
                                                    : "Cancelled by you"
                                                : data.isBookUser
                                                    ? "Book by user"
                                                    : "Book by you",
                                            size: 10,
                                            color: AppColor.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => Get.back(),
                                      child: const Icon(
                                        Icons.close_rounded,
                                        color: AppColor.white,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            left: 0,
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              padding: const EdgeInsets.symmetric(
                                horizontal: p16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColor.grey60),
                                borderRadius: BorderRadius.circular(10),
                                color: AppColor.white,
                              ),
                              child: IntrinsicHeight(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const S12Text("Start"),
                                          5.vertical(),
                                          S16Text(
                                            DateFormat("hh:mm a")
                                                .format(bookDate),
                                            fontWeight: FontWeight.w700,
                                            color: AppColor.grey100,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const VerticalDivider(
                                      thickness: 2,
                                      color: AppColor.grey40,
                                      width: 25,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const S12Text("Date"),
                                          5.vertical(),
                                          S16Text(
                                            isSameDay(bookDate, DateTime.now())
                                                ? "Today"
                                                : DateFormat("dd, MMM yyyy")
                                                    .format(bookDate),
                                            fontWeight: FontWeight.w700,
                                            color: AppColor.grey100,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(p16) +
                            bottomPad,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ClientWidget(
                              data: Get.find<DashboardController>()
                                  .userList
                                  .firstWhere(
                                    (element) => element.id == data.userId,
                                  ),
                              onTap: () {},
                            ),
                            IntrinsicHeight(
                              child: Row(
                                children: [
                                  const VerticalDivider(
                                    thickness: 2,
                                    width: 0,
                                    color: AppColor.grey40,
                                  ),
                                  15.horizontal(),
                                  S16Text(
                                    data.employeeName,
                                    color: AppColor.grey100,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ],
                              ),
                            ),
                            const Divider(color: AppColor.grey20, height: 25),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: data.serviceList.length,
                              padding: EdgeInsets.zero,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const SizedBox(height: 10);
                              },
                              itemBuilder: (context, index) {
                                BookingServiceModel bookData =
                                    data.serviceList[index];
                                return IntrinsicHeight(
                                  child: Row(
                                    children: [
                                      const VerticalDivider(
                                        thickness: 2,
                                        width: 0,
                                        color: AppColor.grey40,
                                      ),
                                      15.horizontal(),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          S16Text(
                                            bookData.serviceName,
                                            color: AppColor.grey100,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          S12Text(
                                            "${DateFormat("hh:mm a").format(bookDate)}"
                                            " - ${DateFormat("hh:mm a").format(
                                              bookDate.add(
                                                Duration(
                                                  minutes: bookData.serviceTime,
                                                ),
                                              ),
                                            )} •"
                                            " ${bookData.serviceTime} min",
                                          )
                                        ],
                                      ),
                                      const Spacer(),
                                      S16Text(
                                        "${AppStrings.rupee} ${bookData.price}",
                                        fontWeight: FontWeight.w700,
                                        color: AppColor.primaryColor,
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                            const Divider(color: AppColor.grey20, height: 25),
                            if (data.discountData != null)
                              Align(
                                alignment: Alignment.centerRight,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SText(
                                      "Discount",
                                      size: 10,
                                      color: AppColor.grey80,
                                    ),
                                    S16Text(
                                      "-${data.discountData?.discount}%",
                                      fontWeight: FontWeight.w700,
                                      color: AppColor.grey100,
                                    ),
                                  ],
                                ),
                              ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: data.discountData != null ? 10 : 0,
                                bottom:
                                    data.status == AppStrings.upcoming ? 18 : 0,
                              ),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SText(
                                      "Total",
                                      size: 10,
                                      color: AppColor.grey80,
                                    ),
                                    S16Text(
                                      "${AppStrings.rupee} ${data.finalPrice}",
                                      fontWeight: FontWeight.w700,
                                      color: AppColor.grey100,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (data.status == AppStrings.upcoming)
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => Get.bottomSheet(
                                      CommonDialog(
                                        title: AppStrings.cancelBook,
                                        desc: AppStrings.areUSUreCancel,
                                        yesBtnString: AppStrings.yesCancel,
                                        onYesTap: () =>
                                            controller.changeBookingStatus(
                                          data.bookingId ?? "",
                                          AppStrings.cancelled,
                                        ),
                                      ),
                                    ),
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        border:
                                            Border.all(color: AppColor.grey80),
                                        borderRadius: BorderRadius.circular(8),
                                        color: AppColor.white,
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(12),
                                        child: Icon(
                                          Icons.delete_outline_rounded,
                                          color: AppColor.grey100,
                                        ),
                                      ),
                                    ),
                                  ),
                                  12.horizontal(),
                                  Expanded(
                                    child: CommonBtn(
                                      text: "Checkout",
                                      borderRad: 10,
                                      onTap: () {
                                        Get.find<HomeController>()
                                            .isPaymentScreen = true;
                                        Get.find<HomeController>().update();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }
}
