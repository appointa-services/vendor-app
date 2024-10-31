import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderWidget extends StatefulWidget {
  final Function(DateTime date) onDateSelect;
  final Function(DateTime date)? onPageChange;
  final DateTime? focusedDay;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isDecorated;

  const CalenderWidget({
    super.key,
    required this.onDateSelect,
    this.focusedDay,
    this.isDecorated = true,
    this.startDate,
    this.endDate,
    this.onPageChange,
  });

  @override
  State<CalenderWidget> createState() => _CalenderWidgetState();
}

class _CalenderWidgetState extends State<CalenderWidget> {
  DateTime focusedDay = DateTime.now();

  @override
  void initState() {
    focusedDay = widget.focusedDay ?? DateTime.now();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CalenderWidget oldWidget) {
    setState(() {
      focusedDay = widget.focusedDay ?? DateTime.now();
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: widget.isDecorated ? 60 : 0),
      child: Card(
        color: Colors.white,
        elevation: widget.isDecorated ? 5 : 0,
        shadowColor: AppColor.grey20,
        surfaceTintColor: AppColor.white,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [

              TableCalendar(
                firstDay: widget.startDate ?? DateTime.utc(2024, 1, 1),
                lastDay: widget.endDate ?? DateTime.now().add(const Duration(days: 30)),
                focusedDay: focusedDay,
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    color: AppColor.grey100,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                calendarStyle: const CalendarStyle(
                  defaultTextStyle: TextStyle(
                    color: AppColor.grey100,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  todayTextStyle: TextStyle(
                    color: AppColor.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  todayDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.grey100,
                  ),
                ),
                onPageChanged: (focuseDay) {
                  setState(() {
                    focusedDay = focuseDay;
                  });
                  if (widget.onPageChange != null) {
                    widget.onPageChange!(focuseDay);
                  }
                },
                currentDay: focusedDay,
                onDaySelected: (selectedDay, focuseDay) {
                  setState(() {
                    focusedDay = focuseDay;
                  });
                  widget.onDateSelect(focuseDay);
                },
                headerVisible: true,
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  titleTextFormatter: (date, locale) => DateFormat("dd MMM, yyyy").format(date),
                  formatButtonVisible: false,
                  formatButtonDecoration: BoxDecoration(
                    border: Border.all(color: AppColor.grey60),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.transparent,
                  ),
                  formatButtonPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomDatePicker extends StatefulWidget {
  final Function(DateTime) onDateSelect;
  final DateTime? focuseDay;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isHeader;

  const CustomDatePicker({
    super.key,
    required this.onDateSelect,
    this.focuseDay,
    this.startDate,
    this.endDate,
    this.isHeader = false,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime focusedDay = DateTime.now();

  @override
  void initState() {
    focusedDay = widget.focuseDay ?? DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: p16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                15.vertical(),
                const S24Text("Select Date"),
                CalenderWidget(
                  onDateSelect: (date) {
                    setState(() {
                      focusedDay = date;
                    });
                  },
                  onPageChange: (date) {
                    setState(() {
                      if (date.month == DateTime.now().month) {
                        focusedDay = DateTime.now();
                      } else {
                        focusedDay = date;
                      }
                    });
                  },
                  isDecorated: widget.isHeader,
                  endDate: widget.endDate,
                  focusedDay: focusedDay,
                  startDate: widget.startDate,
                ),
                Padding(
                  padding: const EdgeInsets.all(p16),
                  child: Row(
                    children: [
                      Expanded(
                        child: CommonBtn(
                          text: "Cancel",
                          borderRad: 10,
                          borderColor: AppColor.grey100,
                          btnColor: Colors.white,
                          textColor: AppColor.grey100,
                          onTap: () => Get.back(),
                        ),
                      ),
                      10.horizontal(),
                      Expanded(
                        child: CommonBtn(
                          text: "Select",
                          borderRad: 10,
                          onTap: () {
                            widget.onDateSelect(focusedDay);
                            Get.back();
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTimepicker extends StatefulWidget {
  final Function(String) onTimeSelect;
  final String? selectedTime;

  const CustomTimepicker({
    super.key,
    required this.onTimeSelect,
    this.selectedTime,
  });

  @override
  State<CustomTimepicker> createState() => _CustomTimepickerState();
}

class _CustomTimepickerState extends State<CustomTimepicker> {
  String selctedToTime = "10:00 AM";
  List<String> toTimeList = [];

  void addTime() {
    toTimeList.clear();
    for (int i = 0; i < 288; i++) {
      Duration duration = Duration(
        hours: i ~/ 12,
        minutes: (i.remainder(12) + 1) * 5,
      );
      DateTime dateTime = DateTime(0, 1, 1).add(duration);
      String formattedTime = DateFormat('hh:mm a').format(dateTime);
      toTimeList.add(formattedTime);
    }
  }

  @override
  void initState() {
    selctedToTime = widget.selectedTime ?? "10:00 AM";
    addTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: p16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                15.vertical(),
                const S24Text("Select Time"),
                SizedBox(
                  height: 200,
                  width: 150,
                  child: Row(
                    children: [
                      VerticalPicker(
                        list: toTimeList,
                        selectedTime: selctedToTime,
                        onChange: (value) => setState(() => selctedToTime = value),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(p16),
                  child: Row(
                    children: [
                      Expanded(
                        child: CommonBtn(
                          text: "Cancel",
                          borderRad: 10,
                          borderColor: AppColor.grey100,
                          btnColor: Colors.white,
                          textColor: AppColor.grey100,
                          onTap: () => Get.back(),
                        ),
                      ),
                      10.horizontal(),
                      Expanded(
                        child: CommonBtn(
                          text: "Select",
                          borderRad: 10,
                          onTap: () {
                            widget.onTimeSelect(selctedToTime);
                            Get.back();
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
