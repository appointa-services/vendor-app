import 'package:dotted_border/dotted_border.dart';
import 'package:salon_user/app/utils/all_dependency.dart';

class AddAppointmentScreen extends StatefulWidget {
  const AddAppointmentScreen({super.key});

  @override
  State<AddAppointmentScreen> createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  DateTime? date;
  String? time;
  bool isClientSelect = false;
  bool isServiceSelect = false;
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
          padding: const EdgeInsets.all(p16),
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
                  onTap: () => isClientSelect
                      ? null
                      : Get.to(const ClientListingScreen(isBack: true))!
                          .then((value) {
                          if (value != null && value) {
                            setState(() => isClientSelect = value);
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
                      child: isClientSelect
                          ? ClientWidget(
                              onTap: () =>
                                  setState(() => isClientSelect = false),
                              isSelect: true,
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
                                    "Select a client or leave empty for walk-in",
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
                  if (value != null && value) {
                    setState(() => isServiceSelect = value);
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
                  child: isServiceSelect
                      ? ServiceWidget(
                          onTap: () {},
                          isSelect: true,
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
                          endDate: DateTime.now().add(const Duration(days: 30)),
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
              const Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SText("Total", size: 10),
                      SText(
                        "${AppStrings.rupee} 150",
                        size: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                ),
              ),
              CommonBtn(
                text: "Save",
                borderRad: 10,
                onTap: () => Get.back(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
