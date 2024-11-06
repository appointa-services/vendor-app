import 'package:salon_user/app/presentation/staff_screens/personal_detail_screen.dart';
import 'package:salon_user/app/presentation/staff_screens/select_service_screen.dart';
import 'package:salon_user/app/utils/all_dependency.dart';

class AddStaffScreen extends StatelessWidget {
  const AddStaffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    StaffController controller = Get.find<StaffController>();
    return CommonAppbar(
      title: controller.id != null ? "Edit staff member" : "Add staff member",
      bottomWidget: IntrinsicHeight(
        child: Padding(
          padding: const EdgeInsets.all(p16) + bottomPad,
          child: CommonBtn(
            text: controller.id != null ? AppStrings.update : "Save",
            onTap: () => controller.addStaffMember(),
          ),
        ),
      ),
      padd: const EdgeInsets.only(top: p16, right: p16, left: p16),
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColor.primaryColor),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                pageViewBtn(AppStrings.personalDetail),
                pageViewBtn(AppStrings.services),
              ],
            ),
          ),
        ),
        GetBuilder<StaffController>(
          builder: (controller) {
            return controller.selectedTab == AppStrings.personalDetail
                ? const PersonalDetailScreen()
                : const SelectServiceScreen();
          },
        ),
      ],
    );
  }

  Widget pageViewBtn(String title) {
    return GetBuilder<StaffController>(builder: (controller) {
      return Expanded(
        child: GestureDetector(
          onTap: () {
            controller.selectedTab = title;
            controller.update();
          },
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: controller.selectedTab == title
                  ? AppColor.primaryColor
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: S14Text(
                title,
                textAlign: TextAlign.center,
                color: controller.selectedTab == title
                    ? AppColor.white
                    : AppColor.primaryColor,
                fontWeight: controller.selectedTab == title
                    ? FontWeight.w600
                    : FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    });
  }
}
