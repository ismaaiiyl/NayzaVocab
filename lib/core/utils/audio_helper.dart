import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:vibration/vibration.dart';
import 'dart:async';
import 'dart:io' show Platform;

class AudioHelper {
  final FlutterTts _tts = FlutterTts();
  late AudioPlayer _player;
  bool _isPlayerInitialized = false;
  bool _isTtsInitialized = false;
  
  static final AudioHelper _instance = AudioHelper._internal();
  factory AudioHelper() => _instance;
  
  AudioHelper._internal() {
    _initHelper();
  }

  bool _isMuted = false;
  
  set isMuted(bool value) {
    if (_isMuted == value) return;
    _isMuted = value;
    debugPrint('🔊 [AudioHelper] Mute state: $_isMuted');
    
    if (_isMuted) {
      stopAll();
      playToggle(true); // Vibration feedback for muting
    } else {
      playToggle(false); // Sound + vibration feedback for unmuting
    }
  }

  bool get isMuted => _isMuted;

  Future<void> _initHelper() async {
    if (_isTtsInitialized) return;
    try {
      _player = AudioPlayer();
      _isPlayerInitialized = true;
      
      await _tts.setVolume(1.0);
      await _tts.setSpeechRate(0.52);
      await _tts.setPitch(1.0);
      await _tts.awaitSpeakCompletion(true);
      
      if (kIsWeb) {
        debugPrint('🔊 [AudioHelper] Web init...');
      } else if (Platform.isAndroid) {
         // Some engines work better than others
         await _tts.setEngine('com.google.android.tts');
      }
      _isTtsInitialized = true;
      debugPrint('🔊 [AudioHelper] TTS Ready');
    } catch (e) {
      debugPrint('🔊 [AudioHelper] Init Error: $e');
    }
  }

  Future<void> stopAll() async {
    try {
      await _tts.stop();
      if (_isPlayerInitialized) {
        await _player.stop();
      }
    } catch (e) {
      debugPrint('🔊 [AudioHelper] Stop Error: $e');
    }
  }

  Future<void> speak(String text, {String? langCode}) async {
    if (isMuted) return;

    try {
      if (!_isTtsInitialized) await _initHelper();
      
      String locale = _normalizeLocale(langCode);
      
      // Senior-level check: Verify if the selected language is actually supported by the device
      final dynamic avail = await _tts.isLanguageAvailable(locale);
      final bool isAvailable = avail is bool ? avail : false;
      if (!isAvailable) {
        debugPrint('🔊 [AudioHelper] Language $locale not available, falling back to en-US');
        locale = 'en-US';
      }

      await _tts.stop(); // Stop current speech before starting new one
      
      if (isMuted) return;

      await _tts.setLanguage(locale);
      await _tts.speak(text);
      debugPrint('🔊 [AudioHelper] Speaking: $text in $locale');
    } catch (e) {
      debugPrint('🔊 [AudioHelper] TTS Exception: $e');
    }
  }

  String _normalizeLocale(String? code) {
    if (code == null) return 'en-US';
    final c = code.toLowerCase();
    if (c.contains('uz') || c.contains('uzb')) return 'uz-UZ';
    if (c.contains('ru')) return 'ru-RU';
    if (c.contains('tr')) return 'tr-TR';
    if (c.contains('ar')) return 'ar-SA';
    return 'en-US';
  }

  Future<void> playSuccess() async {
    if (isMuted) return;
    try {
      _vibrate(duration: 60);
      await _guardedPlay('audio/success.mp3');
    } catch (e) {
      debugPrint('🔊 [AudioHelper] playSuccess Error: $e');
    }
  }

  Future<void> playError() async {
    if (isMuted) return;
    try {
      _vibrate(pattern: [0, 80, 40, 80]);
      await _guardedPlay('audio/error.mp3');
    } catch (e) {
      debugPrint('🔊 [AudioHelper] playError Error: $e');
    }
  }

  Future<void> playToggle(bool mute) async {
    if (mute) {
      _vibrate(duration: 80);
      return;
    }
    
    try {
      _vibrate(duration: 40);
      await _guardedPlay('audio/sound.mp3');
    } catch (e) {
      debugPrint('🔊 [AudioHelper] playToggle Error: $e');
    }
  }

  Future<void> _guardedPlay(String assetPath) async {
    if (!_isPlayerInitialized) {
      _player = AudioPlayer();
      _isPlayerInitialized = true;
    }

    try {
      try { await _player.stop(); } catch (_) {}
      await _player.play(AssetSource(assetPath));
    } catch (e) {
      debugPrint('🔊 [AudioHelper] Play exception: $assetPath - $e');
    }
  }

  Future<void> _vibrate({int duration = 50, List<int>? pattern}) async {
    try {
      if (pattern != null) {
        await Vibration.vibrate(pattern: pattern);
      } else {
        await Vibration.vibrate(duration: duration);
      }
    } catch (e) {
      // Ignore vibration error
    }
  }

  void dispose() {
    stopAll();
    if (_isPlayerInitialized) {
      _player.dispose();
      _isPlayerInitialized = false;
    }
  }
}

