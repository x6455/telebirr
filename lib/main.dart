import 'package:flutter/material.dart';
import 'package:telebirrbybr7/services/firebase_kill_switch_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'screens/login_page.dart';
import 'widgets/kill_switch_overlay.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase services
  await FirebaseKillSwitchService.init();
  
  // Get or create user ID
  final prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('user_id');
  if (userId == null) {
    userId = const Uuid().v4();
    await prefs.setString('user_id', userId);
  }
  
  // Get app version
  final packageInfo = await PackageInfo.fromPlatform();
  final appVersion = packageInfo.version;
  
  // Check if app is killed
  final isKilled = await FirebaseKillSwitchService.isAppKilled(userId, appVersion);
  
  runApp(MyApp(isKilled: isKilled));
}

class MyApp extends StatelessWidget {
  final bool isKilled;
  
  const MyApp({Key? key, required this.isKilled}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Telebirr',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: isKilled 
        ? FutureBuilder(
            future: FirebaseKillSwitchService.getBlockMessage(),
            builder: (context, snapshot) {
              return KillSwitchOverlay(
                message: snapshot.data ?? 'App is temporarily disabled'
              );
            }
          )
        : const LoginPage(),
    );
  }
}