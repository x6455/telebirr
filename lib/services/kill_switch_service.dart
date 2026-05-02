import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';

class KillSwitchService {
  static const String baseUrl = 'https://your-name.trycloudflare.com';
  
  static Future<Map<String, String>> _getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    try {
      if (Theme.of(WidgetsBinding.instance!.rootContext!).platform == TargetPlatform.android) {
        final androidInfo = await deviceInfo.androidInfo;
        return {
          'model': androidInfo.model,
          'osVersion': androidInfo.version.release,
          'manufacturer': androidInfo.manufacturer,
        };
      } else if (Theme.of(WidgetsBinding.instance!.rootContext!).platform == TargetPlatform.iOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return {
          'model': iosInfo.model,
          'osVersion': iosInfo.systemVersion,
          'manufacturer': 'Apple',
        };
      }
    } catch (e) {
      print('Failed to get device info: $e');
    }
    return {'model': 'Unknown', 'osVersion': 'Unknown', 'manufacturer': 'Unknown'};
  }
  
  static Future<bool> checkKillSwitch(String userId) async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final appVersion = packageInfo.version;
      final deviceInfo = await _getDeviceInfo();
      
      final response = await http.get(
        Uri.parse('$baseUrl/api/kill-switch/status')
          .replace(queryParameters: {
            'userId': userId,
            'appVersion': appVersion,
            'deviceModel': deviceInfo['model'] ?? 'Unknown',
            'osVersion': deviceInfo['osVersion'] ?? 'Unknown',
          }),
      ).timeout(const Duration(seconds: 5));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final isBlocked = data['blocked'] as bool;
        
        if (isBlocked) {
          final message = data['message'] as String? ?? 'App is temporarily disabled';
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('kill_switch_blocked', true);
          await prefs.setString('kill_switch_message', message);
          return true;
        } else {
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('kill_switch_blocked');
          return false;
        }
      }
    } catch (e) {
      print('Kill switch check failed: $e');
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('kill_switch_blocked') ?? false;
    }
    return false;
  }
  
  static Future<void> logAppAction(String userId, String action) async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final deviceInfo = await _getDeviceInfo();
      
      await http.post(
        Uri.parse('$baseUrl/api/kill-switch/log'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': userId,
          'appVersion': packageInfo.version,
          'action': action,
          'deviceInfo': deviceInfo,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      ).timeout(const Duration(seconds: 3));
    } catch (e) {
      print('Failed to log action: $e');
    }
  }
}