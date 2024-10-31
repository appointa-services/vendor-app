import 'package:salon_user/app/utils/all_dependency.dart';

class AddClientScreen extends StatelessWidget {
  const AddClientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ClientController controller = Get.find<ClientController>();
    return CommonAppbar(
      title: AppStrings.addClient,
      padd: const EdgeInsets.all(p16),
      children: [
        Expanded(
          child: ListView(
            children: [
              CommonTextfield(
                controller: controller.fName,
                hintText: AppStrings.enterFName,
                prefixIcon: AppAssets.personIc,
                isProfileScreen: true,
                title: AppStrings.fname,
              ),
              CommonTextfield(
                controller: controller.lName,
                hintText: AppStrings.enterLName,
                prefixIcon: AppAssets.personIc,
                isProfileScreen: true,
                title: AppStrings.lname,
              ),
              CommonTextfield(
                controller: controller.email,
                hintText: AppStrings.enterEmailAddress,
                title: AppStrings.emailAddress,
                prefixIcon: AppAssets.emailIc,
                keyboardType: TextInputType.emailAddress,
                isProfileScreen: true,
              ),
              CommonTextfield(
                controller: controller.mobile,
                hintText: AppStrings.enterMobileNumber,
                title: AppStrings.mobileNumber,
                prefixIcon: AppAssets.phoneIc,
                keyboardType: TextInputType.phone,
                isProfileScreen: true,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40, bottom: 30),
                child: CommonBtn(
                  text: AppStrings.add,
                  onTap: () => Get.back(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
