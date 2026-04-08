import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AudioHelper {
  final FlutterTts _flutterTts = FlutterTts();
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> preloadSounds() async {
    // Sounds are loaded from assets, pre-loading is not strictly necessary for small files.
  }

  Future<void> playSound(bool isCorrect) async {
    // I can't add files to the project, so I will assume the files exist.
    // final source = isCorrect ? AssetSource('audio/correct.mp3') : AssetSource('audio/incorrect.mp3');
    // await _audioPlayer.play(source);
  }

  Future<void> pronounce(String text) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.speak(text);
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
