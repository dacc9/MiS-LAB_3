import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  final _prefs = SharedPreferences.getInstance();
  static GlobalKey<NavigatorState>? navigatorKey;

  static const String _notificationKey = 'daily_notification_enabled';

  Future<void> initialize(GlobalKey<NavigatorState> navKey) async {
    navigatorKey = navKey;
    tz.initializeTimeZones();

    // Check if app was launched from a notification
    final notificationAppLaunchDetails = await _notifications.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      await _handleNotificationTap();
    }

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        await _handleNotificationTap();
      },
    );
  }

  Future<void> _handleNotificationTap() async {
    if (navigatorKey?.currentState != null) {
      await navigatorKey!.currentState!.pushNamed('/random_joke');
    }
  }

  Future<void> scheduleDailyNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'joke_reminder',
      'Joke Reminders',
      channelDescription: 'Daily reminders to check the joke of the day',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final now = DateTime.now();
    var scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      10,
      0,
    );

    if (now.isAfter(scheduledDate)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _notifications.zonedSchedule(
      0,
      'Time for a laugh!',
      'Tap to see today\'s joke',
      tz.TZDateTime.from(scheduledDate, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    final prefs = await _prefs;
    await prefs.setBool(_notificationKey, true);
  }

  Future<void> cancelDailyNotification() async {
    await _notifications.cancel(0);
    final prefs = await _prefs;
    await prefs.setBool(_notificationKey, false);
  }

  Future<bool> areNotificationsEnabled() async {
    final prefs = await _prefs;
    return prefs.getBool(_notificationKey) ?? false;
  }
}