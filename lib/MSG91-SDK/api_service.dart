import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_urls.dart';

class ApiService {
  static const int MAX_REDIRECTS = 10;
  static const Duration TIMEOUT_DURATION = Duration(seconds: 15); // Timeout duration

  static Future<Map<String, dynamic>> _handleRedirect(
    String url,
    Map<String, dynamic> body, {
    bool isPost = true,
    int redirectCount = 0,
  }) async {
    if (redirectCount > MAX_REDIRECTS) {
      throw Exception('Too many redirects for URL: $url');
    }

    http.Response response;
    if (isPost) {
      response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body),
      ).timeout(TIMEOUT_DURATION);
    } else {
      response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ).timeout(TIMEOUT_DURATION);
    }

    final responseCode = response.statusCode;
    final redirectUrl = response.headers['location'];

    if (responseCode >= 300 && responseCode < 400 && redirectUrl != null) {
      return _handleRedirect(
        redirectUrl,
        body,
        isPost: false,
        redirectCount: redirectCount + 1,
      );
    } else {
      final responseBody = response.body;
      if (responseCode >= 200 && responseCode < 400) {
        return jsonDecode(responseBody);
      } else {
        throw Exception('Failed to ${isPost ? 'post' : 'get'} data: $responseCode, $responseBody');
      }
    }
  }

  static Future<Map<String, dynamic>> sendOTP(Map<String, dynamic> body) async {
    try {
      return await _handleRedirect(ApiUrls.sendOTP, body, isPost: true);
    } catch (e) {
      throw Exception('Error sending OTP: $e');
    }
  }

  static Future<Map<String, dynamic>> verifyOTP(Map<String, dynamic> body) async {
    try {
      return await _handleRedirect(ApiUrls.verifyOTP, body, isPost: true);
    } catch (e) {
      throw Exception('Error verifying OTP: $e');
    }
  }

  static Future<Map<String, dynamic>> retryOTP(Map<String, dynamic> body) async {
    try {
      return await _handleRedirect(ApiUrls.retryOTP, body, isPost: true);
    } catch (e) {
      throw Exception('Error retrying OTP: $e');
    }
  }

  static Future<Map<String, dynamic>> getWidgetProcess(String widgetId, String tokenAuth) async {
    try {
      final url = ApiUrls.getWidgetProcess(widgetId, tokenAuth);
      return await _handleRedirect(url, {}, isPost: false);
    } catch (e) {
      throw Exception('Error getting widget process: $e');
    }
  }
}
