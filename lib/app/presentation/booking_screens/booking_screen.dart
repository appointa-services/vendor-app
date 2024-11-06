import 'package:dotted_line/dotted_line.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:salon_user/app/common_widgets/image_network.dart';
import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/data_models/booking_model.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  BookingController controller = Get.put(BookingController());
  RefreshController refreshController = RefreshController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (Get.find<DashboardController>().isBookingLoad.value) {
        await controller.getBooking();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(() {
        return Padding(
          padding: const EdgeInsets.only(top: p16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: p16),
                child: S24Text(AppStrings.myBooking),
              ),
              20.vertical(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: p16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppStrings.upcoming,
                    AppStrings.completed,
                    AppStrings.cancelled,
                  ]
                      .map(
                        (e) => SizedBox(
                          width: (MediaQuery.sizeOf(context).width - 52) / 3,
                          child: CategoryWidget(
                            onTap: () => controller.changeStatus(e),
                            cat: e,
                            isSelected: controller.selectedBooking.value == e,
                            isBookingScreen: true,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              10.vertical(),
              Expanded(
                child: SmartRefresher(
                  controller: refreshController,
                  onRefresh: () {
                    controller.getBooking();
                    refreshController.refreshCompleted();
                  },
                  child: controller.filteredBookingList.isEmpty &&
                          !controller.isLoad.value
                      ? Center(
                          child: S16Text(
                            "No ${controller.selectedBooking.value.toLowerCase()} booking found",
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.filteredBookingList.length,
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: p16,
                          ),
                          itemBuilder: (context, index) {
                            BookingModel data =
                                controller.filteredBookingList[index];
                            return GestureDetector(
                              onTap: () => showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                ),
                                builder: (context) {
                                  return BookingDetailSheet(data: data);
                                },
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColor.white,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: AppColor.grey20,
                                      blurRadius: 2,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                margin: const EdgeInsets.only(bottom: 15),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: p16,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        S12Text(
                                          DateFormat(
                                            "hh:mm a 'at' dd MMMM, yyyy",
                                          ).format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                              data.orderDate,
                                            ),
                                          ),
                                          fontWeight: FontWeight.w600,
                                        ),
                                        if (controller.selectedBooking.value !=
                                            AppStrings.upcoming)
                                          DecoratedBox(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: controller.selectedBooking
                                                          .value ==
                                                      AppStrings.cancelled
                                                  ? AppColor.orange
                                                  : AppColor.primaryColor,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: SText(
                                                controller
                                                    .selectedBooking.value,
                                                size: 10,
                                                color: AppColor.white,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    const Divider(height: 20),
                                    S16Text(
                                      data.businessData?.vendorName ?? "",
                                      fontWeight: FontWeight.w700,
                                    ),
                                    S14Text(
                                      data.businessData?.vendorAddress ?? "",
                                      color: AppColor.grey60,
                                    ),
                                    5.vertical(),
                                    S14Text(
                                      listToString(
                                        data.serviceList
                                            .map((e) => e.serviceName)
                                            .toList(),
                                        comaReplacer: " +",
                                      ),
                                      color: AppColor.grey80,
                                    ),
                                    S14Text(
                                      data.finalPrice,
                                      color: AppColor.grey100,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    (controller.selectedBooking.value !=
                                                AppStrings.cancelled
                                            ? 15
                                            : 0)
                                        .vertical(),
                                    controller.selectedBooking.value !=
                                            AppStrings.cancelled
                                        ? Row(
                                            children: [
                                              Expanded(
                                                child: controller
                                                            .selectedBooking
                                                            .value ==
                                                        AppStrings.completed
                                                    ? const SizedBox()
                                                    : CommonBtn(
                                                        isBoxShadow: false,
                                                        text: AppStrings
                                                            .cancelBook,
                                                        btnColor: const Color
                                                            .fromARGB(
                                                          0,
                                                          153,
                                                          131,
                                                          131,
                                                        ),
                                                        textColor:
                                                            AppColor.redColor,
                                                        borderColor:
                                                            Colors.transparent,
                                                        vertPad: 8,
                                                        borderRad: 8,
                                                        textSize: 14,
                                                        onTap: () =>
                                                            Get.bottomSheet(
                                                          CommonDialog(
                                                            title: AppStrings
                                                                .cancelBook,
                                                            desc: AppStrings
                                                                .areUSUreCancel,
                                                            yesBtnString:
                                                                AppStrings
                                                                    .yesCancel,
                                                            onYesTap: () =>
                                                                controller
                                                                    .changeBookingStatus(
                                                              data.bookingId ??
                                                                  "",
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                              ),
                                              10.horizontal(),
                                              Expanded(
                                                child: CommonBtn(
                                                  isBoxShadow: false,
                                                  text: controller
                                                              .selectedBooking
                                                              .value ==
                                                          AppStrings.completed
                                                      ? AppStrings.reorder
                                                      : AppStrings.getDirection,
                                                  btnColor:
                                                      const Color.fromARGB(
                                                    0,
                                                    153,
                                                    131,
                                                    131,
                                                  ),
                                                  textColor:
                                                      AppColor.primaryColor,
                                                  vertPad: 8,
                                                  borderRad: 8,
                                                  textSize: 14,
                                                  onTap: () {
                                                    if (controller
                                                            .selectedBooking
                                                            .value !=
                                                        AppStrings.completed) {
                                                      MapsLauncher
                                                          .launchCoordinates(
                                                        data.businessData
                                                                ?.latitude ??
                                                            22.75481,
                                                        data.businessData
                                                                ?.longitude ??
                                                            73.511554,
                                                        data.businessData
                                                                ?.vendorName ??
                                                            'Salon is here',
                                                      );
                                                    } else {
                                                      VendorNBookingController
                                                          controller = Get.put(
                                                        VendorNBookingController(
                                                          isBookingScreen: true,
                                                        ),
                                                      );
                                                      controller
                                                          .selectedSpecialist
                                                          .value = 0;
                                                      // controller
                                                      //   ..selectRemoveService()
                                                      //   ..selectRemoveService(id: "")
                                                      //   ..update();
                                                      Get.toNamed(AppRoutes
                                                          .bookService);
                                                    }
                                                  },
                                                ),
                                              ),
                                            ],
                                          )
                                        : const SizedBox()
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class BookingDetailSheet extends StatelessWidget {
  final BookingModel data;

  const BookingDetailSheet({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    DateTime bookDate = DateTime.fromMillisecondsSinceEpoch(data.orderDate);
    return Padding(
      padding: const EdgeInsets.all(p16) +
          EdgeInsets.only(
            bottom: MediaQuery.paddingOf(context).bottom / 2,
          ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const S24Text("Booking Details"),
              if (data.status != AppStrings.upcoming)
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: data.status == AppStrings.cancelled
                        ? AppColor.orange
                        : AppColor.primaryColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: SText(
                      data.status,
                      size: 10,
                      color: AppColor.white,
                    ),
                  ),
                )
            ],
          ),
          const Divider(),
          10.vertical(),
          widget(
            Icons.calendar_month,
            DateFormat("MMMM, dd yyyy").format(bookDate),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: widget(
              Icons.access_time_rounded,
              "${DateFormat("hh:mm a").format(bookDate)} (${data.duration} min duration)",
            ),
          ),
          GestureDetector(
            onTap: () => MapsLauncher.launchCoordinates(
              data.businessData?.latitude ?? 22.75481,
              data.businessData?.longitude ?? 73.511554,
              data.businessData?.vendorName ?? "Saloon is here",
            ),
            child: widget(
              Icons.location_on_rounded,
              data.businessData?.vendorAddress ?? "",
            ),
          ),
          const Divider(color: AppColor.grey40, height: 20),
          const S16Text(
            "Staff member",
            fontWeight: FontWeight.w500,
            color: AppColor.grey80,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5, top: 5),
            child: Row(
              children: [
                ClipOval(
                  child: ImageNet(
                    data.employeeImg,
                    height: 40,
                    width: 40,
                    boxFit: BoxFit.cover,
                  ),
                ),
                10.horizontal(),
                S14Text(
                  data.employeeName,
                  fontWeight: FontWeight.w600,
                  color: AppColor.grey100,
                ),
              ],
            ),
          ),
          const Divider(color: AppColor.grey40, height: 20),
          const S16Text(
            "Services",
            fontWeight: FontWeight.w500,
            color: AppColor.grey80,
          ),
          ...data.serviceList.map(
            (e) => Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  S14Text(
                    e.serviceName,
                    fontWeight: FontWeight.w600,
                    color: AppColor.grey100,
                  ),
                  S14Text(
                    "${AppStrings.rupee}${e.price}",
                    fontWeight: FontWeight.w800,
                    color: AppColor.primaryColor,
                  ),
                ],
              ),
            ),
          ),
          if (data.discountData != null)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: DottedLine(
                dashColor: AppColor.grey40,
              ),
            ),
          if (data.discountData != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                S14Text(
                  "Discount (#${data.discountData?.discountCode})",
                  fontWeight: FontWeight.w800,
                  color: AppColor.grey100,
                ),
                S14Text(
                  "-${data.discountData?.discount}%",
                  fontWeight: FontWeight.w800,
                  color: AppColor.primaryColor,
                ),
              ],
            ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const S14Text(
                "Total",
                fontWeight: FontWeight.w800,
                color: AppColor.grey100,
              ),
              S14Text(
                data.discountData != null
                    ? (int.parse(data.finalPrice) * 0.9).toInt().toString()
                    : data.finalPrice,
                fontWeight: FontWeight.w800,
                color: AppColor.primaryColor,
              ),
            ],
          ),
          if (data.status == AppStrings.upcoming)
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: CommonBtn(
                text: AppStrings.cancelBook,
                onTap: () => Get.bottomSheet(
                  CommonDialog(
                    title: AppStrings.cancelBook,
                    desc: AppStrings.areUSUreCancel,
                    yesBtnString: AppStrings.yesCancel,
                    onYesTap: () =>
                        Get.find<BookingController>().changeBookingStatus(
                      data.bookingId ?? "",
                      isBackTwice: true,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget widget(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColor.grey80,
          size: 18,
        ),
        5.horizontal(),
        Expanded(
          child: S14Text(
            text,
            color: AppColor.primaryColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
