import 'package:salon_user/app/utils/all_dependency.dart';

class CustomSwitch extends StatefulWidget {
  final bool value;
  final Color? enableColor;
  final Color? disableColor;
  final double? width;
  final double? height;
  final double? switchHeight;
  final double? switchWidth;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({
    super.key,
    required this.value,
    this.enableColor,
    this.disableColor,
    this.width,
    this.height,
    this.switchHeight,
    this.switchWidth,
    required this.onChanged,
  });

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 60),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _animationController != null
        ? AnimatedBuilder(
            animation: _animationController!,
            builder: (context, child) {
              return GestureDetector(
                onTap: () {
                  if (_animationController!.isCompleted) {
                    _animationController!.reverse();
                  } else {
                    _animationController!.forward();
                  }
                  widget.value == false
                      ? widget.onChanged(true)
                      : widget.onChanged(false);
                },
                child: Container(
                  width: widget.width ?? 48.0,
                  height: widget.height ?? 24.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.0),
                    color: !widget.value
                        ? widget.disableColor ?? AppColor.grey40
                        : widget.enableColor ?? AppColor.grey100,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 2.0,
                      bottom: 2.0,
                      right: 2.0,
                      left: 2.0,
                    ),
                    child: Container(
                      alignment: widget.value
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        width: widget.switchWidth ?? 20.0,
                        height: widget.switchHeight ?? 20.0,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          )
        : const SizedBox();
  }
}
