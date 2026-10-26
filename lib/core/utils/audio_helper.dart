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
  
  // Senior: Prevent rapid fire TTS calls that lag the UI
  Timer? _debounceTimer;
  String? _lastSpokenText;
  
  static final AudioHelper _instance = AudioHelper._internal();
  factory AudioHelper() => _instance;
  
  AudioHelper._internal() {
    _initHelper();
  }

  bool _isMuted = false;
  double _speechRate = 0.5;

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
  double get speechRate => _speechRate;

  void setSpeechRate(double rate) {
    _speechRate = rate.clamp(0.2, 1.0);
    _tts.setSpeechRate(_speechRate);
    debugPrint('🔊 [AudioHelper] Speech rate set to: $_speechRate');
  }

  Future<void> _initHelper() async {
    if (_isTtsInitialized) return;
    try {
      _player = AudioPlayer();
      _isPlayerInitialized = true;
      
      await _tts.setVolume(1.0);
      await _tts.setSpeechRate(0.45); // Senior: 0.45 is more stable across engines
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
    if (isMuted || text.isEmpty) return;
    
    // Prevent duplicate calls in rapid succession
    if (_debounceTimer?.isActive ?? false) {
      if (_lastSpokenText == text) return; 
      _debounceTimer?.cancel();
    }
    
    _lastSpokenText = text;
    _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      try {
        if (!_isTtsInitialized) await _initHelper();
        String locale = _normalizeLocale(langCode, text);
        final dynamic avail = await _tts.isLanguageAvailable(locale);
        if (avail is! bool || !avail) locale = 'en-US';

        await _tts.stop();
        await _tts.setLanguage(locale);
        await _tts.setVolume(1.0);
        await _tts.setPitch(1.0);
        await _tts.setSpeechRate(_speechRate);
        await _tts.speak(text);
        debugPrint('🔊 [AudioHelper] Speaking: $text in $locale');
      } catch (e) {
        debugPrint('🔊 [AudioHelper] TTS Exception: $e');
      }
    });
  }

  String _normalizeLocale(String? code, String text) {
    if (code != null) {
      final c = code.toLowerCase();
      if (c.contains('uz')) return 'uz-UZ';
      if (c.contains('ru')) return 'ru-RU';
      if (c.contains('en')) return 'en-US';
    }
    return RegExp(r'[а-яА-ЯёЁ]').hasMatch(text) ? 'ru-RU' : 'en-US';
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
    } catch (_) {}
  }

  void dispose() {
    stopAll();
    if (_isPlayerInitialized) {
      _player.dispose();
      _isPlayerInitialized = false;
    }
  }
}
