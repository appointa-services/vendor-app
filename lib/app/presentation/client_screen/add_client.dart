import 'package:salon_user/app/utils/all_dependency.dart';

class AddClientScreen extends StatelessWidget {
  const AddClientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ClientController controller = Get.find<ClientController>();
    return PopScope(
      onPopInvoked: (didPop) {
        controller
          ..email.clear()
          ..name.clear()
          ..mobile.clear()
          ..isEdit.value = false;
      },
      child: CommonAppbar(
        title: controller.isEdit.value ? "Edit Client" : AppStrings.addClient,
        padd: const EdgeInsets.all(p16),
        children: [
          Expanded(
            child: ListView(
              children: [
                CommonTextfield(
                  controller: controller.name,
                  hintText: AppStrings.enterCName,
                  prefixIcon: AppAssets.personIc,
                  isProfileScreen: true,
                  title: AppStrings.name,
                ),
                CommonTextfield(
                  controller: controller.email,
                  hintText: AppStrings.enterCEmailAddress,
                  title: AppStrings.emailAddress,
                  prefixIcon: AppAssets.emailIc,
                  keyboardType: TextInputType.emailAddress,
                  isProfileScreen: true,
                ),
                CommonTextfield(
                  controller: controller.mobile,
                  hintText: AppStrings.enterCMobileNumber,
                  title: AppStrings.mobileNumber,
                  prefixIcon: AppAssets.phoneIc,
                  keyboardType: TextInputType.phone,
                  isProfileScreen: true,
                  maxLength: 10,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40, bottom: 30),
                  child: CommonBtn(
                    text: controller.isEdit.value ? AppStrings.update : AppStrings.add,
                    onTap: () => controller.addUpdateUser(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
