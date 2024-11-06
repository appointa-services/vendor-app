import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/backend/database_key.dart';
import 'package:salon_user/backend/database_ref.dart';
import 'package:salon_user/data_models/user_model.dart';
import 'package:salon_user/data_models/vendor_data_models.dart';

import '../../data_models/booking_model.dart';

class AdminHomeData {
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

  static Future<bool> addCategoryData({
    required String catName,
    required String path,
    required int catLength,
  }) async {
    bool isAdd = false;
    try {
      await uploadImg(
        imgPath: path,
        storagePath: "${DatabaseKey.admin}/${DatabaseKey.category}/",
        imageName: "${DatabaseKey.category}${catLength + 1}",
        func: (value) async {
          CategoryModel category = CategoryModel(
            catId: "",
            catName: catName,
            catImg: value,
          );
          var orderRef = DatabaseRef.category.push();
          await orderRef.set(category.toJson()).then((value) {
            DatabaseRef.category.child(orderRef.key!).update(
              {DatabaseKey.catId: orderRef.key},
            );
          });
        },
      );
    } catch (e) {
      "-->> add category error $e".print;
    }
    return isAdd;
  }

  static Future<void> uploadImg({
    required String imgPath,
    required String storagePath,
    required String imageName,
    required Function(String url) func,
  }) async {
    Reference storageReference = FirebaseStorage.instance.ref();
    Reference ref = storageReference.child(storagePath);

    UploadTask storageUploadTask =
        ref.child("$imageName.png").putFile(File(imgPath));

    storageUploadTask.snapshotEvents.listen((event) async {
      if (event.state == TaskState.running) {
        TaskSnapshot storageTaskSnapshot = storageUploadTask.snapshot;
        await storageTaskSnapshot.ref
            .getDownloadURL()
            .then((value) => func(value));
      }
    });
  }

  static Future<List<BookingModel>> getBooking(String id) async {
    List<BookingModel> booking = [];
    try {
      await DatabaseRef.booking
          .orderByChild(DatabaseKey.vendorId)
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

  static Future<List<UserModel>> getUserId(String id) async {
    List<UserModel> userList = [];
    try {
      await DatabaseRef.user
          .orderByChild("${DatabaseKey.vendorList}/$id")
          .equalTo(true)
          .onValue
          .first
          .then((value) {
        if (value.snapshot.value != null) {
          (value.snapshot.value as Map).forEach((key, value) {
            UserModel book = UserModel.fromMap(value);
            "-->> here user data arrived $value".print;
            userList.add(book);
          });
        }
      });
    } on Exception catch (e) {
      ('get user exception -> $e').print;
    }
    return userList;
  }

  static Future<bool> updateStatus(
    String id,
    String status,
    String? method,
  ) async {
    bool isDone = false;
    try {
      await DatabaseRef.booking.child(id).update(
        {
          DatabaseKey.status: status,
          DatabaseKey.isCancelledUser: status != AppStrings.cancelled,
          if (method != null) DatabaseKey.paymentMethod: method,
        },
      ).then((value) {
        isDone = true;
      });
    } on Exception catch (e) {
      ('get booking exception -> $e').print;
    }
    return isDone;
  }

  /// add update user
  static Future<UserModel?> addUpdateUser(
    UserModel userData,
    String vendorId, {
    bool isAdd = true,
  }) async {
    UserModel? finalUser;
    try {
      if (isAdd) {
        await DatabaseRef.user
            .orderByChild(DatabaseKey.mobile)
            .equalTo(userData.mobile)
            .onValue
            .first
            .then(
          (value) async {
            if (value.snapshot.value == null) {
              var orderRef = DatabaseRef.user.push();
              await orderRef.set(userData.toJson()).then((value) async {
                DatabaseRef.user.child(orderRef.key!)
                  ..update(
                    {
                      DatabaseKey.id: orderRef.key,
                      DatabaseKey.isUserByVendor: true,
                    },
                  )
                  ..child(DatabaseKey.vendorList).update({
                    vendorId: true,
                  });
              });
              Map<String, dynamic> user = userData.toJson();

              user.addAll({
                DatabaseKey.id: orderRef.key,
                DatabaseKey.isUserByVendor: true,
              });
              finalUser = UserModel.fromMap(user);
            } else {
              (value.snapshot.value as Map).forEach(
                (key, value) {
                  finalUser = UserModel.fromMap(value);
                },
              );
              await DatabaseRef.user
                  .child(finalUser?.id ?? "")
                  .child(DatabaseKey.vendorList)
                  .update({
                vendorId: true,
              });
            }
          },
        );
      } else {
        "-->>> ${userData.id}".print;
        await DatabaseRef.user.child(userData.id ?? "").update(
              userData.toJson(),
            );
        finalUser = userData;
      }
    } catch (e) {
      'verifyOtp exception $e'.print;
    }
    return finalUser;
  }

  static Future<bool> addBooking(BookingModel bookingData) async {
    bool isDone = false;
    try {
      DatabaseReference ref = DatabaseRef.booking.push();
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
}
