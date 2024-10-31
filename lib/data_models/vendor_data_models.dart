import 'dart:convert';

import 'package:salon_user/backend/database_key.dart';

class CategoryModel {
  final String catId;
  final String catName;
  final String catImg;

  CategoryModel({
    required this.catId,
    required this.catName,
    required this.catImg,
  });

  factory CategoryModel.fromJson(Map json) => CategoryModel(
        catId: json[DatabaseKey.catId],
        catName: json[DatabaseKey.catName],
        catImg: json[DatabaseKey.catImg],
      );

  Map toJson() => {
        DatabaseKey.catId: catId,
        DatabaseKey.catName: catName,
        DatabaseKey.catImg: catImg,
      };
}

class BusinessModel {
  final String businessName;
  final String businessDesc;
  final String businessAddress;
  final String? teamSize;
  final String? logo;
  final dynamic latitude;
  final double? longitude;
  final List images;
  final List selectedCat;
  final List selectedCatName;
  final List serviceNameList;
  final List<IntervalModel> intervalList;

  BusinessModel({
    required this.businessName,
    required this.businessDesc,
    required this.businessAddress,
    this.logo,
    required this.teamSize,
    required this.latitude,
    required this.longitude,
    required this.images,
    required this.selectedCat,
    required this.selectedCatName,
    required this.serviceNameList,
    required this.intervalList,
  });

  factory BusinessModel.fromJson(Map json) => BusinessModel(
        businessName: json[DatabaseKey.businessName] ?? "",
        businessDesc: json[DatabaseKey.businessDesc] ?? "",
        businessAddress: json[DatabaseKey.businessAddress] ?? "",
        logo: json[DatabaseKey.logo] ?? "",
        teamSize: json[DatabaseKey.teamSize],
        latitude: json[DatabaseKey.latitude] ?? 21.125,
        longitude: json[DatabaseKey.longitude] ?? 72.1524,
        images: json[DatabaseKey.images] ?? [],
        selectedCat: json[DatabaseKey.selectedCat] ?? [],
        selectedCatName: json[DatabaseKey.selectedCatName] ?? [],
        serviceNameList: json[DatabaseKey.serviceNameList] ?? [],
        intervalList: json[DatabaseKey.intervalList] == null
            ? []
            : (json[DatabaseKey.intervalList] as List)
                .map(
                  (e) => IntervalModel.fromJson(e),
                )
                .toList(),
      );

  Map<String, dynamic> toJson() => {
        DatabaseKey.businessName: businessName,
        DatabaseKey.businessDesc: businessDesc,
        DatabaseKey.businessAddress: businessAddress,
        DatabaseKey.teamSize: teamSize,
        DatabaseKey.latitude: latitude,
        DatabaseKey.logo: logo,
        DatabaseKey.longitude: longitude,
        DatabaseKey.images: images,
        DatabaseKey.selectedCat: selectedCat,
        DatabaseKey.selectedCatName: selectedCatName,
        DatabaseKey.serviceNameList: serviceNameList,
        DatabaseKey.intervalList: intervalList.map((e) => e.toJson()).toList(),
      };

  @override
  String toString() => jsonEncode(toJson());
}

class IntervalModel {
  final String day;
  bool isClosed;
  final DayDatModel? data;

  IntervalModel({
    required this.day,
    this.data,
    this.isClosed = false,
  });

  factory IntervalModel.fromJson(Map json) => IntervalModel(
        day: json[DatabaseKey.day],
        data: json[DatabaseKey.data] == null
            ? null
            : DayDatModel.fromJson(json[DatabaseKey.data]),
        isClosed: json[DatabaseKey.isClosed],
      );

  Map<String, dynamic> toJson() => {
        DatabaseKey.day: day,
        DatabaseKey.data: data?.toJson(),
        DatabaseKey.isClosed: isClosed,
      };

  @override
  String toString() => jsonEncode(toJson());
}

class DayDatModel {
  String startTime;
  String endTime;
  List<BreakModel> breakList;

  DayDatModel({
    required this.startTime,
    required this.endTime,
    required this.breakList,
  });

