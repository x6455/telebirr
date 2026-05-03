import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'screens/login_page.dart';

void main() async {
  runApp(ErrorBoundary(child: const MyApp()));
}

// Wrapper that catches all errors and shows them on screen
class ErrorBoundary extends StatelessWidget {
  final Widget child;
  
  const ErrorBoundary({Key? key, required this.child}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ErrorHandler(child: child),
      ),
    );
  }
}

class ErrorHandler extends StatefulWidget {
  final Widget child;
  
  const ErrorHandler({Key? key, required this.child}) : super(key: key);
  
  @override
  State<ErrorHandler> createState() => _ErrorHandlerState();
}

class _ErrorHandlerState extends State<ErrorHandler> {
  String? errorMessage;
  String? errorStack;
  
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }
  
  void _initializeApp() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      
      print('Step 1: Initializing Firebase...');
      await Firebase.initializeApp();
      setState(() {});
      
      print('Step 2: Getting user ID...');
      final prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('user_id');
      if (userId == null) {
        userId = const Uuid().v4();
        await prefs.setString('user_id', userId);
      }
      
      print('Step 3: Getting app version...');
      final packageInfo = await PackageInfo.fromPlatform();
      final appVersion = packageInfo.version;
      
      print('Step 4: Checking kill switch...');
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ));
      await remoteConfig.fetchAndActivate();
      
      final isActive = remoteConfig.getBool('kill_switch_active');
      final targetVersion = remoteConfig.getString('kill_switch_target_version');
      final targetUser = remoteConfig.getString('kill_switch_target_user');
      final message = remoteConfig.getString('kill_switch_message');
      
      final versionMatches = targetVersion == 'all' || targetVersion == appVersion;
      final userMatches = targetUser.isEmpty || targetUser == userId;
      final isKilled = isActive && versionMatches && userMatches;
      
      if (isKilled) {
        await prefs.setString('kill_switch_message', message);
      }
      
      print('Step 5: Starting app...');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => isKilled ? KillSwitchScreen(message: message) : const LoginPage())
      );
      
    } catch (e, stack) {
      print('ERROR: $e');
      print('STACK: $stack');
      setState(() {
        errorMessage = e.toString();
        errorStack = stack.toString();
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (errorMessage != null) {
      return ErrorScreen(
        error: errorMessage!, 
        stack: errorStack,
        onRetry: () {
          setState(() {
            errorMessage = null;
            errorStack = null;
          });
          _initializeApp();
        }
      );
    }
    
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text('Starting app...'),
        ],
      ),
    );
  }
}

// Error screen that shows what went wrong
class ErrorScreen extends StatelessWidget {
  final String error;
  final String? stack;
  final VoidCallback onRetry;
  
  const ErrorScreen({Key? key, required this.error, this.stack, required this.onRetry}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 60),
              const SizedBox(height: 20),
              const Text(
                'App Initialization Error',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[900],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Error Message:', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text(error, style: const TextStyle(color: Colors.white)),
                    if (stack != null) ...[
                      const SizedBox(height: 15),
                      const Text('Stack Trace:', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      Container(
                        height: 200,
                        child: SingleChildScrollView(
                          child: Text(
                            stack!,
                            style: const TextStyle(color: Colors.white70, fontSize: 10),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Kill switch screen
class KillSwitchScreen extends StatelessWidget {
  final String message;
  
  const KillSwitchScreen({Key? key, required this.message}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.block, color: Colors.red, size: 100),
              const SizedBox(height: 30),
              const Text(
                'ACCESS BLOCKED',
                style: TextStyle(color: Colors.red, fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Your original MyApp (simplified)
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return const ErrorBoundary(child: MaterialApp(home: LoginPage()));
  }
}
