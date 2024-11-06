import '../utils/all_dependency.dart';

class CommonTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String? prefixIcon;
  final String hintText;
  final String? title;
  final IconData? suffixIcon;
  final Function()? onPressed;
  final Function()? onTap;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool isProfileScreen;
  final bool readOnly;
  final FontWeight? fontWeight;
  final Color? textColor;
  final int? maxLength;
  const CommonTextfield({
    super.key,
    required this.controller,
    this.prefixIcon,
    this.hintText = "",
    this.suffixIcon,
    this.onPressed,
    this.onTap,
    this.obscureText = false,
    this.textInputAction,
    this.keyboardType,
    this.inputFormatters,
    this.isProfileScreen = false,
    this.readOnly = false,
    this.title,
    this.fontWeight,
    this.textColor,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            S16Text(
              title!,
              fontWeight: fontWeight ?? FontWeight.w700,
              color: AppColor.grey100,
            ),
          if (title != null) 8.vertical(),
          TextFormField(
            onTapOutside: (event) =>
                FocusManager.instance.primaryFocus?.unfocus(),
            controller: controller,
            cursorColor: AppColor.primaryColor,
            obscureText: obscureText,
            onTap: () {
              if (onTap != null) onTap!();
            },
            style: TextStyle(color: textColor ?? AppColor.primaryColor),
            textInputAction: textInputAction ?? TextInputAction.next,
            keyboardType: keyboardType ?? TextInputType.text,
            inputFormatters: inputFormatters,
            readOnly: readOnly,
            maxLength: maxLength,
            decoration: InputDecoration(
              counter: const SizedBox(),
              hintText: hintText,
              hintStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: isProfileScreen ? AppColor.grey60 : AppColor.grey80,
              ),
              border: outlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                vertical: 15,
                horizontal: prefixIcon != null ? 0 : 15,
              ),
              disabledBorder: outlineInputBorder(),
              enabledBorder: outlineInputBorder(),
              errorBorder: outlineInputBorder(),
              focusedBorder: outlineInputBorder(color: AppColor.primaryColor),
              fillColor: isProfileScreen ? Colors.transparent : AppColor.grey20,
              filled: true,
              suffixIcon: (suffixIcon != null)
                  ? IconButton(
                      onPressed: onPressed,
                      icon: Icon(
                        suffixIcon,
                        color: AppColor.primaryColor,
                      ),
                    )
                  : null,
              prefixIcon: prefixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset(
                        prefixIcon!,
                        height: 17,
                        // ignore: deprecated_member_use
                        color: AppColor.primaryColor,
                      ),
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder outlineInputBorder({Color? color}) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: color ?? (isProfileScreen ? AppColor.grey60 : AppColor.grey20),
        ),
      );
}

class CommonSearchFiled extends StatefulWidget {
  final String hintText;
  final Function(String search) onSearch;
  final Function() onClose;
  const CommonSearchFiled({
    super.key,
    required this.hintText,
    required this.onSearch, required this.onClose,
  });

  @override
  State<CommonSearchFiled> createState() => _CommonSearchFiledState();
}

class _CommonSearchFiledState extends State<CommonSearchFiled> {
  String search = "";
  TextEditingController searchController = TextEditingController();
  FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColor.grey20,
          ),
          child: TextFormField(
            focusNode: focusNode,
            controller: searchController,
            cursorColor: AppColor.primaryColor,
            textInputAction: TextInputAction.search,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColor.grey100,
            ),
            cursorHeight: 20,
            onChanged: (value) {
              widget.onSearch(value);
              setState(() => search = value);
            },
            decoration: InputDecoration(
              isDense: true,
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColor.grey80,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 7,
                horizontal: 40,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 10,
          ),
          child: SvgPicture.asset(
            AppAssets.search2Ic,
            width: 20,
            colorFilter: const ColorFilter.mode(
              AppColor.grey80,
              BlendMode.srcIn,
            ),
          ),
        ),
        if (search.isNotEmpty)
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  search = "";
                  focusNode.unfocus();
                  searchController.clear();
                });
                widget.onClose();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 10,
                ),
                child: SvgPicture.asset(
                  AppAssets.close,
                  width: 20,
                  colorFilter: const ColorFilter.mode(
                    AppColor.grey80,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          )
      ],
    );
  }
}
