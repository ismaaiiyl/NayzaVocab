import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';
import 'dart:async';
import 'dart:io' show Platform;

class AudioHelper {
  final FlutterTts _tts = FlutterTts();
  late AudioPlayer _player;
  bool _isPlayerInitialized = false;
  
  static final AudioHelper _instance = AudioHelper._internal();
  factory AudioHelper() => _instance;
  
  AudioHelper._internal() {
    _initHelper();
  }

  bool _isMuted = false;
  
  // Strict setter to ensure global state consistency
  set isMuted(bool value) {
    if (_isMuted == value) return;
    _isMuted = value;
    debugPrint("🔊 [AudioHelper] Mute state changed to $_isMuted");
    if (_isMuted) {
      _stopAll();
    }
  }

  bool get isMuted => _isMuted;

  Future<void> _initHelper() async {
    try {
      _player = AudioPlayer();
      _isPlayerInitialized = true;
      
      await _tts.setVolume(1.0);
      await _tts.setSpeechRate(0.5);
      await _tts.setPitch(1.0);
      
      if (kIsWeb) {
        debugPrint("🔊 [AudioHelper] Initializing for Web...");
        Future.delayed(const Duration(seconds: 1), () async {
           final voices = await _tts.getVoices;
           if (voices != null && voices.isNotEmpty) {
             debugPrint("🔊 [AudioHelper] TTS Voices ready: ${voices.length}");
           }
        });
      } else if (Platform.isAndroid) {
         await _tts.setEngine("com.google.android.tts");
      }
    } catch (e) {
      debugPrint("🔊 [AudioHelper] Init Error: $e");
    }
  }

  Future<void> _stopAll() async {
    try {
      await _tts.stop();
      if (_isPlayerInitialized) {
        await _player.stop();
      }
    } catch (e) {
      debugPrint("🔊 [AudioHelper] Stop Error: $e");
    }
  }

  Future<void> speak(String text, {String? langCode}) async {
    if (isMuted) return;

    try {
      String locale = _normalizeLocale(langCode);
      debugPrint("🔊 [AudioHelper] Speaking ($locale): $text");
      
      await _tts.stop();
      if (isMuted) return;

      await _tts.setLanguage(locale);
      await _tts.setVolume(1.0);
      await _tts.setSpeechRate(0.45);
      
      await _tts.speak(text);
    } catch (e) {
      debugPrint("🔊 [AudioHelper] TTS Exception: $e");
    }
  }

  String _normalizeLocale(String? code) {
    if (code == null) return 'en-US';
    if (code.contains('ar')) return 'ar-SA';
    if (code.contains('ru')) return 'ru-RU';
    if (code.contains('en')) return 'en-US';
    return code;
  }

  Future<void> playSuccess() async {
    if (isMuted) return;
    debugPrint("🔊 [AudioHelper] Playing success.mp3");
    try {
      _vibrate(duration: 60);
      await _guardedPlay('audio/success.mp3');
    } catch (e) {
      debugPrint("🔊 [AudioHelper] playSuccess Error: $e");
    }
  }

  Future<void> playError() async {
    if (isMuted) return;
    debugPrint("🔊 [AudioHelper] Playing error.mp3");
    try {
      _vibrate(pattern: [0, 100, 50, 100]);
      await _guardedPlay('audio/error.mp3');
    } catch (e) {
      debugPrint("🔊 [AudioHelper] playError Error: $e");
    }
  }

  Future<void> playToggle(bool mute) async {
    debugPrint("🔊 [AudioHelper] playToggle (mute=$mute)");
    if (mute) {
      _vibrate(duration: 100, amplitude: 128);
      return;
    }
    
    try {
      _vibrate(duration: 40);
      await _guardedPlay('audio/sound.mp3');
    } catch (e) {
      debugPrint("🔊 [AudioHelper] playToggle Error: $e");
    }
  }

  /// Guards player calls against WebAudioErrors and disposed states
  Future<void> _guardedPlay(String assetPath) async {
    if (!_isPlayerInitialized) {
      debugPrint("🔊 [AudioHelper] Player not initialized. Attempting re-init...");
      _player = AudioPlayer();
      _isPlayerInitialized = true;
    }

    try {
      // For Web, stop() on an uninitialized/disposed player can throw. 
      // We try to stop but ignore errors if it fails.
      try {
        await _player.stop();
      } catch (_) {}
      
      await _player.play(AssetSource(assetPath));
    } on PlatformException catch (pe) {
      debugPrint("🔊 [AudioHelper] PlatformException in _guardedPlay: ${pe.message}");
      // If player is broken, try creating a new instance for the next time
      _player = AudioPlayer();
    } catch (e) {
      debugPrint("🔊 [AudioHelper] Error in _guardedPlay: $e");
    }
  }

  Future<void> _vibrate({int duration = 50, List<int>? pattern, int amplitude = -1}) async {
    try {
      final hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        if (pattern != null) {
          await Vibration.vibrate(pattern: pattern);
        } else {
          await Vibration.vibrate(duration: duration, amplitude: amplitude);
        }
      }
    } catch (e) {
      debugPrint("🔊 [AudioHelper] Vibration Error: $e");
    }
  }

  void dispose() {
    debugPrint("🔊 [AudioHelper] Disposing instance...");
    _tts.stop();
    if (_isPlayerInitialized) {
      _player.dispose();
      _isPlayerInitialized = false;
    }
  }
}
