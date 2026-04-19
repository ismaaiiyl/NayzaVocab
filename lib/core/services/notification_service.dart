import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    if (kIsWeb) {
      debugPrint('🔔 [NotificationService] Web detected, skipping notification setup');
      return;
    }

    try {
      tz.initializeTimeZones();
      final timezoneInfo = await FlutterTimezone.getLocalTimezone();
      String timeZoneName = timezoneInfo.toString();
      
      // Fix for some emulators/devices returning a full TimezoneInfo object string
      if (timeZoneName.startsWith('TimezoneInfo(')) {
        final parts = timeZoneName.split(',');
        if (parts.isNotEmpty) {
          timeZoneName = parts[0].replaceAll('TimezoneInfo(', '').trim();
        }
      }
      
      tz.setLocalLocation(tz.getLocation(timeZoneName));
      
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/launcher_icon');

      const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
      );

      await _notificationsPlugin.initialize(
        settings: initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          debugPrint('🔔 [NotificationService] Notification Tapped: ${response.payload}');
        },
      );

      _notificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
      
      debugPrint('🔔 [NotificationService] Initialized Successfully');
    } catch (e) {
      debugPrint('🔔 [NotificationService] Initialization Error: $e');
      // On failure, we don't rethrow to avoid blocking the app startup
    }
  }

  Future<void> showInstantNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'nayza_instant_channel',
      'Nayza Instant Notifications',
      channelDescription: 'Notifications for immediate app feedback',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.show(
      id: DateTime.now().millisecond,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
    );
  }

  Future<void> scheduleDailyReminder({required int hour, required int minute}) async {
    await _notificationsPlugin.zonedSchedule(
      id: 100,
      title: 'Nayza Vocab: Takrorlash vaqti!',
      body: 'Bugungi qiyin so\'zlarni takrorlashni unutmang 🚀',
      scheduledDate: _nextInstanceOfTime(hour, minute),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'nayza_daily_reminder',
          'Nayza Daily Reminders',
          channelDescription: 'Daily reminders for word repetition',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
    
    debugPrint('🔔 [NotificationService] Daily reminder scheduled for $hour:$minute');
  }

  Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
