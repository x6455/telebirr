import 'package:flutter/material.dart';
import 'package:telebirrbybr7/colors.dart';
import 'package:telebirrbybr7/screens/main_screen.dart';
import 'package:telebirrbybr7/screens/login_page.dart';
import 'package:telebirrbybr7/services/notification_service.dart';
import 'package:telebirrbybr7/services/kill_switch_service.dart';
import 'package:telebirrbybr7/widgets/kill_switch_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  
  // Initialize user ID if not exists
  final prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('user_id');
  if (userId == null) {
    userId = const Uuid().v4();
    await prefs.setString('user_id', userId);
  }
  
  // Check kill switch before running app - USE WithoutContext version
  final isBlocked = await KillSwitchService.checkKillSwitchWithoutContext(userId);
  final blockMessage = prefs.getString('kill_switch_message') ?? 'App is temporarily disabled';
  
  runApp(MyApp(isBlocked: isBlocked, blockMessage: blockMessage));
}

class MyApp extends StatelessWidget {
  final bool isBlocked;
  final String blockMessage;
  
  const MyApp({Key? key, required this.isBlocked, required this.blockMessage}) 
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Telebirr',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: mainColor,
          primary: mainColor,
        ),
        useMaterial3: true,
      ),
      home: isBlocked 
        ? KillSwitchOverlay(message: blockMessage)
        : const LoginPage(),
    );
  }
}