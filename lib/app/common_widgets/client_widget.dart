import 'package:salon_user/app/utils/all_dependency.dart';

class ClientWidget extends StatelessWidget {
  final Function() onTap;
  final bool isSelect;
  const ClientWidget({super.key, required this.onTap, this.isSelect = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: isSelect ? null : onTap,
          child: ColoredBox(
            color: Colors.transparent,
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: AppColor.grey40,
                  backgroundImage: AssetImage(AppAssets.dummyPerson1),
                ),
                15.horizontal(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const S16Text(
                        "Client name",
                        fontWeight: FontWeight.w600,
                        color: AppColor.grey100,
                      ),
                      3.vertical(),
                      const S12Text("91 5454655445"),
                    ],
                  ),
                ),
                if (isSelect) 8.horizontal(),
                if (isSelect)
                  GestureDetector(
                    onTap: onTap,
                    child: const Icon(
                      Icons.delete,
                      color: AppColor.orange,
                    ),
                  )
              ],
            ),
          ),
        ),
        if (!isSelect) const Divider(color: AppColor.grey20, height: 25),
      ],
    );
  }
}
