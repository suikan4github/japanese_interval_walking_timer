import 'package:flutter_foreground_task/flutter_foreground_task.dart';

abstract class BackgroundService {
  Future<void> start(String title, String text);
  Future<void> update(String title, String text);
  Future<void> stop();
}

/// Keeps the process (and the wake lock) alive while the screen is locked
/// or the app is in the background.
class ForegroundBackgroundService implements BackgroundService {
  bool _initialized = false;

  void _init() {
    if (_initialized) return;
    _initialized = true;
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'interval_walking_timer',
        channelName: 'Interval walking timer',
      ),
      iosNotificationOptions: const IOSNotificationOptions(),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.nothing(),
        allowWakeLock: true,
      ),
    );
  }

  @override
  Future<void> start(String title, String text) async {
    _init();
    final permission =
        await FlutterForegroundTask.checkNotificationPermission();
    if (permission != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }
    if (await FlutterForegroundTask.isRunningService) {
      await update(title, text);
      return;
    }
    await FlutterForegroundTask.startService(
      serviceId: 1,
      serviceTypes: [ForegroundServiceTypes.mediaPlayback],
      notificationTitle: title,
      notificationText: text,
    );
  }

  @override
  Future<void> update(String title, String text) async {
    if (await FlutterForegroundTask.isRunningService) {
      await FlutterForegroundTask.updateService(
        notificationTitle: title,
        notificationText: text,
      );
    }
  }

  @override
  Future<void> stop() async {
    if (await FlutterForegroundTask.isRunningService) {
      await FlutterForegroundTask.stopService();
    }
  }
}
