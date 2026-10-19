import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:japanese_interval_walking_timer/main.dart';
import 'package:japanese_interval_walking_timer/services/announcer.dart';
import 'package:japanese_interval_walking_timer/services/background_service.dart';
import 'package:japanese_interval_walking_timer/services/settings_provider.dart';
import 'package:japanese_interval_walking_timer/services/walking_timer_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeAnnouncer implements Announcer {
  final List<String> spoken = [];

  @override
  Future<void> speak(
    String text, {
    required String languageCode,
    required double volume,
  }) async => spoken.add(text);

  @override
  Future<void> dispose() async {}
}

class FakeBackground implements BackgroundService {
  final List<String> calls = [];

  @override
  Future<void> start(String title, String text) async => calls.add('start');

  @override
  Future<void> update(String title, String text) async => calls.add('update');

  @override
  Future<void> stop() async => calls.add('stop');
}

Future<SettingsProvider> makeSettings() async {
  SharedPreferences.setMockInitialValues({});
  return SettingsProvider(await SharedPreferences.getInstance());
}

void main() {
  group('WalkingTimerController', () {
    late FakeAnnouncer announcer;
    late WalkingTimerController c;

    setUp(() async {
      announcer = FakeAnnouncer();
      c = WalkingTimerController(
        announcer: announcer,
        settings: await makeSettings(),
        languageCode: () => 'ja',
      );
    });

    tearDown(() => c.dispose());

    void ticks(int n) {
      for (var i = 0; i < n; i++) {
        c.tick();
      }
    }

    test('announces lap start in Japanese on start', () {
      c.start();
      expect(announcer.spoken, ['第1ラップです。ゆっくり歩いてください']);
    });

    test('counts down the last 3 seconds of each half and announces fast', () {
      c.start();
      announcer.spoken.clear();
      ticks(180);
      expect(announcer.spoken, ['3', '2', '1', '早足で歩いてください']);
      expect(c.isFastHalf, isTrue);
      announcer.spoken.clear();
      ticks(180);
      expect(announcer.spoken.sublist(0, 3), ['3', '2', '1']);
      expect(c.lap, 2);
      expect(announcer.spoken.last, '第2ラップです。ゆっくり歩いてください');
      expect(c.elapsedInLap, 0);
    });

    test('finishes after 10 laps and resets', () {
      c.start();
      ticks(WalkingTimerController.lapSeconds * 10);
      expect(c.status, TimerStatus.idle);
      expect(announcer.spoken.last, 'すべてのラップが終了しました。お疲れさまでした');
      expect(c.lap, 1);
    });

    test('pause keeps state and resume does not re-announce', () {
      c.start();
      ticks(10);
      c.pause();
      ticks(10);
      expect(c.elapsedInLap, 10);
      announcer.spoken.clear();
      c.start();
      expect(announcer.spoken, isEmpty);
      expect(c.status, TimerStatus.running);
    });

    test('stop clears state', () {
      c.start();
      ticks(200);
      c.stop();
      expect(c.status, TimerStatus.idle);
      expect(c.lap, 1);
      expect(c.elapsedInLap, 0);
    });

    test('uses English for non-Japanese languages', () async {
      final en = WalkingTimerController(
        announcer: announcer,
        settings: await makeSettings(),
        languageCode: () => 'fr',
      );
      en.start();
      expect(announcer.spoken.single, 'Lap 1. Please walk slowly.');
      en.dispose();
    });
  });

  group('UI', () {
    late FakeBackground background;
    late FakeAnnouncer announcer;

    Future<void> pumpApp(WidgetTester tester) async {
      background = FakeBackground();
      announcer = FakeAnnouncer();
      tester.platformDispatcher.localesTestValue = const [Locale('en')];
      addTearDown(tester.platformDispatcher.clearAllTestValues);
      await tester.pumpWidget(
        MyApp(
          settings: await makeSettings(),
          announcer: announcer,
          backgroundService: background,
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('shows lap, icon and start/pause/stop flow', (tester) async {
      await pumpApp(tester);
      expect(find.text('1/10'), findsOneWidget);
      expect(find.byKey(const Key('slowIcon')), findsOneWidget);

      await tester.tap(find.text('Start'));
      await tester.pump();
      expect(background.calls, ['start']);

      await tester.tap(find.text('Pause'));
      await tester.pump();
      expect(background.calls, ['start', 'stop']);

      await tester.tap(find.text('Stop'));
      await tester.pumpAndSettle();
      expect(find.text('Stop the timer?'), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.text('Stop the timer?'), findsNothing);

      await tester.tap(find.text('Stop'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(find.text('1/10'), findsOneWidget);
    });

    testWidgets('settings page changes volume', (tester) async {
      await pumpApp(tester);
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();
      expect(find.text('Voice volume'), findsOneWidget);
      await tester.drag(
        find.byKey(const Key('volumeSlider')),
        const Offset(-400, 0),
      );
      await tester.pump();
      final slider = tester.widget<Slider>(
        find.byKey(const Key('volumeSlider')),
      );
      expect(slider.value, lessThan(1.0));
    });

    testWidgets('color picker only shown for custom scheme', (tester) async {
      await pumpApp(tester);
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();
      expect(find.text('Color scheme'), findsOneWidget);
      expect(find.byKey(const Key('seedColorIndicator')), findsNothing);

      await tester.tap(find.text('Custom'));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('seedColorIndicator')), findsOneWidget);

      await tester.tap(find.text('Follow system'));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('seedColorIndicator')), findsNothing);
    });
  });
}
