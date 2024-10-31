import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:salon_user/data_models/vendor_data_models.dart';

import '../../utils/all_dependency.dart';

class SelectServiceScreen extends StatelessWidget {
  const SelectServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ServiceController(), permanent: true);
    RefreshController refreshController = RefreshController();
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
          GetBuilder<ServiceController>(builder: (serviceController) {
            return GetBuilder<StaffController>(
              builder: (controller) {
                return Flexible(
                  child: SmartRefresher(
                    controller: refreshController,
                    onRefresh: () {
                      serviceController.getServiceList();
                      refreshController.refreshCompleted();
                    },
                    child: serviceController.serviceList.isEmpty &&
                            !serviceController.isServiceLoad
                        ? SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: const Center(
                              child: S14Text("Please add service first"),
                            ),
                          )
                        : serviceController.isServiceLoad
                            ? const Center(child: CircularProgressIndicator())
                            : ListView.builder(
                                itemCount:
                                    serviceController.serviceList.length + 1,
                                shrinkWrap: true,
                                primary: false,
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  ServiceModel? data;
                                  if (index != 0) {
                                    data = serviceController
                                        .serviceList[index - 1];
                                  }
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        bottom: data == null ? 5 : 10),
                                    child: Row(
                                      children: [
                                        Checkbox(
                                          value: data == null
                                              ? controller
                                                      .selectedService.length ==
                                                  serviceController
                                                      .serviceList.length
                                              : controller.selectedService
                                                  .contains(data.id),
                                          onChanged: (value) {
                                            if (data == null) {
                                              if (controller
                                                      .selectedService.length <
                                                  serviceController
                                                      .serviceList.length) {
                                                controller.selectedService =
                                                    List.generate(
                                                  serviceController
                                                      .serviceList.length,
                                                  (ind) =>
                                                      serviceController
                                                          .serviceList[ind]
                                                          .id ??
                                                      "",
                                                );
                                              } else {
                                                controller.selectedService
                                                    .clear();
                                              }
                                            } else {
                                              if (controller.selectedService
                                                  .contains(data.id)) {
                                                controller.selectedService
                                                    .remove(data.id);
                                              } else {
                                                controller.selectedService
                                                    .add(data.id ?? "");
                                              }
                                            }
                                            controller.update();
                                          },
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
                                            onTap:() {},
                                            child: ColoredBox(
                                            color: Colors.transparent,
                                            child:Padding(
                                            padding: EdgeInsets.only(left:15,top:5,bottom:5),
                                            child:S14Text(
                                            "${AppStrings.rupee} ${data.price}",
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
                              ),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
