import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String _dailyChannelId = 'nayza_daily_reminder_v3';
  static const String _instantChannelId = 'nayza_instant_v1';

  // SharedPreferences keys
  static const String _prefHour = 'reminder_hour';
  static const String _prefMinute = 'reminder_minute';
  static const String _prefLastShown = 'reminder_last_shown_date';

  static String? lastPayload;
  bool _initialized = false;

  // ================= INIT =================
  Future<void> init() async {
    if (_initialized) return;
    if (kIsWeb) return;

    tz_data.initializeTimeZones();

    // ✅ await bilan — race condition yo'q
    try {
      await _initFull();
    } catch (e) {
      debugPrint('🔔 [NotificationService] Init Error: $e');
    }

    _initialized = true;
  }

  Future<void> _initFull() async {
    await _initCore();
    await _initTimezoneSafe();
    debugPrint('✅ NotificationService FULLY READY');
  }

  // ================= CORE INIT =================
  Future<void> _initCore() async {
    const androidInit = AndroidInitializationSettings('@mipmap/launcher_icon');
    const settings = InitializationSettings(android: androidInit);

    await _notificationsPlugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        debugPrint('🔔 [NotificationService] Tapped: ${response.payload}');
        lastPayload = response.payload;

        // ✅ RESCHEDULE: Notification kelganda ertangi kunni qayta schedule qil
        // matchDateTimeComponents ga ishonmaymiz — har kuni o'zimiz schedule qilamiz
        if (response.payload == 'daily_reminder') {
          await _rescheduleFromPrefs();
        }
      },
    );

    await _createChannels();
  }

  // ================= CHANNEL =================
  Future<void> _createChannels() async {
    final android = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return;

    const dailyChannel = AndroidNotificationChannel(
      _dailyChannelId,
      'Nayza Daily Reminders',
      description: 'Vocabulary practice reminders',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    const instantChannel = AndroidNotificationChannel(
      _instantChannelId,
      'Nayza Instant Notifications',
      importance: Importance.max,
    );

    await android.createNotificationChannel(dailyChannel);
    await android.createNotificationChannel(instantChannel);
  }

  // ================= TIMEZONE SAFE =================
  Future<void> _initTimezoneSafe() async {
    try {
      final name = (await FlutterTimezone.getLocalTimezone()).toString();
      tz.setLocalLocation(tz.getLocation(name));
      debugPrint('🔔 [NotificationService] Timezone: $name');
    } catch (e) {
      debugPrint('🔔 [NotificationService] Timezone failed ($e), using UTC');
      // ✅ tz.UTC — package konstantasi, getLocation('UTC') dan farqli ravishda
      // hech qachon "Location not found" xatosi bermaydi
      tz.setLocalLocation(tz.UTC);
    }
  }

  // ================= PERMISSIONS =================
  Future<void> requestPermissions() async {
    if (kIsWeb) return;
    final android = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      await android.requestNotificationsPermission();
      await android.requestExactAlarmsPermission();
    }
  }

  Future<bool> areNotificationsEnabled() async {
    if (kIsWeb) return true;
    final android = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    return await android?.areNotificationsEnabled() ?? false;
  }

  // ================= INSTANT =================
  Future<void> showInstantNotification(String title, String body) async {
    await _notificationsPlugin.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _instantChannelId,
          'Nayza Instant',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  // ================= SCHEDULE (ONE-SHOT) =================
  /// Faqat BITTA, keyingi trigger uchun alarm qo'yamiz.
  /// matchDateTimeComponents ISHLATMAYMIZ — repeating alarm ishonchsiz.
  /// Har trigger dan keyin reschedule qilinadi (onDidReceiveNotificationResponse + checkAndRescheduleOnLaunch).
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
  }) async {
    if (kIsWeb) return;

    // Prefs ga saqlash — reboot va fallback uchun kerak
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefHour, hour);
    await prefs.setInt(_prefMinute, minute);

    final scheduled = _nextTime(hour, minute);

    // Avvalgi alarmni bekor qil
    await _notificationsPlugin.cancel(id: 100);

    await _notificationsPlugin.zonedSchedule(
      id: 100,
      title: '📚 Nayza Vocab: Repetition Time!',
      body: 'Don\'t forget to practice your difficult words today 🚀',
      scheduledDate: scheduled,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _dailyChannelId,
          'Nayza Daily',
          importance: Importance.max,
          priority: Priority.max,
        ),
      ),
      // ✅ matchDateTimeComponents YO'Q — one-shot, keyin qayta schedule
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: 'daily_reminder',
    );

    debugPrint('⏰ [NotificationService] One-shot scheduled: $scheduled');
  }

  // ================= FALLBACK: APP LAUNCH CHECK =================
  /// App ochilganda chaqir.
  /// Agar bugun notification ko'rsatilmagan bo'lsa va vaqt o'tgan bo'lsa —
  /// darhol eslatma ko'rsat va ertangi kunni schedule qil.
  Future<void> checkAndRescheduleOnLaunch() async {
    if (kIsWeb) return;

    final prefs = await SharedPreferences.getInstance();
    final hour = prefs.getInt(_prefHour);
    final minute = prefs.getInt(_prefMinute);

    // Reminder o'rnatilmagan bo'lsa — hech narsa qilma
    if (hour == null || minute == null) return;

    final now = DateTime.now();
    final todayStr = '${now.year}-${now.month}-${now.day}';
    final lastShown = prefs.getString(_prefLastShown);

    final alreadyShownToday = lastShown == todayStr;

    if (!alreadyShownToday) {
      final reminderToday = DateTime(now.year, now.month, now.day, hour, minute);

      if (now.isAfter(reminderToday)) {
        // ❗ Reminder vaqti o'tdi lekin notification kelmadi → missed!
        debugPrint('⚠️ [NotificationService] Missed reminder detected — showing fallback');

        await showInstantNotification(
          '📚 Nayza Vocab Reminder',
          'Don\'t forget to practice your difficult words today 🚀',
        );

        await prefs.setString(_prefLastShown, todayStr);
      }
    }

    // Har holda ertangi kunni qayta schedule qil (alarm yo'qolgan bo'lishi mumkin)
    await scheduleDailyReminder(hour: hour, minute: minute);
  }

  /// Notification trigger bo'lganda ertangi kunni schedule qilish uchun
  Future<void> _rescheduleFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final hour = prefs.getInt(_prefHour);
    final minute = prefs.getInt(_prefMinute);
    if (hour == null || minute == null) return;

    // Bugun ko'rsatildi deb belgilaymiz
    final now = DateTime.now();
    final todayStr = '${now.year}-${now.month}-${now.day}';
    await prefs.setString(_prefLastShown, todayStr);

    // Ertangi kunni schedule qil
    await scheduleDailyReminder(hour: hour, minute: minute);
    debugPrint('🔁 [NotificationService] Rescheduled for tomorrow');
  }

  // ================= HELPERS =================
  tz.TZDateTime _nextTime(int hour, int minute) {
    // ✅ DateTime.now() — Dart runtime doim to'g'ri local timezone biladi
    // (UTC offset OS dan olinadi — FlutterTimezone ga bog'liq emas)
    // tz.local = UTC ga tushgan bo'lsa ham bu to'g'ri ishlaydi
    final localNow = DateTime.now();
    var localTarget =
        DateTime(localNow.year, localNow.month, localNow.day, hour, minute);

    if (localTarget.isBefore(localNow)) {
      localTarget = localTarget.add(const Duration(days: 1));
    }

    // TZDateTime.from() → localTarget.millisecondsSinceEpoch (UTC epoch) ishlatadi
    // Ya'ni: local vaqtni to'g'ri UTC ga o'girib beradi
    return tz.TZDateTime.from(localTarget, tz.UTC);
  }

  Future<void> cancelAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefHour);
    await prefs.remove(_prefMinute);
    await prefs.remove(_prefLastShown);
    await _notificationsPlugin.cancelAll();
  }
}
