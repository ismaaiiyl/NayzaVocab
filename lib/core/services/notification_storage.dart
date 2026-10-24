import 'package:shared_preferences/shared_preferences.dart';

class NotificationStorage {
  static const String _prefHour = 'reminder_hour';
  static const String _prefMinute = 'reminder_minute';
  static const String _prefLastShown = 'reminder_last_shown_date';

  static Future<void> saveReminderTime(int hour, int minute) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefHour, hour);
    await prefs.setInt(_prefMinute, minute);
  }

  static Future<({int hour, int minute})?> getReminderTime() async {
    final prefs = await SharedPreferences.getInstance();
    final hour = prefs.getInt(_prefHour);
    final minute = prefs.getInt(_prefMinute);
    if (hour == null || minute == null) return null;
    return (hour: hour, minute: minute);
  }

  static Future<void> markShownToday() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    await prefs.setString(_prefLastShown, '${now.year}-${now.month}-${now.day}');
  }

  static Future<bool> wasShownToday() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final todayStr = '${now.year}-${now.month}-${now.day}';
    return prefs.getString(_prefLastShown) == todayStr;
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefHour);
    await prefs.remove(_prefMinute);
    await prefs.remove(_prefLastShown);
  }
}
