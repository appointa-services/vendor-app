import 'package:salon_user/app/utils/all_dependency.dart';

class CustomTimePickerDialog extends StatefulWidget {
  final Function(int time) onTap;
  final int? time;
  const CustomTimePickerDialog({super.key, required this.onTap, this.time});

  @override
  State<CustomTimePickerDialog> createState() => _CustomTimePickerDialogState();
}

class _CustomTimePickerDialogState extends State<CustomTimePickerDialog> {
  TextEditingController hr = TextEditingController();
  TextEditingController min = TextEditingController();

  @override
  void initState() {
    if (widget.time != null && widget.time != 0) {
      int time = widget.time!;
      hr.text = (time ~/ 60).toString();
      min.text = time.remainder(60).toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      backgroundColor: AppColor.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.all(15),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Select your service Time",
            style: TextStyle(
              fontSize: size.width * 0.045,
              fontWeight: FontWeight.bold,
            ),
          ),
          15.vertical(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    CommonTextfield(
                      controller: hr,
                      hintText: "In hours..",
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2)
                      ],
                    ),
                    if (widget.time != null)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 18, right: 10),
                        child: S16Text(
                          "hr",
                          color: AppColor.grey100,
                        ),
                      ),
                  ],
                ),
              ),
              10.horizontal(),
              Expanded(
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    CommonTextfield(
                      controller: min,
                      hintText: "In minutes...",
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2)
                      ],
                    ),
                    if (widget.time != null)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 18, right: 10),
                        child: S16Text(
                          "min",
                          color: AppColor.grey100,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          20.vertical(),
          CommonBtn(
            text: "Continue",
            onTap: () {
              if (hr.text.isEmpty && min.text.isEmpty) {
                showSnackBar("Please enter service time");
              } else {
                int time = 0;
                if (hr.text != '') {
                  time = int.parse(hr.text) * 60;
                }
                if (min.text != '') {
                  time += int.parse(min.text);
                }
                widget.onTap(time);
              }
            },
            borderRad: 5,
          )
        ],
      ),
    );
  }
}
