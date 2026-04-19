import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nayza_vocab/core/services/notification_service.dart';

class SettingsProvider with ChangeNotifier {
  final SharedPreferences _prefs;
  
  bool _isMuted = false;
  String _languageCode = 'uz';
  bool _hasSeenOnboarding = false;

  SettingsProvider(this._prefs) {
    _loadSettings();
  }

  // Getters
  bool get isMuted => _isMuted;
  String get languageCode => _languageCode;
  bool get hasSeenOnboarding => _hasSeenOnboarding;

  void _loadSettings() {
    _isMuted = _prefs.getBool('is_muted') ?? false;
    _languageCode = _prefs.getString('language_code') ?? 'uz';
    _hasSeenOnboarding = _prefs.getBool('has_seen_onboarding') ?? false;
    notifyListeners();
  }

  Future<void> toggleMute() async {
    _isMuted = !_isMuted;
    await _prefs.setBool('is_muted', _isMuted);
    notifyListeners();
  }

  Future<void> setLanguage(String code) async {
    _languageCode = code;
    await _prefs.setString('language_code', code);
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _hasSeenOnboarding = true;
    await _prefs.setBool('has_seen_onboarding', true);
    notifyListeners();
  }

  Future<void> saveReminderTime(int hour, int minute) async {
    await _prefs.setInt('reminder_hour', hour);
    await _prefs.setInt('reminder_minute', minute);
    
    // Reschedule in NotificationService
    await NotificationService().scheduleDailyReminder(hour: hour, minute: minute);
    
    notifyListeners();
  }
  String? getReminderTimeStr() {
    final hour = _prefs.getInt('reminder_hour');
    final minute = _prefs.getInt('reminder_minute');
    if (hour == null || minute == null) return null;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  Future<void> cancelReminder() async {
    await _prefs.remove('reminder_hour');
    await _prefs.remove('reminder_minute');
    await NotificationService().cancelAll();
    notifyListeners();
  }
}
