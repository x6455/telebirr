import 'package:flutter/services.dart';

class SmsSender {
  static const _channel = MethodChannel('sms_sender');

  /// Sends SMS via native Kotlin MethodChannel
  static Future<void> sendSms(String phone, String message) async {
    try {
      await _channel.invokeMethod('sendSms', {
        'phone': phone,
        'message': message,
      });
    } on PlatformException catch (e) {
      print("SMS send error: ${e.message}");
      rethrow;
    }
  }
}