  factory DayDatModel.fromJson(Map json) => DayDatModel(
        endTime: json[DatabaseKey.endTime],
        startTime: json[DatabaseKey.startTime],
        breakList: json[DatabaseKey.breakList] == null
            ? []
            : (json[DatabaseKey.breakList] as List)
                .map(
                  (e) => BreakModel.fromJson(e),
                )
                .toList(),
      );

  Map<String, dynamic> toJson() => {
        DatabaseKey.endTime: endTime,
        DatabaseKey.startTime: startTime,
        DatabaseKey.breakList: breakList.map((e) => e.toJson()).toList(),
      };
  @override
  String toString() => jsonEncode(toJson());
}

class BreakModel {
  String startTime;
  String endTime;

  BreakModel({
    required this.endTime,
    required this.startTime,
  });

  factory BreakModel.fromJson(Map json) => BreakModel(
        endTime: json[DatabaseKey.endTime],
        startTime: json[DatabaseKey.startTime],
      );

  Map<String, dynamic> toJson() => {
        DatabaseKey.endTime: endTime,
        DatabaseKey.startTime: startTime,
      };

  @override
  String toString() => jsonEncode(toJson());
}

class ServiceModel {
  String vendorId;
  String? id;
  String categoryId;
  String serviceName;
  String price;
  int serviceTime;
  String aboutService;
  List images;
  bool isActive;

  ServiceModel({
    this.id,
    required this.vendorId,
    required this.categoryId,
    required this.serviceName,
    required this.price,
    required this.serviceTime,
    required this.aboutService,
    required this.images,
    this.isActive = true,
  });

  factory ServiceModel.fromJson(Map json) => ServiceModel(
        vendorId: json[DatabaseKey.vendorId],
        serviceName: json[DatabaseKey.serviceName],
        categoryId: json[DatabaseKey.catId],
        id: json[DatabaseKey.id],
        price: json[DatabaseKey.price],
        serviceTime: json[DatabaseKey.serviceTime],
        aboutService: json[DatabaseKey.aboutService],
        images: json[DatabaseKey.images],
        isActive: json[DatabaseKey.isActive],
      );

  Map<String, dynamic> toJson() => {
        DatabaseKey.serviceName: serviceName,
        DatabaseKey.vendorId: vendorId,
        DatabaseKey.catId: categoryId,
        DatabaseKey.price: price,
        DatabaseKey.serviceTime: serviceTime,
        DatabaseKey.id: id,
        DatabaseKey.aboutService: aboutService,
        DatabaseKey.images: images,
        DatabaseKey.isActive: isActive,
      };

  @override
  String toString() => jsonEncode(toJson());
}

class StaffModel {
  String? id;
  String vendorId;
  String firstName;
  String lastName;
  String email;
  String mobile;
  String? additionalMobile;
  String address;
  String dob;
  String image;
  List serviceList;
  bool isActive;

  StaffModel({
    this.id,
    required this.vendorId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobile,
    required this.additionalMobile,
    required this.address,
    required this.dob,
    required this.image,
    required this.serviceList,
    this.isActive = true,
  });

  factory StaffModel.fromJson(Map json) => StaffModel(
        id: json[DatabaseKey.id],
        vendorId: json[DatabaseKey.vendorId],
        firstName: json[DatabaseKey.firstName],
        lastName: json[DatabaseKey.lastName],
        email: json[DatabaseKey.email],
        mobile: json[DatabaseKey.mobile],
        additionalMobile: json[DatabaseKey.additionalMobile],
        address: json[DatabaseKey.address],
        dob: json[DatabaseKey.dob],
        image: json[DatabaseKey.image],
        serviceList: json[DatabaseKey.serviceList] ?? [],
        isActive: json[DatabaseKey.isActive],
      );

  Map<String, dynamic> toJson() => {
        DatabaseKey.id: id,
        DatabaseKey.vendorId: vendorId,
        DatabaseKey.firstName: firstName,
        DatabaseKey.lastName: lastName,
        DatabaseKey.email: email,
        DatabaseKey.mobile: mobile,
        DatabaseKey.additionalMobile: additionalMobile,
        DatabaseKey.address: address,
        DatabaseKey.dob: dob,
        DatabaseKey.image: image,
        DatabaseKey.serviceList: serviceList,
        DatabaseKey.isActive: isActive,
      };

  @override
  String toString() => jsonEncode(toJson());
}
