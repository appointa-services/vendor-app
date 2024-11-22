class ApiUrls {
  static const String _baseUrl = 'https://control.msg91.com/api/v5/widget';

  static String createEndpoint(String endpoint) {
    return '$_baseUrl$endpoint';
  }

  static final String sendOTP = createEndpoint('/sendOtpMobile');
  static final String verifyOTP = createEndpoint('/verifyOtp');
  static final String retryOTP = createEndpoint('/retryOtp');
  static String getWidgetProcess(String widgetId, String tokenAuth) {
    return createEndpoint('/getWidgetProcess?widgetId=$widgetId&tokenAuth=$tokenAuth');
  }
}
