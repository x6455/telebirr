import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
        InitializationSettings(android: androidSettings);

    await _notifications.initialize(settings);
  }

  static Future<void> showTransferSuccess({
    required String amount,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'transfer_channel',
      'Transfers',
      channelDescription: 'Bank transfer notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    await _notifications.show(
      0,
      'Transfer to Bank',
      'Transfer to bank success for -$amount',
      details,
    );
  }
}
