import 'package:dotted_border/dotted_border.dart';
import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/data_models/user_model.dart';
import 'package:salon_user/data_models/vendor_data_models.dart';

import '../../common_widgets/img_loader.dart';

class AddAppointmentScreen extends StatefulWidget {
  const AddAppointmentScreen({super.key});

  @override
  State<AddAppointmentScreen> createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  DateTime? date;
  String? time;
  UserModel? selectedUser;
  ServiceModel? selectedService;
  StaffModel? selectedStaff;
  String? finalPrice;

  void getPrice() {
    if (selectedService != null && selectedStaff != null) {
      for (var value in selectedService!.employeePriceData!) {
        if (value.employeeId == selectedStaff!.id) {
          finalPrice = value.price;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
        child: Padding(
          padding:
              const EdgeInsets.all(p16) + bottomPad,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.centerRight,
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: SText(
                      "New Appointment",
                      size: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Icon(
                      Icons.close_rounded,
                      color: AppColor.primaryColor,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 15),
                child: GestureDetector(
                  onTap: () => selectedUser != null
                      ? null
                      : Get.to(const ClientListingScreen(isBack: true))!
                          .then((value) {
                          if (value != null) {
                            setState(() => selectedUser = value);
                          }
                        }),
                  child: DottedBorder(
                    color: AppColor.grey60,
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(10),
                    dashPattern: const [7, 2],
                    strokeWidth: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: selectedUser != null
                          ? ClientWidget(
                              onTap: () => setState(
                                () => selectedUser = null,
                              ),
                              isSelect: true,
                              data: selectedUser,
                            )
                          : Row(
                              children: [
                                DecoratedBox(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColor.grey60),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.person_2_rounded,
                                      color: AppColor.grey60,
                                    ),
                                  ),
                                ),
                                10.horizontal(),
                                const Expanded(
                                  child: S14Text(
                                    "Select a client",
                                    color: AppColor.grey60,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_right_rounded,
                                  color: AppColor.grey60,
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
              const S16Text(
                "Service",
                fontWeight: FontWeight.w700,
                color: AppColor.grey100,
              ),
              GestureDetector(
                onTap: () =>
                    Get.to(const ServiceListingScreen())!.then((value) {
                  if (value != null) {
                    setState(() {
                      selectedService = value;
                      getPrice();
                    });
                  }
                }),
                child: Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColor.grey80),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.transparent,
                  ),
                  padding: const EdgeInsets.all(12),
                  child: selectedService != null
                      ? ServiceWidget(
                          onTap: () {},
                          isSelect: true,
                          serviceData: selectedService,
                        )
                      : Row(
                          children: [
                            const Icon(
                              Icons.add,
                              color: AppColor.grey80,
                            ),
                            10.horizontal(),
                            const S14Text("Select Service")
                          ],
                        ),
                ),
              ),
              const S16Text(
                "Staff",
                fontWeight: FontWeight.w700,
                color: AppColor.grey100,
              ),
              GestureDetector(
                onTap: () => Get.to(
                  const StaffListScreen(isSelection: true),
                )!
                    .then((value) {
                  if (value != null) {
                    setState(() {
                      selectedStaff = value;
                      getPrice();
                    });
                  }
                }),
                child: Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColor.grey80),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.transparent,
                  ),
                  padding: const EdgeInsets.all(12),
                  child: selectedStaff != null
                      ? Row(
                          children: [
                            ClipOval(
                              child: ImgLoader(
                                imageUrl: selectedStaff?.image ?? "",
                                height: 40,
                                boxFit: BoxFit.cover,
                                width: 40,
                              ),
                            ),
                            15.horizontal(),
                            S16Text(
                              selectedStaff?.firstName ?? "",
                              color: AppColor.grey100,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            const Icon(
                              Icons.add,
                              color: AppColor.grey80,
                            ),
                            10.horizontal(),
                            const S14Text("Select Staff Member")
                          ],
                        ),
                ),
              ),
              const S16Text(
                "Select Time",
                fontWeight: FontWeight.w700,
                color: AppColor.grey100,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.dialog(
                        CustomDatePicker(
                          onDateSelect: (p0) => setState(() => date = p0),
                          startDate: DateTime.now(),
                          focuseDay: date,
                          endDate: DateTime.now().add(
                            const Duration(days: 30),
                          ),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColor.grey80),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.transparent,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: S14Text(
                                date == null
                                    ? "Select date"
                                    : DateFormat("dd MMMM, yyyy").format(date!),
                                color: date == null
                                    ? AppColor.grey60
                                    : AppColor.grey100,
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 6, left: 10),
                          child: ColoredBox(
                            color: AppColor.white,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: SText("Date", size: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  15.horizontal(),
                  GestureDetector(
                    onTap: () {
                      Get.dialog(
                        CustomTimepicker(
                          onTimeSelect: (p0) => setState(() => time = p0),
                          selectedTime: time,
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColor.grey80),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.transparent,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: S14Text(
                                time ?? "Select start time",
                                color: time == null
                                    ? AppColor.grey60
                                    : AppColor.grey100,
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 6, left: 10),
                          child: ColoredBox(
                            color: AppColor.white,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: SText("Start time", size: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (selectedService != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SText("Total", size: 10),
                        SText(
                          "${AppStrings.rupee} ${finalPrice ?? selectedService?.price}",
                          size: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    ),
                  ),
                )
              else
                10.vertical(),
              if (selectedService != null &&
                  selectedStaff != null &&
                  selectedUser != null &&
                  date != null &&
                  time != null)
                CommonBtn(
                  text: "Save",
                  borderRad: 10,
                  onTap: () => Get.find<HomeController>().addBooking(
                    staff: selectedStaff!,
                    service: selectedService!,
                    user: selectedUser!,
                    date: date!,
                    time: time!,
                    price: finalPrice ?? selectedService?.price ?? "",
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
