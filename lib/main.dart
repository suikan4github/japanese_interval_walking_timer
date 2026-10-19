import 'dart:ui' as ui;

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:japanese_interval_walking_timer/l10n/app_localizations.dart';
import 'package:japanese_interval_walking_timer/screens/home_screen.dart';
import 'package:japanese_interval_walking_timer/services/announcer.dart';
import 'package:japanese_interval_walking_timer/services/background_service.dart';
import 'package:japanese_interval_walking_timer/services/settings_provider.dart';
import 'package:japanese_interval_walking_timer/services/walking_timer_controller.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Debug override of the UI/speech language, e.g.
/// `flutter run --dart-define=LOCALE=en`. Empty means follow the OS.
const String _localeOverride = String.fromEnvironment('LOCALE');

Locale? get _forcedLocale =>
    _localeOverride.isEmpty ? null : Locale(_localeOverride);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    MyApp(
      settings: SettingsProvider(prefs),
      announcer: TtsAnnouncer(),
      backgroundService: ForegroundBackgroundService(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    required this.settings,
    required this.announcer,
    required this.backgroundService,
  });

  final SettingsProvider settings;
  final Announcer announcer;
  final BackgroundService backgroundService;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final WalkingTimerController _timer = WalkingTimerController(
    announcer: widget.announcer,
    settings: widget.settings,
    languageCode: () =>
        _forcedLocale?.languageCode ??
        ui.PlatformDispatcher.instance.locale.languageCode,
  );

  @override
  void dispose() {
    _timer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: widget.settings),
        ChangeNotifierProvider.value(value: _timer),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) => DynamicColorBuilder(
          builder: (lightDynamic, _) => MaterialApp(
            onGenerateTitle: (context) =>
                AppLocalizations.of(context)!.appTitle,
            theme: ThemeData(
              // Falls back to the custom seed where system colors are unavailable.
              colorScheme: settings.followSystem && lightDynamic != null
                  ? lightDynamic.harmonized()
                  : ColorScheme.fromSeed(
                      seedColor: settings.seedColor,
                      dynamicSchemeVariant: settings.schemeVariant,
                    ),
            ),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            locale: _forcedLocale,
            supportedLocales: AppLocalizations.supportedLocales,
            home: HomeScreen(backgroundService: widget.backgroundService),
          ),
        ),
      ),
    );
  }
}
