import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseKillSwitchService {
  static late final FirebaseRemoteConfig remoteConfig;
  static late final DatabaseReference dbRef;
  
  static Future<void> init() async {
    await Firebase.initializeApp();
    
    remoteConfig = FirebaseRemoteConfig.instance;
    dbRef = FirebaseDatabase.instance.ref();
    
    // Configure Remote Config - 1 hour cache during development [citation:7]
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(hours: 1), // Change to 0 for testing
    ));
    
    // Set default values [citation:9]
    await remoteConfig.setDefaults({
      'kill_switch_active': false,
      'kill_switch_message': 'App is temporarily disabled',
      'kill_switch_target_version': 'all',
      'kill_switch_target_user': '',
    });
  }
  
  // Check if app should be blocked (call at app startup)
  static Future<bool> isAppKilled(String userId, String appVersion) async {
    try {
      // Fetch latest config from Firebase [citation:9]
      await remoteConfig.fetchAndActivate();
      
      final bool isActive = remoteConfig.getBool('kill_switch_active');
      final String targetVersion = remoteConfig.getString('kill_switch_target_version');
      final String targetUser = remoteConfig.getString('kill_switch_target_user');
      final String message = remoteConfig.getString('kill_switch_message');
      
      // Check if this user/version should be blocked
      bool shouldBlock = false;
      
      if (isActive) {
        final versionMatches = targetVersion == 'all' || targetVersion == appVersion;
        final userMatches = targetUser.isEmpty || targetUser == userId;
        
        if (versionMatches && userMatches) {
          shouldBlock = true;
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('kill_switch_message', message);
        }
      }
      
      // Log the check (optional)
      await _logKillSwitchCheck(userId, appVersion, shouldBlock);
      
      return shouldBlock;
    } catch (e) {
      print('Kill switch check failed: $e');
      return false; // Allow app to work if Firebase fails
    }
  }
  
  // Get stored block message
  static Future<String?> getBlockMessage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('kill_switch_message') ?? 'App is temporarily disabled';
  }
  
  // Log kill switch check results (for monitoring)
  static Future<void> _logKillSwitchCheck(String userId, String appVersion, bool blocked) async {
    try {
      await dbRef.child('kill_switch_logs/$userId/${DateTime.now().millisecondsSinceEpoch}').set({
        'timestamp': DateTime.now().toIso8601String(),
        'appVersion': appVersion,
        'blocked': blocked,
      });
    } catch (e) {
      // Silent fail - don't crash app if logging fails
    }
  }
  
  // Log user action (optional - for analytics)
  static Future<void> logAction(String userId, String action, Map<String, dynamic> data) async {
    try {
      await dbRef.child('user_actions/$userId/${DateTime.now().millisecondsSinceEpoch}').set({
        'action': action,
        'timestamp': DateTime.now().toIso8601String(),
        'data': data,
      });
    } catch (e) {
      print('Log error: $e');
    }
  }
}