import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter_tts/flutter_tts.dart';

abstract class Announcer {
  Future<void> speak(
    String text, {
    required String languageCode,
    required double volume,
    Duration pauseBefore = Duration.zero,
  });

  /// Acquires audio focus ahead of an utterance so it starts without delay.
  Future<void> prepare();
  Future<void> dispose();
}

/// Speaks with Android TTS while requesting transient audio focus with ducking,
/// so other apps' audio is lowered during an announcement.
class TtsAnnouncer implements Announcer {
  final FlutterTts _tts = FlutterTts();
  Future<void> _queue = Future.value();
  bool _initialized = false;
  bool _focusHeld = false;
  Timer? _releaseTimer;
  String? _language;
  double? _volume;

  /// Focus is kept briefly after an utterance so that consecutive ones, such
  /// as a countdown, do not repeatedly take and drop it.
  static const Duration focusHoldTime = Duration(milliseconds: 1500);

  Future<void> _init() async {
    if (_initialized) return;
    _initialized = true;
    await _tts.awaitSpeakCompletion(true);
    await _tts.setAudioAttributesForNavigation();
    final session = await AudioSession.instance;
    // speech() requests a permanent focus gain, after which other apps never
    // resume. A transient request lets them resume when it is abandoned.
    await session.configure(
      const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playback,
        avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.duckOthers,
        avAudioSessionMode: AVAudioSessionMode.spokenAudio,
        androidAudioAttributes: AndroidAudioAttributes(
          contentType: AndroidAudioContentType.speech,
          usage: AndroidAudioUsage.assistanceNavigationGuidance,
        ),
        androidAudioFocusGainType:
            AndroidAudioFocusGainType.gainTransientMayDuck,
      ),
    );
  }

  @override
  Future<void> speak(
    String text, {
    required String languageCode,
    required double volume,
    Duration pauseBefore = Duration.zero,
  }) {
    _queue = _queue
        .then((_) => _speak(text, languageCode, volume, pauseBefore))
        .catchError((_) {});
    return _queue;
  }

  @override
  Future<void> prepare() {
    _queue = _queue.then((_) => _acquireFocus()).catchError((_) {});
    return _queue;
  }

  Future<void> _acquireFocus() async {
    _releaseTimer?.cancel();
    await _init();
    if (!_focusHeld) {
      final session = await AudioSession.instance;
      _focusHeld = await session.setActive(true);
    }
    _releaseTimer = Timer(focusHoldTime, _releaseFocus);
  }

  Future<void> _speak(
    String text,
    String languageCode,
    double volume,
    Duration pauseBefore,
  ) async {
    await _acquireFocus();
    _releaseTimer?.cancel();
    if (pauseBefore > Duration.zero) await Future.delayed(pauseBefore);
    final language = languageCode == 'ja' ? 'ja-JP' : 'en-US';
    if (language != _language) {
      await _tts.setLanguage(language);
      _language = language;
    }
    if (volume != _volume) {
      await _tts.setVolume(volume);
      _volume = volume;
    }
    await _tts.speak(text);
    _releaseTimer = Timer(focusHoldTime, _releaseFocus);
  }

  Future<void> _releaseFocus() async {
    _releaseTimer?.cancel();
    if (!_focusHeld) return;
    _focusHeld = false;
    final session = await AudioSession.instance;
    await session.setActive(false);
  }

  @override
  Future<void> dispose() async {
    await _tts.stop();
    await _releaseFocus();
  }
}
