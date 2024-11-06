import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:salon_user/data_models/vendor_data_models.dart';

import '../../utils/all_dependency.dart';

class SelectServiceScreen extends StatelessWidget {
  const SelectServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ServiceController(), permanent: true);
    RefreshController refreshController = RefreshController();
    DashboardController dashBoardController = Get.find();
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 15, bottom: 10),
            child: S14Text(
              "Choose the services this team member provides",
              fontWeight: FontWeight.w500,
              color: AppColor.grey80,
            ),
          ),
          Obx(
            () => Flexible(
              child: SmartRefresher(
                controller: refreshController,
                onRefresh: () {
                  dashBoardController.getServiceList();
                  refreshController.refreshCompleted();
                },
                child: dashBoardController.serviceList.isEmpty &&
                        !dashBoardController.isServiceLoad.value
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: const Center(
                          child: S14Text("Please add service first"),
                        ),
                      )
                    : dashBoardController.isServiceLoad.value
                        ? const Center(child: CircularProgressIndicator())
                        : GetBuilder<StaffController>(
                            builder: (controller) {
                              return ListView.builder(
                                itemCount:
                                    dashBoardController.serviceList.length + 1,
                                shrinkWrap: true,
                                primary: false,
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  ServiceModel? data;
                                  if (index != 0) {
                                    data = dashBoardController
                                        .serviceList[index - 1];
                                  }
                                  String price = controller.getPrice(data);
                                  price.print;
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      bottom: data == null ? 5 : 10,
                                    ),
                                    child: Row(
                                      children: [
                                        Checkbox(
                                          value: data == null
                                              ? controller
                                                      .selectedService.length ==
                                                  dashBoardController
                                                      .serviceList.length
                                              : controller.selectedService.any(
                                                  (element) =>
                                                      element.$1 == data!.id),
                                          onChanged: (value) =>
                                              controller.selectService(
                                            dashBoardController,
                                            data,
                                          ),
                                        ),
                                        Expanded(
                                          child: data == null
                                              ? const S14Text("Select all")
                                              : Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    S16Text(
                                                      data.serviceName,
                                                      color: AppColor.grey100,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                    3.vertical(),
                                                    S12Text(
                                                      "${data.serviceTime} min",
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: AppColor.grey80,
                                                    ),
                                                  ],
                                                ),
                                        ),
                                        if (data != null)
                                          GestureDetector(
                                            onTap: () {
                                              TextEditingController
                                                  priceController =
                                                  TextEditingController(
                                                text: price.isEmpty
                                                    ? data!.price
                                                    : price,
                                              );
                                              showModalBottomSheet(
                                                context: context,
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.zero,
                                                ),
                                                builder: (context) => Padding(
                                                  padding:
                                                      MediaQuery.viewInsetsOf(
                                                          context),
                                                  child: TextFormField(
                                                    controller: priceController,
                                                    autofocus: true,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .digitsOnly,
                                                    ],
                                                    decoration: InputDecoration(
                                                      isDense: true,
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                        horizontal: 10,
                                                        vertical: 12,
                                                      ),
                                                      suffixIcon: IconButton(
                                                        onPressed: () {
                                                          controller.addPrice(
                                                            (
                                                              data?.id ?? "",
                                                              priceController
                                                                  .text
                                                            ),
                                                          );
                                                          Get.back();
                                                        },
                                                        icon: const S16Text(
                                                          "Add",
                                                          color: AppColor
                                                              .primaryColor,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            child: ColoredBox(
                                              color: Colors.transparent,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 15,
                                                  top: 5,
                                                  bottom: 5,
                                                ),
                                                child: S14Text(
                                                  "${AppStrings.rupee} "
                                                  "${price.isEmpty ? data.price : price}",
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColor.grey80,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
