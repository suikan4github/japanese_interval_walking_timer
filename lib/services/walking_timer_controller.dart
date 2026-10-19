import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:japanese_interval_walking_timer/l10n/app_localizations.dart';
import 'package:japanese_interval_walking_timer/services/announcer.dart';
import 'package:japanese_interval_walking_timer/services/settings_provider.dart';

enum TimerStatus { idle, running, paused }

class WalkingTimerController extends ChangeNotifier {
  WalkingTimerController({
    required this.announcer,
    required this.settings,
    required this.languageCode,
    this.onLapChanged,
  });

  static const int countdownSeconds = 3;
  static const Duration lapAnnouncePause = Duration(milliseconds: 500);

  final Announcer announcer;
  final SettingsProvider settings;
  final String Function() languageCode;
  final void Function(int lap)? onLapChanged;

  Timer? _timer;
  TimerStatus _status = TimerStatus.idle;
  int _lap = 1;
  int _elapsed = 0;

  TimerStatus get status => _status;
  int get lap => _lap;
  int get elapsedInLap => _elapsed;
  int get totalLaps => settings.totalLaps;
  int get halfSeconds => settings.halfSeconds;
  int get lapSeconds => halfSeconds * 2;
  bool get isFastHalf => _elapsed >= halfSeconds;
  double get progress => _elapsed / lapSeconds;

  AppLocalizations get _l10n =>
      lookupAppLocalizations(Locale(languageCode() == 'ja' ? 'ja' : 'en'));

  void _say(String text, {Duration pauseBefore = Duration.zero}) =>
      announcer.speak(
        text,
        languageCode: languageCode(),
        volume: settings.volume,
        pauseBefore: pauseBefore,
      );

  void start() {
    if (_status == TimerStatus.running) return;
    final fresh = _status == TimerStatus.idle;
    _status = TimerStatus.running;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => tick());
    if (fresh) _announceLapStart();
    notifyListeners();
  }

  void pause() {
    if (_status != TimerStatus.running) return;
    _timer?.cancel();
    _timer = null;
    _status = TimerStatus.paused;
    notifyListeners();
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _status = TimerStatus.idle;
    _lap = 1;
    _elapsed = 0;
    announcer.dispose();
    notifyListeners();
  }

  /// Advances the timer by one second. Exposed for tests.
  @visibleForTesting
  void tick() {
    if (_status != TimerStatus.running) return;
    _elapsed++;
    if (_elapsed >= lapSeconds) {
      if (_lap >= totalLaps) {
        _finish();
        return;
      }
      _lap++;
      _elapsed = 0;
      _announceLapStart();
    } else if (_elapsed == halfSeconds) {
      _say(_l10n.speechFastWalk);
    } else {
      final remaining = halfSeconds - _elapsed % halfSeconds;
      if (remaining == countdownSeconds + 1) announcer.prepare();
      if (remaining <= countdownSeconds) _say('$remaining');
    }
    notifyListeners();
  }

  void _announceLapStart() {
    onLapChanged?.call(_lap);
    final l10n = _l10n;
    _say(l10n.speechLap(_lap));
    _say(l10n.speechLap(_lap), pauseBefore: lapAnnouncePause);
    _say(l10n.speechSlowWalk, pauseBefore: lapAnnouncePause);
  }

  void _finish() {
    _timer?.cancel();
    _timer = null;
    _status = TimerStatus.idle;
    _lap = 1;
    _elapsed = 0;
    _say(_l10n.speechFinished);
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    announcer.dispose();
    super.dispose();
  }
}
