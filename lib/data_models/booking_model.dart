import 'dart:convert';

import '../backend/database_key.dart';

class BookingModel {
  final String employeeId;
  final String? bookingId;
  final String employeeName;
  final String employeeImg;
  final String vendorId;
  final String userId;
  final String userName;
  final String userImg;
  final int duration;
  final bool isBookUser;
  bool isCancelledUser;
  final String finalPrice;
  String? paymentMethod;
  final List<BookingServiceModel> serviceList;
  final BookingVendorModel? businessData;
  final DiscountModel? discountData;
  final int orderDate;
  final int createdAt;
  String status;

  BookingModel({
    this.bookingId,
    required this.employeeId,
    required this.employeeName,
    required this.employeeImg,
    required this.vendorId,
    required this.businessData,
    this.discountData,
    required this.userId,
    required this.userName,
    required this.userImg,
    required this.duration,
    required this.finalPrice,
    required this.serviceList,
    required this.orderDate,
    required this.createdAt,
    required this.status,
    required this.isBookUser,
    this.isCancelledUser = true,
    this.paymentMethod,
  });

  factory BookingModel.fromJson(Map json) => BookingModel(
        bookingId: json[DatabaseKey.bookingId],
        employeeId: json[DatabaseKey.employeeId],
        employeeName: json[DatabaseKey.employeeName],
        employeeImg: json[DatabaseKey.employeeImg],
        vendorId: json[DatabaseKey.vendorId],
        businessData: json[DatabaseKey.businessData] == null
            ? null
            : BookingVendorModel.fromJson(json[DatabaseKey.businessData]),
        discountData: json[DatabaseKey.discountData] == null
            ? null
            : DiscountModel.fromJson(json[DatabaseKey.discountData]),
        duration: json[DatabaseKey.duration],
        finalPrice: json[DatabaseKey.finalPrice].toString(),
        userId: json[DatabaseKey.userId],
        userName: json[DatabaseKey.userName],
        isBookUser: json[DatabaseKey.isBookUser] ?? true,
        isCancelledUser: json[DatabaseKey.isCancelledUser] ?? true,
        paymentMethod: json[DatabaseKey.paymentMethod],
        userImg: json[DatabaseKey.userImg],
        serviceList: json[DatabaseKey.serviceList] == null
            ? []
            : (json[DatabaseKey.serviceList] as List)
                .map(
                  (e) => BookingServiceModel.fromJson(e),
                )
                .toList(),
        orderDate: json[DatabaseKey.orderDate],
        createdAt: json[DatabaseKey.createdAt],
        status: json[DatabaseKey.status],
      );

  Map<String, Object> toJson() => {
        if (bookingId != null) DatabaseKey.bookingId: bookingId!,
        DatabaseKey.employeeId: employeeId,
        DatabaseKey.employeeName: employeeName,
        DatabaseKey.employeeImg: employeeImg,
        if (businessData != null)
          DatabaseKey.businessData: businessData!.toJson(),
        if (discountData != null)
          DatabaseKey.discountData: discountData!.toJson(),
        DatabaseKey.vendorId: vendorId,
        DatabaseKey.duration: duration,
        DatabaseKey.finalPrice: finalPrice,
        DatabaseKey.isBookUser: isBookUser,
        DatabaseKey.isCancelledUser: isCancelledUser,
        if (paymentMethod != null) DatabaseKey.paymentMethod: paymentMethod!,
        DatabaseKey.userId: userId,
        DatabaseKey.userName: userName,
        DatabaseKey.userImg: userImg,
        DatabaseKey.serviceList: serviceList.map((e) => e.toJson()).toList(),
        DatabaseKey.orderDate: orderDate,
        DatabaseKey.createdAt: createdAt,
        DatabaseKey.status: status,
      };
}

class BookingServiceModel {
  String? id;
  String categoryId;
  String serviceName;
  String price;
  int serviceTime;
  String aboutService;
  List images;

  BookingServiceModel({
    this.id,
    required this.categoryId,
    required this.serviceName,
    required this.price,
    required this.serviceTime,
    required this.aboutService,
    required this.images,
  });

  factory BookingServiceModel.fromJson(Map json, {String? employeeId}) {
    String? price;
    if (employeeId != null && json[DatabaseKey.employeePrice] != null) {
      for (var value in (json[DatabaseKey.employeePrice].toList())) {
        if (value[DatabaseKey.employeeId] == employeeId) {
          price = value[DatabaseKey.price];
        }
      }
    }
    return BookingServiceModel(
      serviceName: json[DatabaseKey.serviceName],
      categoryId: json[DatabaseKey.catId],
      id: json[DatabaseKey.id],
      price: price ?? json[DatabaseKey.price],
      serviceTime: json[DatabaseKey.serviceTime],
      aboutService: json[DatabaseKey.aboutService],
      images: json[DatabaseKey.images],
    );
  }

  Map<String, dynamic> toJson() => {
        DatabaseKey.serviceName: serviceName,
        DatabaseKey.catId: categoryId,
        DatabaseKey.price: price,
        DatabaseKey.serviceTime: serviceTime,
        DatabaseKey.id: id,
        DatabaseKey.aboutService: aboutService,
        DatabaseKey.images: images,
      };

  @override
  String toString() => jsonEncode(toJson());
}

class BookingVendorModel {
  String vendorName;
  String vendorAddress;
  double latitude;
  double longitude;

  BookingVendorModel({
    required this.vendorName,
    required this.vendorAddress,
    required this.latitude,
    required this.longitude,
  });

  factory BookingVendorModel.fromJson(Map json) => BookingVendorModel(
        vendorName: json[DatabaseKey.businessName],
        vendorAddress: json[DatabaseKey.businessAddress],
        latitude: json[DatabaseKey.latitude],
        longitude: json[DatabaseKey.longitude],
      );

  Map<String, dynamic> toJson() => {
        DatabaseKey.businessName: vendorName,
        DatabaseKey.businessAddress: vendorAddress,
        DatabaseKey.latitude: latitude,
        DatabaseKey.longitude: longitude,
      };

  @override
  String toString() => jsonEncode(toJson());
}

class DiscountModel {
  String discountCode;
  String discount;
  String discountPrice;

  DiscountModel({
    required this.discountCode,
    required this.discount,
    required this.discountPrice,
  });

  factory DiscountModel.fromJson(Map json) => DiscountModel(
        discountCode: json[DatabaseKey.discountCode],
        discount: json[DatabaseKey.discount],
        discountPrice: json[DatabaseKey.discountPrice],
      );

  Map<String, dynamic> toJson() => {
        DatabaseKey.discountCode: discountCode,
        DatabaseKey.discount: discount,
        DatabaseKey.discountPrice: discountPrice,
      };

  @override
  String toString() => jsonEncode(toJson());
}
