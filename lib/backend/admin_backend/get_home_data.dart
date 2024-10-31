import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:salon_user/app/helper/helper.dart';
import 'package:salon_user/backend/database_key.dart';
import 'package:salon_user/backend/database_ref.dart';
import 'package:salon_user/data_models/vendor_data_models.dart';

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
      "-->> get category error $e".print();
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
        storagPath: "${DatabaseKey.admin}/${DatabaseKey.category}/",
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
      "-->> add category error $e".print();
    }
    return isAdd;
  }

  static Future<void> uploadImg({
    required String imgPath,
    required String storagPath,
    required String imageName,
    required Function(String url) func,
  }) async {
    Reference storageReference = FirebaseStorage.instance.ref();
    Reference ref = storageReference.child(storagPath);

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
}
