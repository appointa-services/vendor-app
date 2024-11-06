import 'package:shared_preferences/shared_preferences.dart';

class Pref {
  static const String emailKey = "email";
  static const String userData = "userData";
  static const String isAdminKey = "isAdmin";

  static Future<SharedPreferences> pref() async =>
      await SharedPreferences.getInstance();

  static void setString(String key, String value) async {
    (await pref()).setString(key, value);
  }

  static Future<String> getString(String key) async {
    String data = (await pref()).getString(key) ?? "";
    return data;
    // .replaceAll('{', '{"')
    // .replaceAll(': ', '": "')
    // .replaceAll(', ', '", "')
    // .replaceAll('}', '"}')
    // .replaceAll('"false"', 'false')
    // .replaceAll('"true"', 'true');
  }

  static void setbBool(String key, bool value) async {
    (await pref()).setBool(key, value);
  }

  static Future<bool> getBool(String key) async {
    return (await pref()).getBool(key) ?? false;
  }

  static Future<void> clearAlData() async {
    (await pref()).clear();
  }
}
