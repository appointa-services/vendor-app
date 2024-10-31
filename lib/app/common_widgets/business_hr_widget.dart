import 'package:flutter/cupertino.dart';
import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/data_models/vendor_data_models.dart';

class BusinessHrWidget extends StatelessWidget {
  final IntervalModel data;
  final int index;
  const BusinessHrWidget({super.key, required this.data, required this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => Get.to(
            AddIntervalScreen(data: data, index: index),
            transition: Transition.rightToLeftWithFade,
          ),
          child: ColoredBox(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: S16Text(
                      data.day,
                      color: AppColor.grey100,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: S16Text(
                      data.isClosed
                          ? "Closed"
                          : "${data.data?.startTime} - ${data.data?.endTime}",
                      color: AppColor.grey100,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
        const Divider(color: AppColor.grey40)
      ],
    );
  }
}

class VerticalPicker extends StatefulWidget {
  final List<String> list;
  final String selectedTime;
  final bool isUpdate;
  final Function(String value) onChange;
  const VerticalPicker({
    super.key,
    required this.list,
    required this.selectedTime,
    required this.onChange,
    this.isUpdate = false,
  });

  @override
  State<VerticalPicker> createState() => _VerticalPickerState();
}

class _VerticalPickerState extends State<VerticalPicker> {
  FixedExtentScrollController controller = FixedExtentScrollController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.jumpToItem(
        widget.list.indexOf(widget.selectedTime),
      );
    });
    super.initState();
  }

  // @override
  // void didUpdateWidget(covariant VerticalPicker oldWidget) {
  //   if (widget.isUpdate) {
  //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //       controller.jumpToItem(
  //         widget.list.indexOf(widget.selectedTime),
  //       );
  //     });
  //     "--MMM ${widget.selectedTime}".print();
  //   }
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CupertinoPicker(
        scrollController: controller,
        onSelectedItemChanged: (p0) => widget.onChange(widget.list[p0]),
        selectionOverlay: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColor.primaryColor,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        itemExtent: 50,
        magnification: 1.1,
        diameterRatio: 2,
        squeeze: 1.2,
        children: widget.list
            .map(
              (e) => Center(
                child: widget.selectedTime == e
                    ? S16Text(
                        e,
                        fontWeight: FontWeight.w600,
                      )
                    : S14Text(e),
              ),
            )
            .toList(),
      ),
    );
  }
}
