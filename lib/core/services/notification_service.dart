import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nayza_vocab/core/services/notification_channel_helper.dart';
import 'package:nayza_vocab/core/services/notification_storage.dart';
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static String? lastPayload;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized || kIsWeb) return;

    tz_data.initializeTimeZones();
    try {
      await _initCore();
      await NotificationChannelHelper.initTimezone();
      debugPrint('✅ NotificationService FULLY READY');
    } catch (e) {
      debugPrint('🔔 [NotificationService] Init Error: $e');
    }
    _initialized = true;
  }

  Future<void> _initCore() async {
    const androidInit = AndroidInitializationSettings('@mipmap/launcher_icon');
    const settings = InitializationSettings(android: androidInit);

    await _notificationsPlugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        debugPrint('🔔 [NotificationService] Tapped: ${response.payload}');
        lastPayload = response.payload;
        if (response.payload == 'daily_reminder') {
          await _rescheduleFromPrefs();
        }
      },
    );

    await NotificationChannelHelper.createChannels(_notificationsPlugin);
  }

  Future<void> requestPermissions() async {
    if (kIsWeb) return;
    final android = _notificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      await android.requestNotificationsPermission();
      await android.requestExactAlarmsPermission();
    }
  }

  Future<bool> areNotificationsEnabled() async {
    if (kIsWeb) return true;
    final android = _notificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    return await android?.areNotificationsEnabled() ?? false;
  }

  Future<void> showInstantNotification(String title, String body) async {
    await _notificationsPlugin.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          NotificationChannelHelper.instantChannelId,
          'Nayza Instant',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
  }) async {
    if (kIsWeb) return;

    await NotificationStorage.saveReminderTime(hour, minute);
    final scheduled = NotificationChannelHelper.nextTime(hour, minute);

    await _notificationsPlugin.cancel(id: 100);

    await _notificationsPlugin.zonedSchedule(
      id: 100,
      title: '📚 Nayza Vocab: Repetition Time!',
      body: 'Don\'t forget to practice your difficult words today 🚀',
      scheduledDate: scheduled,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          NotificationChannelHelper.dailyChannelId,
          'Nayza Daily',
          importance: Importance.max,
          priority: Priority.max,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: 'daily_reminder',
    );

    debugPrint('⏰ [NotificationService] One-shot scheduled: $scheduled');
  }

  Future<void> checkAndRescheduleOnLaunch() async {
    if (kIsWeb) return;

    final reminder = await NotificationStorage.getReminderTime();
    if (reminder == null) return;

    final wasShown = await NotificationStorage.wasShownToday();
    if (!wasShown) {
      final now = DateTime.now();
      final reminderToday =
          DateTime(now.year, now.month, now.day, reminder.hour, reminder.minute);

      if (now.isAfter(reminderToday)) {
        debugPrint(
            '⚠️ [NotificationService] Missed reminder detected — showing fallback');
        await showInstantNotification(
          '📚 Nayza Vocab Reminder',
          'Don\'t forget to practice your difficult words today 🚀',
        );
        await NotificationStorage.markShownToday();
      }
    }

    await scheduleDailyReminder(hour: reminder.hour, minute: reminder.minute);
  }

  Future<void> _rescheduleFromPrefs() async {
    final reminder = await NotificationStorage.getReminderTime();
    if (reminder == null) return;

    await NotificationStorage.markShownToday();
    await scheduleDailyReminder(hour: reminder.hour, minute: reminder.minute);
    debugPrint('🔁 [NotificationService] Rescheduled for tomorrow');
  }

  Future<void> cancelAll() async {
    await NotificationStorage.clearAll();
    await _notificationsPlugin.cancelAll();
  }
}
