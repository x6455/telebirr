import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  /// Initialize the notification plugin
  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('notification_icon'); // <-- your drawable name, no @ or .png

    const InitializationSettings settings =
        InitializationSettings(android: androidSettings);

    await _notifications.initialize(settings);
  }

  /// Show a transfer success notification
  static Future<void> showTransferSuccess({
    required String amount,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'transfer_channel', // channel ID
      'Transfers', // channel name
      channelDescription: 'Bank transfer notifications', // channel description
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: 'notification_icon', // <-- small icon from res/drawable
    );

    const NotificationDetails details = NotificationDetails(android: androidDetails);

    await _notifications.show(
      0, // notification ID
      'Transfer to Bank', // title
      'Transfer to bank success for -$amount', // body
      details,
    );
  }
}
