import 'package:flutter/services.dart';

class DefaultSmsHelper {
  static const MethodChannel _channel = MethodChannel('default_sms');

  static Future<void> requestDefaultSms() async {
    try {
      await _channel.invokeMethod('requestDefaultSms');
    } on PlatformException catch (e) {
      print("Error requesting default SMS: ${e.message}");
    }
  }

  static Future<bool> isDefaultSms() async {
    try {
      final bool result = await _channel.invokeMethod('isDefaultSms');
      return result;
    } on PlatformException catch (e) {
      print("Error checking default SMS: ${e.message}");
      return false;
    }
  }
}