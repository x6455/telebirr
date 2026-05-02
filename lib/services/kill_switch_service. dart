import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';

class KillSwitchService {
  // Replace with your Cloudflare URL from cloudflared
  static const String baseUrl = 'https://your-name.trycloudflare.com';
  
  static Future<bool> checkKillSwitch(String userId) async {
    try {
      // Get app version
      final packageInfo = await PackageInfo.fromPlatform();
      final appVersion = packageInfo.version;
      
      print('Checking kill switch for user: $userId, version: $appVersion');
      
      // Check status from server
      final response = await http.get(
        Uri.parse('$baseUrl/api/kill-switch/status')
          .replace(queryParameters: {
            'userId': userId,
            'appVersion': appVersion,
          }),
      ).timeout(const Duration(seconds: 5));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final isBlocked = data['blocked'] as bool;
        
        if (isBlocked) {
          final message = data['message'] as String? ?? 'App is temporarily disabled';
          
          // Save to local storage to persist block state
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('kill_switch_blocked', true);
          await prefs.setString('kill_switch_message', message);
          
          print('App is BLOCKED: $message');
          return true;
        } else {
          // Clear block state if not blocked
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('kill_switch_blocked');
          await prefs.remove('kill_switch_message');
          print('App is NOT blocked');
          return false;
        }
      }
    } catch (e) {
      print('Kill switch check failed: $e');
      // Fallback to local storage if network fails
      final prefs = await SharedPreferences.getInstance();
      final wasBlocked = prefs.getBool('kill_switch_blocked') ?? false;
      print('Using cached block state: $wasBlocked');
      return wasBlocked;
    }
    
    return false;
  }
  
  static Future<void> logAppAction(String userId, String action) async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      await http.post(
        Uri.parse('$baseUrl/api/kill-switch/log'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': userId,
          'appVersion': packageInfo.version,
          'action': action,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      ).timeout(const Duration(seconds: 3));
    } catch (e) {
      // Silent fail for logging
      print('Failed to log action: $e');
    }
  }
  
  static Future<String?> getBlockedMessage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('kill_switch_message');
  }
  
  static Future<void> clearBlockState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('kill_switch_blocked');
    await prefs.remove('kill_switch_message');
  }
}
