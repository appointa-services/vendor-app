import 'dart:convert';
import 'package:salon_user/backend/database_key.dart';
import 'package:salon_user/data_models/vendor_data_models.dart';

class UserModel {
  final String? id;
  final String email;
  final String name;
  final String? image;
  final String mobile;
  final String? password;
  final bool isGoogle;
  final bool isUserByVendor;
  final BusinessModel? businessData;

  UserModel({
    this.id,
    required this.email,
    required this.name,
    this.image,
    required this.mobile,
    this.password,
    this.isGoogle = false,
    this.isUserByVendor = false,
    this.businessData,
  });

  factory UserModel.fromMap(Map json) => UserModel(
        id: json[DatabaseKey.id],
        email: json[DatabaseKey.email],
        image: json[DatabaseKey.image],
        name: json[DatabaseKey.name],
        mobile: json[DatabaseKey.mobile],
        password: json[DatabaseKey.password],
        businessData: json[DatabaseKey.businessData] == null
            ? null
            : BusinessModel.fromJson(
                json[DatabaseKey.businessData],
              ),
        isGoogle: json[DatabaseKey.isGoogle],
        isUserByVendor: json[DatabaseKey.isUserByVendor] ?? false,
      );

  Map<String, dynamic> toJson() => {
        if (id != null) DatabaseKey.id: id,
        DatabaseKey.email: email,
        if (image != null) DatabaseKey.image: image,
        DatabaseKey.name: name,
        DatabaseKey.mobile: mobile,
        if (password != null) DatabaseKey.password: password,
        DatabaseKey.isGoogle: isGoogle,
        DatabaseKey.isUserByVendor: isUserByVendor,
        if (businessData != null)
          DatabaseKey.businessData: businessData?.toJson(),
      };

  @override
  String toString() => jsonEncode(toJson());
}

class LoginResponse {
  bool isAdmin;
  bool isError;
  bool isPassWrong;
  UserModel? data;

  LoginResponse({
    this.isAdmin = false,
    this.isError = false,
    this.isPassWrong = false,
    this.data,
  });
}
