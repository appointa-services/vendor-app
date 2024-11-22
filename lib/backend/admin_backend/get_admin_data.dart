import 'package:salon_user/app/helper/helper.dart';
import '../../data_models/booking_model.dart';
import '../../data_models/user_model.dart';
import '../database_ref.dart';

class GetAdminData {
  static Future<List<BookingModel>> getBooking() async {
    List<BookingModel> booking = [];
    try {
      await DatabaseRef.booking.onValue.first.then(
        (value) {
          if (value.snapshot.value != null) {
            (value.snapshot.value as Map).forEach(
              (key, value) {
                BookingModel book = BookingModel.fromJson(value);
                booking.add(book);
              },
            );
          }
        },
      );
    } on Exception catch (e) {
      ('get booking exception -> $e').print;
    }
    return booking;
  }

  static Future<List<UserModel>> getVendorNUser(bool isUser) async {
    List<UserModel> userList = [];
    try {
      await (isUser ? DatabaseRef.user : DatabaseRef.vendor).onValue.first.then(
        (value) {
          if (value.snapshot.value != null) {
            (value.snapshot.value as Map).forEach(
              (key, value) {
                UserModel book = UserModel.fromMap(value);
                userList.add(book);
              },
            );
          }
        },
      );
    } on Exception catch (e) {
      ('get user exception -> $e').print;
    }
    return userList;
  }
}
