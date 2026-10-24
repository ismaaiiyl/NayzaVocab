import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationChannelHelper {
  static const String dailyChannelId = 'nayza_daily_reminder_v3';
  static const String instantChannelId = 'nayza_instant_v1';

  static Future<void> createChannels(
      FlutterLocalNotificationsPlugin plugin) async {
    final android = plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return;

    const dailyChannel = AndroidNotificationChannel(
      dailyChannelId,
      'Nayza Daily Reminders',
      description: 'Vocabulary practice reminders',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    const instantChannel = AndroidNotificationChannel(
      instantChannelId,
      'Nayza Instant Notifications',
      importance: Importance.max,
    );

    await android.createNotificationChannel(dailyChannel);
    await android.createNotificationChannel(instantChannel);
  }

  static Future<void> initTimezone() async {
    try {
      final name = (await FlutterTimezone.getLocalTimezone()).toString();
      tz.setLocalLocation(tz.getLocation(name));
      debugPrint('🔔 [NotificationService] Timezone: $name');
    } catch (e) {
      debugPrint('🔔 [NotificationService] Timezone fallback to UTC: $e');
      tz.setLocalLocation(tz.UTC);
    }
  }

  static tz.TZDateTime nextTime(int hour, int minute) {
    final localNow = DateTime.now();
    var localTarget =
        DateTime(localNow.year, localNow.month, localNow.day, hour, minute);

    if (localTarget.isBefore(localNow)) {
      localTarget = localTarget.add(const Duration(days: 1));
    }

    return tz.TZDateTime.from(localTarget, tz.UTC);
  }
}
