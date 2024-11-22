import 'dart:convert';
import 'api_service.dart';

class OTPWidget {
  static String _widgetId = '';
  static String _tokenAuth = '';

  // Checks if the widget has been properly initialized with a widget ID and a token.
  // This is an internal method and should not be called directly.
  static bool _checkInitialization() {
    if (_widgetId.isEmpty || _tokenAuth.isEmpty) {
      print("Widget not initialized. Call initializeWidget before using any method.");
      return false;
    }
    return true;
  }

  // Initializes the widget with necessary authentication details.
  // Must be called before using any other methods in the widget.
  static void initializeWidget(String widgetId, String tokenAuth) {
    _widgetId = widgetId;
    _tokenAuth = tokenAuth;
  }

  // The sendOTP method is used to send an OTP to an identifier.
  // Identifier (string) - This is a mandatory argument. The identifier can be an email or mobile number (it must contain the country code without +)
  static Future<Map<String, dynamic>?> sendOTP(Map<String, dynamic> body) async {
  if (!_checkInitialization()) return null;

  final payload = {'widgetId': _widgetId, 'tokenAuth': _tokenAuth, ...body};
  try {
    final response = await ApiService.sendOTP(payload);
    return response;
  } catch (error) {
    throw Exception('Error exception OTP: $error');  // using throw to create a new stack trace
  }
}


  // The verifyOTP method is used to verify an OTP entered by the user.
  static Future<Map<String, dynamic>?> verifyOTP(
      Map<String, dynamic> body) async {
    if (!_checkInitialization()) return null;

    final payload = {'widgetId': _widgetId, 'tokenAuth': _tokenAuth, ...body};
    try {
      final response = await ApiService.verifyOTP(payload);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  // The retryOTP method allows retrying the OTP if it was not received for any reason.
  static Future<Map<String, dynamic>?> retryOTP(
      Map<String, dynamic> body) async {
    if (!_checkInitialization()) return null;

    final payload = {'widgetId': _widgetId, 'tokenAuth': _tokenAuth, ...body};
    try {
      final response = await ApiService.retryOTP(payload);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  // getWidgetProcess method retrieves the current configuration and process information for the widget.
  static Future<Map<String, dynamic>?> getWidgetProcess() async {
    if (!_checkInitialization()) return null;
    try {
      final response = await ApiService.getWidgetProcess(_widgetId, _tokenAuth);
      return response;
    } catch (error) {
      rethrow;
    }
  }

}
