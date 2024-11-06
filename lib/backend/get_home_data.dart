import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/backend/authentication.dart';
import 'package:salon_user/backend/database_key.dart';
import 'package:salon_user/backend/database_ref.dart';
import 'package:salon_user/data_models/booking_model.dart';
import 'package:salon_user/data_models/user_model.dart';

import '../data_models/vendor_data_models.dart';

class GetHomeData {
  static Future<List<CategoryModel>> getCategoryData() async {
    List<CategoryModel> category = [];

    try {
      DataSnapshot dataSnapshot = await DatabaseRef.category.ref.get();
      Map? data = dataSnapshot.value as Map?;
      if (data != null) {
        data.forEach((key, value) {
          category.add(
            CategoryModel.fromJson(value),
          );
        });
      }
    } catch (e) {
      "-->> get category error $e".print;
    }

    return category;
  }

  static Future<List<ServiceModel>?> getServiceList(String vendorId) async {
    List<ServiceModel>? serviceList = [];
    try {
      var serviceData = await AuthenticationApiClass.getData(
        DatabaseRef.service,
        vendorId,
        comKey: DatabaseKey.vendorId,
      );
      if (serviceData != null) {
        (serviceData as Map).forEach((key, value) {
          serviceList!.add(ServiceModel.fromJson(value));
        });
      }
    } on Exception catch (e) {
      serviceList = null;
      "get service list exception $e".print;
    }
    return serviceList;
  }

  static Future<List<StaffModel>?> getStaffList(String vendorId) async {
    List<StaffModel>? staffList = [];
    try {
      var serviceData = await AuthenticationApiClass.getData(
        DatabaseRef.staff,
        vendorId,
        comKey: DatabaseKey.vendorId,
      );
      if (serviceData != null) {
        (serviceData as Map).forEach((key, value) {
          staffList!.add(StaffModel.fromJson(value));
        });
      }
    } on Exception catch (e) {
      staffList = null;
      "get staff list exception $e".print;
    }
    return staffList;
  }

  static Future<List<UserModel>?> getVendorList(LatLng latLng) async {
    List<UserModel>? vendorList = [];
    double radiusInKm = 10;
    double userLat = latLng.latitude;
    double userLng = latLng.longitude;

    /// Calculate bounding box in degrees
    double latDelta = radiusInKm / 111.0;
    double lngDelta = radiusInKm / (111.0 * cos(userLat * (pi / 180)));

    /// Bounding box
    double minLat = userLat - latDelta;
    double maxLat = userLat + latDelta;
    double minLng = userLng - lngDelta;
    double maxLng = userLng + lngDelta;

    try {
      await DatabaseRef.vendor
          .orderByChild("${DatabaseKey.businessData}/${DatabaseKey.latitude}")
          .startAt(minLat)
          .endAt(maxLat)
          .onValue
          .first
          .then(
        (serviceData) {
          if (serviceData.snapshot.value != null) {
            (serviceData.snapshot.value as Map).forEach(
              (key, value) {
                UserModel data = UserModel.fromMap(value);
                double lng = data.businessData?.longitude ?? 0;
                "get vendor list ---- $lng >= $minLng - $maxLng".print;
                if (lng >= minLng && lng <= maxLng) {
                  vendorList?.add(data);
                }
              },
            );
          }
        },
      );
    } on Exception catch (e) {
      vendorList = null;
      "get vendor list exception $e".print;
    }
    "get vendor list ${vendorList?.length}".print;
    return vendorList;
  }

  static Future<(bool, String?)> addFavouriteStore({
    required String userId,
    required String vendorId,
    String? key,
  }) async {
    String? returnKey;
    bool isDone = false;
    try {
      if (key != null) {
        await DatabaseRef.vendor
            .child(vendorId)
            .child(DatabaseKey.businessData)
            .child(DatabaseKey.favouriteList)
            .child(key)
            .remove();
      } else {
        var orderRef = DatabaseRef.vendor
            .child(vendorId)
            .child(DatabaseKey.businessData)
            .child(DatabaseKey.favouriteList)
            .push();
        await orderRef.set(userId).then((value) => returnKey = orderRef.key);
      }
      isDone = true;
    } catch (e) {
      "Add favourite store error $e".print;
    }
    return (isDone, returnKey);
  }

  static Future<List<UserModel>> getFavList(String userId) async {
    List<UserModel> list = [];
    try {
      DataSnapshot vendorData = await DatabaseRef.vendor.get();
      for (var element in vendorData.children) {
        UserModel data = UserModel.fromMap((element.value as Map));
        if (data.businessData?.favouriteList
                .any((element) => element.id == userId) ??
            false) {
          list.add(data);
        }
      }
    } catch (e) {
      "get fav list error $e".print;
    }
    return list;
  }

  static Future<bool> updateProfile(
    String name,
    String mobile,
    String? dob,
    String gender,
    String image,
    String id,
  ) async {
    bool isDone = false;
    try {
      await DatabaseRef.user.child(id).update({
        DatabaseKey.name: name,
        DatabaseKey.mobile: mobile,
        DatabaseKey.dob: dob,
        DatabaseKey.gender: gender,
        DatabaseKey.image: image,
      });
      isDone = true;
    } on Exception catch (e) {
      isDone = false;
      ('update profile detail exception -> $e').print;
    }
    return isDone;
  }

  static Future<bool> addBooking(BookingModel bookingData) async {
    bool isDone = false;
    try {
      DatabaseReference ref = DatabaseRef.booking.push();
      DatabaseReference user =
          DatabaseRef.user.child(bookingData.userId).child("vendorList");
      user.update({
        bookingData.vendorId: true,
      });
      Map<String, Object> data = bookingData.toJson();
      await ref.set(data).then(
        (value) {
          DatabaseRef.booking.child(ref.key!).update(
            {DatabaseKey.bookingId: ref.key},
          );
        },
      );
      isDone = true;
    } on Exception catch (e) {
      isDone = false;
      ('add booking detail exception -> $e').print;
    }
    return isDone;
  }

  static Future<List<BookingModel>> getBooking(String id, {String? key}) async {
    List<BookingModel> booking = [];
    try {
      await DatabaseRef.booking
          .orderByChild(key ?? DatabaseKey.employeeId)
          .equalTo(id)
          .onValue
          .first
          .then((value) {
        if (value.snapshot.value != null) {
          (value.snapshot.value as Map).forEach((key, value) {
            BookingModel book = BookingModel.fromJson(value);
            booking.add(book);
          });
        }
      });
    } on Exception catch (e) {
      ('get booking exception -> $e').print;
    }
    return booking;
  }

  static Future<bool> updateStatus(String id, String status) async {
    bool isDone = false;
    try {
      await DatabaseRef.booking.child(id).update(
        {DatabaseKey.status: status},
      ).then((value) {
        isDone = true;
      });
    } on Exception catch (e) {
      ('get booking exception -> $e').print;
    }
    return isDone;
  }
}
