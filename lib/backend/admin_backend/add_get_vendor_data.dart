import 'package:salon_user/app/helper/helper.dart';
import 'package:salon_user/backend/authentication.dart';
import 'package:salon_user/backend/database_ref.dart';
import 'package:salon_user/data_models/vendor_data_models.dart';

import '../database_key.dart';

class AddGetVendorData {
  static Future<bool> updateBusimessDetail(
    BusinessModel businessModel,
    String id,
  ) async {
    bool isDone = false;
    try {
      await DatabaseRef.vendor.child(id).update(
        {DatabaseKey.businessData: businessModel.toJson()},
      );
      isDone = true;
    } on Exception catch (e) {
      isDone = false;
      ('update business detail exception -> $e').print();
    }
    return isDone;
  }

  static Future<bool> updateProfile(
    String name,
    String mobile,
    String password,
    String id,
  ) async {
    bool isDone = false;
    try {
      await DatabaseRef.vendor.child(id).update({
        DatabaseKey.name: name,
        DatabaseKey.mobile: mobile,
        DatabaseKey.password: password,
      });
      isDone = true;
    } on Exception catch (e) {
      isDone = false;
      ('update profile detail exception -> $e').print();
    }
    return isDone;
  }

  static Future<List<ServiceModel>?> getServiceList(String userId) async {
    List<ServiceModel>? serviceList = [];
    try {
      var serviceData = await AuthenticationApiClass.getData(
        DatabaseRef.service,
        userId,
        comKey: DatabaseKey.vendorId,
      );
      if (serviceData != null) {
        (serviceData as Map).forEach((key, value) {
          serviceList!.add(ServiceModel.fromJson(value));
        });
      }
    } on Exception catch (e) {
      serviceList = null;
      "get service list exception $e".print();
    }
    return serviceList;
  }

  static Future<(bool, ServiceModel?)> addService(
    ServiceModel serviceModel,
  ) async {
    bool isAdd = false;
    ServiceModel? service;
    try {
      if (serviceModel.id == null) {
        var serviceRef = DatabaseRef.service.push();
        await serviceRef.set(serviceModel.toJson()).then(
          (value) async {
            await DatabaseRef.service.child(serviceRef.key!).update(
              {DatabaseKey.id: serviceRef.key},
            );
            Map<String, dynamic> serviceData = serviceModel.toJson();
            serviceData.addAll({DatabaseKey.id: serviceRef.key});
            service = ServiceModel.fromJson(serviceData);
            isAdd = true;
          },
        );
      } else {
        await DatabaseRef.service
            .child(serviceModel.id!)
            .update(
              serviceModel.toJson(),
            )
            .then(
              (value) => isAdd = true,
            );
      }
    } on Exception catch (e) {
      "add update service exception $e".print();
    }
    return (isAdd, service);
  }

  static Future<bool> updateServiceName(
    List serviceList,
    String id,
  ) async {
    bool isDone = false;
    try {
      await DatabaseRef.vendor
          .child(id)
          .child(DatabaseKey.businessData)
          .child(DatabaseKey.serviceNameList)
          .set(serviceList);
      isDone = true;
    } on Exception catch (e) {
      isDone = false;
      ('update service name exception -> $e').print();
    }
    return isDone;
  }

  static Future<List<StaffModel>?> getStafList(String userId) async {
    List<StaffModel>? staffList = [];
    try {
      var staffData = await AuthenticationApiClass.getData(
        DatabaseRef.staff,
        userId,
        comKey: DatabaseKey.vendorId,
      );
      if (staffData != null) {
        (staffData as Map).forEach((key, value) {
          staffList!.add(StaffModel.fromJson(value));
        });
      }
    } on Exception catch (e) {
      staffList = null;
      "get staff list exception $e".print();
    }
    return staffList;
  }

  static Future<(bool, StaffModel?)> addStaffMember(
    StaffModel staffModel,
  ) async {
    bool isAdd = false;
    StaffModel? staff;
    try {
      if (staffModel.id == null) {
        var serviceRef = DatabaseRef.staff.push();
        await serviceRef.set(staffModel.toJson()).then(
          (value) async {
            "-->> staff model ${serviceRef.key!}".print();
            await DatabaseRef.staff.child(serviceRef.key!).update(
              {DatabaseKey.id: serviceRef.key},
            );
            Map<String, dynamic> serviceData = staffModel.toJson();
            serviceData.addAll({DatabaseKey.id: serviceRef.key});
            staff = StaffModel.fromJson(serviceData);
            isAdd = true;
          },
        );
      } else {
        await DatabaseRef.staff
            .child(staffModel.id!)
            .update(
              staffModel.toJson(),
            )
            .then(
              (value) => isAdd = true,
            );
      }
    } on Exception catch (e) {
      "add update staff exception $e".print();
    }
    return (isAdd, staff);
  }
}
