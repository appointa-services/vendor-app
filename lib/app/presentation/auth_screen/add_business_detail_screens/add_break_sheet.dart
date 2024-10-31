import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/data_models/vendor_data_models.dart';

class AddBreakSheet extends StatefulWidget {
  final String? toTime;
  final String? fromTime;
  final Function(BreakModel data) onTap;
  const AddBreakSheet({
    super.key,
    this.toTime,
    this.fromTime,
    required this.onTap,
  });

  @override
  State<AddBreakSheet> createState() => _AddBreakSheetState();
}

class _AddBreakSheetState extends State<AddBreakSheet> {
  AuthController controller = Get.find<AuthController>();
  List<String> toTime = [];
  List<String> fromTime = [];
  String selectedToTime = "";
  String selectedFromTime = "";

  @override
  void initState() {
    for (int i = 0; i < 288; i++) {
      int startIndex =
          controller.toTimeList.indexOf(controller.selectedStartTime);
      int endIndex = controller.toTimeList.indexOf(controller.selectedEndTime);
      if (startIndex < i && endIndex >= i) {
        toTime.add(controller.toTimeList[i]);
        fromTime.add(controller.toTimeList[i]);
      }
    }
    selectedToTime = widget.toTime ?? toTime[toTime.length ~/ 2];
    selectedFromTime = widget.fromTime ?? fromTime[(fromTime.length ~/ 2) + 1];
    super.initState();
  }

  // String toTime = ;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
      child: ColoredBox(
        color: AppColor.white,
        child: Padding(
          padding: const EdgeInsets.all(p16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SText(
                "Monday ● Breaks",
                size: 26,
                fontWeight: FontWeight.w700,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: SizedBox(
                  height: 200,
                  child: Row(
                    children: [
                      VerticalPicker(
                        list: toTime,
                        selectedTime: selectedToTime,
                        onChange: (value) {
                          setState(() {
                            selectedToTime = value;
                          });
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.all(5),
                        child: Icon(
                          Icons.remove,
                          color: AppColor.primaryColor,
                        ),
                      ),
                      VerticalPicker(
                        list: fromTime,
                        selectedTime: selectedFromTime,
                        onChange: (value) {
                          setState(() {
                            selectedFromTime = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              CommonBtn(
                text: "Add",
                borderRad: 10,
                onTap: () {
                  if (compareTimes(selectedToTime, selectedFromTime)) {
                    widget.onTap(
                      BreakModel(
                        endTime: selectedFromTime,
                        startTime: selectedToTime,
                      ),
                    );
                    Get.back();
                  } else {
                    showSnackBar(
                      "The start time must be later than the end time.",
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
