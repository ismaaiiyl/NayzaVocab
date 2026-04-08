import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:async';
import 'dart:io' show Platform;

class AudioHelper {
  final FlutterTts _tts = FlutterTts();
  final AudioPlayer _player = AudioPlayer();
  
  static final AudioHelper _instance = AudioHelper._internal();
  factory AudioHelper() => _instance;
  AudioHelper._internal() {
    _initHelper();
  }

  Future<void> _initHelper() async {
    try {
      await _tts.setVolume(1.0);
      await _tts.setSpeechRate(0.5);
      await _tts.setPitch(1.0);
      
      if (kIsWeb) {
        // Web diagnostics
        Future.delayed(const Duration(seconds: 1), () async {
           final voices = await _tts.getVoices;
           if (voices != null && voices.isNotEmpty) {
             print("TTS Voices loaded: ${voices.length} voices found.");
           }
        });
      } else if (Platform.isAndroid) {
         // Android specific: Ensure Google TTS engine is used if available
         // This is often required for high-quality Arabic support
         await _tts.setEngine("com.google.android.tts");
      }
    } catch (e) {
      print("AudioHelper Init Error: $e");
    }
  }

  Future<void> speak(String text, {String? langCode}) async {
    if (langCode == 'uz-UZ') return;

    try {
      String locale = _normalizeLocale(langCode);
      
      await _tts.stop();
      await _tts.setLanguage(locale);
      await _tts.setVolume(1.0);
      await _tts.setSpeechRate(0.5);
      
      // On Android, we don't usually need the timeout, but it's safe to keep
      var call = _tts.speak(text);
      
      if (kIsWeb) {
        await call.timeout(const Duration(seconds: 3));
      } else {
        await call;
      }
    } catch (e) {
      print("TTS Exception: $e");
    }
  }

  String _normalizeLocale(String? code) {
    if (code == null) return 'en-US';
    // Mapping for major supported languages
    if (code.contains('ar')) return 'ar-SA';
    if (code.contains('ru')) return 'ru-RU';
    if (code.contains('en')) return 'en-US';
    return code;
  }

  Future<void> playSuccess() async {
    if (kIsWeb) return; 
    try {
      await _player.play(AssetSource('audio/success.mp3')).timeout(const Duration(seconds: 2));
    } catch (_) {}
  }

  Future<void> playError() async {
    if (kIsWeb) return;
    try {
      await _player.play(AssetSource('audio/error.mp3')).timeout(const Duration(seconds: 2));
    } catch (_) {}
  }

  void dispose() {
    _tts.stop();
    _player.dispose();
  }
}
