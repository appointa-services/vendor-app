import 'dart:convert';
import 'package:get/get.dart';
import 'package:salon_user/backend/database_key.dart';
import 'package:salon_user/data_models/vendor_data_models.dart';

class UserModel {
  final String? id;
  final String email;
  final String name;
  final String? image;
  final String? mobile;
  final String? dob;
  final String? gender;
  final String? password;
  final bool isGoogle;
  RxBool isLoad;
  final BusinessModel? businessData;

  UserModel({
    this.id,
    required this.email,
    required this.name,
    this.image,
    this.gender,
    this.dob,
    this.mobile,
    this.password,
    this.isGoogle = false,
    required this.isLoad,
    this.businessData,
  });

  factory UserModel.fromMap(Map json) => UserModel(
        id: json[DatabaseKey.id],
        email: json[DatabaseKey.email],
        image: json[DatabaseKey.image],
        name: json[DatabaseKey.name],
        mobile: json[DatabaseKey.mobile],
        dob: json[DatabaseKey.dob],
        gender: json[DatabaseKey.gender],
        password: json[DatabaseKey.password],
        isGoogle: json[DatabaseKey.isGoogle],
        isLoad: RxBool(false),
        businessData: json[DatabaseKey.businessData] == null
            ? null
            : BusinessModel.fromJson(
                json[DatabaseKey.businessData],
              ),
      );

  Map<String, dynamic> toJson() => {
        if (id != null) DatabaseKey.id: id,
        DatabaseKey.email: email,
        if (image != null) DatabaseKey.image: image,
        DatabaseKey.name: name,
        if (mobile != null) DatabaseKey.mobile: mobile ?? "",
        if (dob != null) DatabaseKey.dob: dob ?? "",
        if (gender != null) DatabaseKey.gender: gender ?? "",
        if (password != null) DatabaseKey.password: password,
        DatabaseKey.isGoogle: isGoogle,
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
