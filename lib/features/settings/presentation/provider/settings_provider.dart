import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nayza_vocab/core/services/notification_service.dart';
import 'package:nayza_vocab/core/utils/audio_helper.dart';

class SettingsProvider with ChangeNotifier {
  final SharedPreferences _prefs;
  
  bool _isMuted = false;
  String _languageCode = 'uz';
  bool _hasSeenOnboarding = false;
  double _speechRate = 0.5;

  // User Profile Data
  String _userName = 'Jangchi';
  int _userAge = 20;
  String _targetLanguage = 'English';

  SettingsProvider(this._prefs) {
    _loadSettings();
  }

  // Getters
  bool get isMuted => _isMuted;
  String get languageCode => _languageCode;
  bool get hasSeenOnboarding => _hasSeenOnboarding;
  double get speechRate => _speechRate;
  String get userName => _userName;
  int get userAge => _userAge;
  String get targetLanguage => _targetLanguage;

  void _loadSettings() {
    _isMuted = _prefs.getBool('is_muted') ?? false;
    _languageCode = _prefs.getString('language_code') ?? 'uz';
    _hasSeenOnboarding = _prefs.getBool('has_seen_onboarding') ?? false;
    _speechRate = _prefs.getDouble('tts_speech_rate') ?? 0.5;
    AudioHelper().setSpeechRate(_speechRate);
    _userName = _prefs.getString('user_name') ?? 'Jangchi';
    _userAge = _prefs.getInt('user_age') ?? 20;
    _targetLanguage = _prefs.getString('target_language') ?? 'English';
    notifyListeners();
  }

  Future<void> setSpeechRate(double rate) async {
    _speechRate = rate;
    await _prefs.setDouble('tts_speech_rate', rate);
    AudioHelper().setSpeechRate(rate);
    notifyListeners();
  }

  Future<void> updateProfile({
    required String name,
    required int age,
    required String targetLanguage,
  }) async {
    _userName = name.trim().isEmpty ? 'Jangchi' : name.trim();
    _userAge = age <= 0 ? 20 : age;
    _targetLanguage = targetLanguage.trim().isEmpty ? 'English' : targetLanguage.trim();

    await _prefs.setString('user_name', _userName);
    await _prefs.setInt('user_age', _userAge);
    await _prefs.setString('target_language', _targetLanguage);
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
    await NotificationService().cancelAll();
    notifyListeners();
  }
}
