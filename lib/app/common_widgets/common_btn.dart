import '../utils/all_dependency.dart';

class CommonBtn extends StatelessWidget {
  final String text;
  final Function() onTap;
  final Color? textColor;
  final Color? btnColor;
  final Color? borderColor;
  final String? icon;
  final double? vertPad;
  final double? borderRad;
  final double? textSize;
  final bool isBoxShadow;
  const CommonBtn({
    super.key,
    required this.text,
    required this.onTap,
    this.textColor,
    this.btnColor,
    this.borderColor,
    this.icon,
    this.vertPad,
    this.borderRad,
    this.textSize,
    this.isBoxShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRad ?? 100),
          color: btnColor ?? AppColor.primaryColor,
          border: Border.all(color: borderColor ?? AppColor.primaryColor),
          boxShadow: isBoxShadow
              ? const [
                  BoxShadow(
                    color: AppColor.grey20,
                    blurRadius: 2,
                    offset: Offset(2, 2),
                  ),
                ]
              : null,
        ),
        child: SizedBox(
          width: double.infinity,
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: vertPad ?? 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) SvgPicture.asset(icon!),
                  if (icon != null) 10.horizontal(),
                  SText(
                    text,
                    size: textSize ?? 16,
                    color: textColor ?? AppColor.white,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ViewAllBtn extends StatelessWidget {
  final Function() onTap;
  final String text;
  const ViewAllBtn({
    super.key,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        S16Text(
          text,
          fontWeight: FontWeight.w700,
          color: AppColor.grey100,
        ),
        GestureDetector(
          onTap: onTap,
          child: const S14Text(
            AppStrings.viewAll,
            fontWeight: FontWeight.w500,
            color: AppColor.primaryColor,
          ),
        )
      ],
    );
  }
}
