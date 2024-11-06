import 'package:crypt/crypt.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/app/utils/loading.dart';
import 'package:salon_user/backend/database_key.dart';
import 'package:salon_user/backend/database_ref.dart';
import 'package:salon_user/data_models/user_model.dart';

class AuthenticationApiClass {
  /// variables
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// get user data by email or other params...
  static Future<dynamic> getData(
    DatabaseReference ref,
    dynamic compVal, {
    String? comKey,
  }) async =>
      (await ref
              .orderByChild(comKey ?? DatabaseKey.email)
              .equalTo(compVal)
              .onValue
              .first)
          .snapshot
          .value;

  /// login
  static Future<LoginResponse> login(String email, String pass) async {
    Loader.show();
    LoginResponse response = LoginResponse();
    try {
      var adminData = await getData(DatabaseRef.admin, email);

      /// check credential is admin or not
      if (adminData != null) {
        (adminData as Map).forEach(
          (key, value) {
            if (Crypt(value[DatabaseKey.password]).match(pass)) {
              response = LoginResponse(isAdmin: true);
            } else {
              response = LoginResponse(isPassWrong: true);
            }
          },
        );
      } else {
        /// user login
        var userData = await getData(DatabaseRef.user, email);
        if (userData != null) {
          (userData as Map).forEach(
            (key, value) {
              UserModel user = UserModel.fromMap(value as Map);
              if (user.password != null) {
                if (Crypt(user.password!).match(pass)) {
                  response = LoginResponse(data: user);
                } else {
                  response = LoginResponse(isPassWrong: true);
                }
              } else {
                response = LoginResponse(data: user);
              }
            },
          );
        }
      }
    } on Exception catch (e) {
      response = LoginResponse(isError: true);
      ('login exception -> $e').print;
    }
    Loader.dismiss();
    return response;
  }

  /// sign in with google
  static Future<UserModel?> signInWithGoogle() async {
    Loader.show();
    UserModel? finalUser;
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        /// check user is avail or not
        var userData = await getData(DatabaseRef.user, googleUser.email);

        if (userData == null) {
          UserModel data = UserModel(
            email: googleUser.email,
            image: googleUser.photoUrl ?? "",
            name: googleUser.displayName ?? "",
            isLoad: RxBool(false),
            isGoogle: true,
          );
          var orderRef = DatabaseRef.user.push();
          await orderRef.set(data.toJson()).then((value) {
            DatabaseRef.user.child(orderRef.key!).update(
              {DatabaseKey.id: orderRef.key},
            );
          });
          Map<String, dynamic> user = data.toJson();
          user.addAll({DatabaseKey.id: orderRef.key});
          finalUser = UserModel.fromMap(user);
        } else {
          "-->> google user $userData".print;
          (userData as Map).forEach((key, value) {
            finalUser = UserModel.fromMap(value);
          });
        }
      }
    } on Exception catch (e) {
      ('signin with google exception -> $e').print;
    }
    Loader.dismiss();
    return finalUser;
  }

  /// send otp
  static Future<(bool, bool, UserModel?)> sendOtp(String email,
      {bool isPass = false}) async {
    Loader.show();
    bool otpSent = false;
    bool isExist = false;
    UserModel? finalUser;
    try {
      var data = await getData(
        DatabaseRef.user,
        email.toLowerCase().trim(),
        comKey: DatabaseKey.email,
      );
      if (data == null) {
        if (!isPass) {
          await EmailOTP.sendOTP(email: email).then(
            (value) => otpSent = value,
          );
        }
      } else {
        if (isPass) {
          (data as Map).forEach((key, value) {
            finalUser = UserModel.fromMap(value);
          });
          await EmailOTP.sendOTP(email: email).then(
            (value) => otpSent = value,
          );
        }
        isExist = true;
      }
    } catch (e) {
      'sendOtp exception $e'.print;
    }
    Loader.dismiss();
    return (otpSent, isExist, finalUser);
  }

  /// verify otp
  static Future<(bool, UserModel?)> verifyOtp(
    UserModel userData,
    String otp, {
    bool isPass = false,
  }) async {
    Loader.show();
    bool verifyOtp = false;
    UserModel? finalUser;
    try {
      verifyOtp = EmailOTP.verifyOTP(otp: otp);
      if (verifyOtp && !isPass) {
        var orderRef = DatabaseRef.user.push();
        await orderRef.set(userData.toJson()).then((value) {
          DatabaseRef.user.child(orderRef.key!).update(
            {DatabaseKey.id: orderRef.key},
          );
        });
        Map<String, dynamic> user = userData.toJson();
        user.addAll({DatabaseKey.id: orderRef.key});
        finalUser = UserModel.fromMap(user);
      }
    } catch (e) {
      'verifyOtp exception $e'.print;
    }
    Loader.dismiss();
    return (verifyOtp, finalUser);
  }

  static Future<bool> resetPass(String id, String pass) async {
    bool isUpdate = false;
    Loader.show();
    try {
      await DatabaseRef.user.child(id).update(
        {DatabaseKey.password: Crypt.sha256(pass).toString()},
      ).then((value) => isUpdate = true);
    } catch (e) {
      isUpdate = false;
      'resetPass exception $e'.print;
    }
    Loader.dismiss();
    return isUpdate;
  }

  static Future<bool> signOutFromGoogle() async {
    try {
      await _googleSignIn.signOut();
      return true;
    } on Exception catch (_) {
      return false;
    }
  }
}
