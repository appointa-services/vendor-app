import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/data_models/vendor_data_models.dart';

class AddIntervalScreen extends StatefulWidget {
  final IntervalModel data;
  final int index;

  const AddIntervalScreen({super.key, required this.data, required this.index});

  @override
  State<AddIntervalScreen> createState() => _AddIntervalScreenState();
}

class _AddIntervalScreenState extends State<AddIntervalScreen> {
  AuthController controller = Get.find<AuthController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.addTime();
      controller.isClose = widget.data.isClosed;
      controller.selectedStartTime = widget.data.isClosed
          ? "10:00 AM"
          : widget.data.data?.startTime ?? "10:00 AM";
      controller.selectedEndTime = widget.data.isClosed
          ? "07:00 PM"
          : widget.data.data?.endTime ?? "07:00 PM";
      controller.breaksList =
          widget.data.isClosed ? [] : widget.data.data?.breakList ?? [];
      controller.update();
    });
    "-->>>> ${widget.data.toJson()}".print;
    super.initState();
  }

  @override
  void dispose() {
    controller.selectedStartTime = "10:00 AM";
    controller.selectedEndTime = "07:00 PM";
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: IntrinsicHeight(
        child: Padding(
          padding: const EdgeInsets.all(p16) + bottomPad,
          child: GetBuilder<AuthController>(
            builder: (controller) {
              return CommonBtn(
                borderColor: AppColor.grey100,
                btnColor: AppColor.grey100,
                text: "Save",
                onTap: () {
                  if (compareTimes(
                    controller.selectedStartTime,
                    controller.selectedEndTime,
                  )) {
                    IntervalModel data = IntervalModel(
                      day: widget.data.day,
                      isClosed: controller.isClose,
                      data: controller.isClose
                          ? null
                          : DayDatModel(
                              startTime: controller.selectedStartTime,
                              endTime: controller.selectedEndTime,
                              breakList: controller.breaksList,
                            ),
                    );
                    controller
                      ..intervalList.removeAt(widget.index)
                      ..intervalList.insert(widget.index, data)
                      ..update();
                    Get.back();
                  } else {
                    showSnackBar(
                      "The start time must be later than the end time.",
                    );
                  }
                },
              );
            },
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: p16, left: p16),
              child: GestureDetector(
                onTap: () => Get.back(),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  size: 25,
                  color: AppColor.grey100,
                ),
              ),
            ),
            20.vertical(),
            GetBuilder<AuthController>(
              builder: (controller) {
                return Expanded(
                  child: ListView(
                    primary: false,
                    padding: const EdgeInsets.symmetric(horizontal: p16),
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SText(
                            widget.data.day,
                            size: 26,
                            fontWeight: FontWeight.w700,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: SText(
                              controller.isClose ? "Close" : "Open",
                              size: 10,
                            ),
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CustomSwitch(
                                value: !controller.isClose,
                                onChanged: (value) {
                                  controller.isClose = !value;
                                  controller.update();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (!controller.isClose)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: SizedBox(
                            height: 250,
                            child: Row(
                              children: [
                                VerticalPicker(
                                  list: controller.toTimeList,
                                  selectedTime: controller.selectedStartTime,
                                  onChange: (value) {
                                    controller.selectedStartTime = value;
                                    controller.update();
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
                                  list: controller.toTimeList,
                                  selectedTime: controller.selectedEndTime,
                                  onChange: (value) {
                                    controller.selectedEndTime = value;
                                    controller.update();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (!controller.isClose)
                        const S18Text(
                          AppStrings.breaks,
                          fontWeight: FontWeight.w700,
                        ),
                      if (!controller.isClose)
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.breaksList.length + 1,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            bool isAdd = index == controller.breaksList.length;
                            BreakModel? data;
                            if (!isAdd) {
                              data = controller.breaksList[index];
                            }
                            return GestureDetector(
                              onTap: () {
                                Get.bottomSheet(
                                  AddBreakSheet(
                                    fromTime: data?.endTime,
                                    toTime: data?.startTime,
                                    onTap: (_) {
                                      if (isAdd) {
                                        controller
                                          ..breaksList.add(_)
                                          ..update();
                                      } else {
                                        controller
                                          ..breaksList.removeAt(index)
                                          ..breaksList.insert(index, _)
                                          ..update();
                                      }
                                    },
                                  ),
                                );
                              },
                              child: ColoredBox(
                                color: Colors.transparent,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Row(
                                        mainAxisAlignment: isAdd
                                            ? MainAxisAlignment.start
                                            : MainAxisAlignment.spaceBetween,
                                        children: isAdd
                                            ? [
                                                const Icon(
                                                  Icons.add,
                                                  color: AppColor.primaryColor,
                                                ),
                                                15.horizontal(),
                                                const S16Text("Add break"),
                                              ]
                                            : [
                                                S16Text(
                                                  "${data!.startTime}"
                                                  " - ${data.endTime}",
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    controller
                                                      ..breaksList
                                                          .removeAt(index)
                                                      ..update();
                                                  },
                                                  child: const Icon(
                                                    Icons.delete,
                                                    size: 18,
                                                    color: AppColor.redColor,
                                                  ),
                                                ),
                                              ],
                                      ),
                                    ),
                                    const Divider()
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
