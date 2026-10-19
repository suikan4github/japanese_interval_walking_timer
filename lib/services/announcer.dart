import 'package:audio_session/audio_session.dart';
import 'package:flutter_tts/flutter_tts.dart';

abstract class Announcer {
  Future<void> speak(
    String text, {
    required String languageCode,
    required double volume,
  });
  Future<void> dispose();
}

/// Speaks with Android TTS while requesting transient audio focus with ducking,
/// so other apps' audio is lowered during an announcement.
class TtsAnnouncer implements Announcer {
  final FlutterTts _tts = FlutterTts();
  Future<void> _queue = Future.value();
  bool _initialized = false;

  Future<void> _init() async {
    if (_initialized) return;
    _initialized = true;
    await _tts.awaitSpeakCompletion(true);
    await _tts.setAudioAttributesForNavigation();
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
  }

  @override
  Future<void> speak(
    String text, {
    required String languageCode,
    required double volume,
  }) {
    _queue = _queue
        .then((_) => _speak(text, languageCode, volume))
        .catchError((_) {});
    return _queue;
  }

  Future<void> _speak(String text, String languageCode, double volume) async {
    await _init();
    final session = await AudioSession.instance;
    await session.setActive(true);
    await _tts.setLanguage(languageCode == 'ja' ? 'ja-JP' : 'en-US');
    await _tts.setVolume(volume);
    await _tts.speak(text);
    await session.setActive(false);
  }

  @override
  Future<void> dispose() => _tts.stop();
}
